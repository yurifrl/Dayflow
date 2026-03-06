//
//  DayflowBackendProvider.swift
//  Dayflow
//
//  Stub: backend provider disabled in this fork.
//

import Foundation

struct DayflowDailyGenerationRequest: Codable, Sendable {
  let day: String
  let cardsText: String
  let observationsText: String
  let priorDailyText: String
  let preferencesText: String

  init(
    day: String,
    cardsText: String,
    observationsText: String = "",
    priorDailyText: String = "",
    preferencesText: String = ""
  ) {
    self.day = day
    self.cardsText = cardsText
    self.observationsText = observationsText
    self.priorDailyText = priorDailyText
    self.preferencesText = preferencesText
  }

  private enum CodingKeys: String, CodingKey {
    case day
    case cardsText = "cards_text"
    case observationsText = "observations_text"
    case priorDailyText = "prior_daily_text"
    case preferencesText = "preferences_text"
  }
}

struct DayflowDailyGenerationResponse: Codable, Sendable {
  let day: String
  let highlights: [String]
  let unfinished: [String]
  let blockers: [String]
}

/// No-op stub — the Dayflow backend is disabled in this fork.
final class DayflowBackendProvider {
  init(token: String, endpoint: String = "") {}

  func generateDaily(_ request: DayflowDailyGenerationRequest) async throws
    -> DayflowDailyGenerationResponse
  {
    throw NSError(
      domain: "DayflowBackend", code: -1,
      userInfo: [NSLocalizedDescriptionKey: "Dayflow backend is disabled in this fork."])
  }
}
