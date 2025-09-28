//
//  AnalyticsService.swift
//  Dayflow
//
//  Centralized analytics façade. In the enterprise build analytics are
//  disabled, but we keep the surface area so the rest of the app can
//  interact with it without touching network APIs.

import Foundation
import AppKit

final class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    private let optInKey = "analyticsOptIn"
    private let distinctIdKeychainKey = "analyticsDistinctId"
    private let throttleLock = NSLock()
    private var throttles: [String: Date] = [:]

    var isOptedIn: Bool {
        get {
            if UserDefaults.standard.object(forKey: optInKey) == nil {
                // Default ON per product decision
                return true
            }
            return UserDefaults.standard.bool(forKey: optInKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: optInKey)
        }
    }

    func start() {
        // Still initialize local identity so toggles behave deterministically.
        _ = ensureDistinctId()
        registerInitialSuperProperties()
        if !UserDefaults.standard.bool(forKey: "installTsSent") {
            UserDefaults.standard.set(true, forKey: "installTsSent")
        }
    }

    @discardableResult
    private func ensureDistinctId() -> String {
        if let existing = KeychainManager.shared.retrieve(for: distinctIdKeychainKey), !existing.isEmpty {
            return existing
        }
        let newId = UUID().uuidString
        _ = KeychainManager.shared.store(newId, for: distinctIdKeychainKey)
        return newId
    }

    func setOptIn(_ enabled: Bool) {
        isOptedIn = enabled
    }

    func capture(_ name: String, _ props: [String: Any] = [:]) {
        guard isOptedIn else { return }
        // No-op: analytics disabled in this build. Keep hook for future logging if needed.
    }

    func screen(_ name: String, _ props: [String: Any] = [:]) {
        // Implement as a regular capture for consistency
        capture("screen_viewed", ["screen": name].merging(props, uniquingKeysWith: { _, new in new }))
    }

    func identify(_ distinctId: String, properties: [String: Any] = [:]) {
        guard isOptedIn else { return }
        if !properties.isEmpty {
            setPersonProperties(properties)
        }
    }

    func alias(_ aliasId: String) {
        guard isOptedIn else { return }
    }

    func registerSuperProperties(_ props: [String: Any]) {
        guard isOptedIn else { return }
    }

    func setPersonProperties(_ props: [String: Any]) {
        guard isOptedIn else { return }
    }

    func throttled(_ key: String, minInterval: TimeInterval, action: () -> Void) {
        let now = Date()
        throttleLock.lock()
        defer { throttleLock.unlock() }

        if let last = throttles[key], now.timeIntervalSince(last) < minInterval { return }
        throttles[key] = now
        action()
    }

    func withSampling(probability: Double, action: () -> Void) {
        guard probability >= 1.0 || Double.random(in: 0..<1) < probability else { return }
        action()
    }

    func secondsBucket(_ seconds: Double) -> String {
        switch seconds {
        case ..<15: return "0-15s"
        case ..<60: return "15-60s"
        case ..<300: return "1-5m"
        case ..<1200: return "5-20m"
        default: return ">20m"
        }
    }

    func pctBucket(_ value: Double) -> String {
        let pct = max(0.0, min(1.0, value))
        switch pct {
        case ..<0.25: return "0-25%"
        case ..<0.5: return "25-50%"
        case ..<0.75: return "50-75%"
        default: return "75-100%"
        }
    }

    /// Track LLM validation failures (time coverage, duration, parse errors)
    func captureValidationFailure(
        provider: String,
        operation: String,
        validationType: String,
        attempt: Int,
        model: String?,
        batchId: Int64?,
        errorDetail: String?
    ) {
        var props: [String: Any] = [
            "provider": provider,
            "operation": operation,
            "validation_type": validationType,
            "attempt": attempt
        ]
        if let model = model { props["model"] = model }
        if let batchId = batchId { props["batch_id"] = batchId }
        if let errorDetail = errorDetail {
            // Truncate long error details to avoid bloating events
            props["error_detail"] = String(errorDetail.prefix(500))
        }
        capture("llm_validation_failed", props)
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func dayString(_ date: Date) -> String {
        Self.dayFormatter.string(from: date)
    }

    private func registerInitialSuperProperties() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let os = ProcessInfo.processInfo.operatingSystemVersion
        let osVersion = "macOS \(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
        let device = Host.current().localizedName ?? "Mac"
        let locale = Locale.current.identifier
        let tz = TimeZone.current.identifier

        registerSuperProperties([
            "app_version": version,
            "build_number": build,
            "os_version": osVersion,
            "device_model": device,
            "locale": locale,
            "time_zone": tz,
            // dynamic values will be updated later as needed
        ])
    }

    private func sanitize(_ props: [String: Any]) -> [String: Any] {
        // Drop known sensitive keys if ever passed by mistake
        let blocked = Set(["api_key", "token", "authorization", "file_path", "url", "window_title", "clipboard", "screen_content"]) 
        var out: [String: Any] = [:]
        for (k, v) in props {
            if blocked.contains(k) { continue }
            // Only allow primitive JSON types
            if v is String || v is Int || v is Double || v is Bool || v is NSNull {
                out[k] = v
            } else {
                // Allow string coercion for simple enums
                out[k] = String(describing: v)
            }
        }
        return out
    }

    private func iso8601Now() -> String {
        let fmt = ISO8601DateFormatter()
        fmt.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return fmt.string(from: Date())
    }
}
