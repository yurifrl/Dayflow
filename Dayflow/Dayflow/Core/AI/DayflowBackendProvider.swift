//
//  DayflowBackendProvider.swift
//  Dayflow
//
//  Generates daily standup summaries using the local Gemini provider.
//  The remote Dayflow backend is not used in this build.
//

import AppKit
import Foundation

struct DayflowDailyGenerationRequest: Codable, Sendable {
  let day: String
  let cardsText: String
  let observationsText: String
  let priorDailyText: String
  let preferencesText: String
  let preferredOutputLanguage: String?

  init(
    day: String,
    cardsText: String,
    observationsText: String = "",
    priorDailyText: String = "",
    preferencesText: String = "",
    preferredOutputLanguage: String? = nil
  ) {
    self.day = day
    self.cardsText = cardsText
    self.observationsText = observationsText
    self.priorDailyText = priorDailyText
    self.preferencesText = preferencesText
    self.preferredOutputLanguage = preferredOutputLanguage
  }

  private enum CodingKeys: String, CodingKey {
    case day
    case cardsText = "cards_text"
    case observationsText = "observations_text"
    case priorDailyText = "prior_daily_text"
    case preferencesText = "preferences_text"
    case preferredOutputLanguage = "preferred_output_language"
  }
}

struct DayflowDailyGenerationResponse: Codable, Sendable {
  let day: String
  let highlights: [String]
  let unfinished: [String]
  let blockers: [String]
}

/// Generates daily standup summaries using the local Gemini provider.
final class DayflowBackendProvider {

  // token / endpoint kept for API compatibility but are unused
  init(token: String = "", endpoint: String = "") {}

  private func resolvedEndpointString() -> String {
    "".trimmingCharacters(in: .whitespacesAndNewlines)
      .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
  }

  private static func date(from isoString: String) -> Date? {
    let fractional = ISO8601DateFormatter()
    fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    if let date = fractional.date(from: isoString) {
      return date
    }

    let standard = ISO8601DateFormatter()
    standard.formatOptions = [.withInternetDateTime]
    return standard.date(from: isoString)
  }

  private static func isoString(from date: Date) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.string(from: date)
  }

  private static func jpegData(
    for screenshot: Screenshot,
    maxHeight: CGFloat = 720,
    quality: CGFloat = 0.85
  ) -> Data? {
    let url = URL(fileURLWithPath: screenshot.filePath)
    guard let image = NSImage(contentsOf: url) else {
      return try? Data(contentsOf: url)
    }

    let rep =
      image.representations.compactMap { $0 as? NSBitmapImageRep }.first
      ?? image.representations.first
    let pixelsWide = rep?.pixelsWide ?? Int(image.size.width)
    let pixelsHigh = rep?.pixelsHigh ?? Int(image.size.height)

    if pixelsHigh <= Int(maxHeight) {
      return try? Data(contentsOf: url)
    }

    let scale = maxHeight / CGFloat(pixelsHigh)
    let targetWidth = max(2, Int((CGFloat(pixelsWide) * scale).rounded(.toNearestOrAwayFromZero)))
    let targetHeight = Int(maxHeight)

    guard
      let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: targetWidth,
        pixelsHigh: targetHeight,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .calibratedRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
      )
    else {
      return nil
    }

    bitmap.size = NSSize(width: targetWidth, height: targetHeight)
    NSGraphicsContext.saveGraphicsState()
    defer { NSGraphicsContext.restoreGraphicsState() }

    guard let context = NSGraphicsContext(bitmapImageRep: bitmap) else {
      return nil
    }

    NSGraphicsContext.current = context
    image.draw(
      in: NSRect(x: 0, y: 0, width: CGFloat(targetWidth), height: CGFloat(targetHeight)),
      from: NSRect(origin: .zero, size: image.size),
      operation: .copy,
      fraction: 1,
      respectFlipped: true,
      hints: [.interpolation: NSImageInterpolation.high]
    )
    context.flushGraphics()

    return bitmap.representation(using: .jpeg, properties: [.compressionFactor: quality])
  }

  func generateDaily(_ request: DayflowDailyGenerationRequest) async throws
    -> DayflowDailyGenerationResponse
  {
    guard
      let apiKey = KeychainManager.shared.retrieve(for: "gemini"),
      !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    else {
      throw NSError(
        domain: "DayflowBackend", code: -2,
        userInfo: [
          NSLocalizedDescriptionKey:
            "Gemini API key not configured. Add your key in Settings → Providers."
        ])
    }

    let provider = GeminiDirectProvider(apiKey: apiKey)
    let prompt = Self.buildPrompt(from: request)
    print("[DayflowBackend] Sending standup prompt (\(prompt.count) chars) to Gemini")
    let (text, _) = try await provider.generateText(prompt: prompt)
    print("[DayflowBackend] Received response (\(text.count) chars)")
    return try Self.parseResponse(text: text, day: request.day)
  }

  // MARK: - Prompt

  private static func buildPrompt(from request: DayflowDailyGenerationRequest) -> String {
    var sections: [String] = []

    sections.append("""
      You are a personal productivity assistant. Given a person's recorded timeline activities \
      for \(request.day), generate a concise standup update.

      Return ONLY valid JSON — no markdown, no code fences, no extra text — in this exact format:
      {
        "day": "\(request.day)",
        "highlights": ["bullet 1", "bullet 2"],
        "unfinished": ["task 1", "task 2"],
        "blockers": ["blocker 1"]
      }

      Field rules:
      • highlights – 2–5 key things accomplished (past tense, concise phrases)
      • unfinished – 2–4 tasks planned or continuing today (present/future tense, concise)
      • blockers  – 0–2 impediments; use an empty array [] when there are none
      Each item is a short phrase, NOT a full sentence.
      """)

    sections.append(request.cardsText)

    let noObs = "No observations were recorded for \(request.day)."
    if !request.observationsText.isEmpty, request.observationsText != noObs {
      sections.append(request.observationsText)
    }

    if !request.priorDailyText.isEmpty {
      sections.append("Prior daily summaries for context:\n\(request.priorDailyText)")
    }

    return sections.joined(separator: "\n\n")
  }

  // MARK: - Response parsing

  private static func parseResponse(text: String, day: String) throws
    -> DayflowDailyGenerationResponse
  {
    var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)

    // Strip optional markdown code fences (```json … ```)
    if cleaned.hasPrefix("```") {
      let lines = cleaned.components(separatedBy: .newlines)
      cleaned = lines.dropFirst().joined(separator: "\n")
      if let range = cleaned.range(of: "```") {
        cleaned = String(cleaned[..<range.lowerBound])
      }
      cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Trim to the outermost JSON object
    if let start = cleaned.firstIndex(of: "{"), let end = cleaned.lastIndex(of: "}") {
      cleaned = String(cleaned[start...end])
    }

    guard let data = cleaned.data(using: .utf8) else {
      throw NSError(
        domain: "DayflowBackend", code: -3,
        userInfo: [NSLocalizedDescriptionKey: "Could not encode Gemini response as UTF-8"])
    }

    do {
      return try JSONDecoder().decode(DayflowDailyGenerationResponse.self, from: data)
    } catch {
      throw NSError(
        domain: "DayflowBackend", code: -4,
        userInfo: [
          NSLocalizedDescriptionKey:
            "Failed to parse standup JSON: \(error.localizedDescription)"
        ])
    }
  }
}
