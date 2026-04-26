//
//  AnalyticsService.swift
//  Dayflow
//
//  Centralized analytics façade. In the enterprise build analytics are
//  disabled, but we keep the surface area so the rest of the app can
//  interact with it without touching network APIs.

import AppKit

final class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    private let optInKey = "analyticsOptIn"
    private let backendAuthFallbackTokenKey = "localBackendAuthFallbackToken"
    private let backendAuthOverrideTokenKey = "dayflowBackendAuthTokenOverride"
    private let throttleLock = NSLock()
    private var throttles: [String: Date] = [:]

    // MARK: - Opt-in

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

    // MARK: - Lifecycle

    func start(apiKey: String, host: String) {
        // No-op: analytics disabled in this build.
    }

    func start() {
        // No-op: analytics disabled in this build.
        registerInitialSuperProperties()
    }

    func setOptIn(_ enabled: Bool) {
        isOptedIn = enabled
    }

    // MARK: - Event Capture

    func capture(_ name: String, _ props: [String: Any] = [:]) {
        guard isOptedIn else { return }
        // No-op: analytics disabled in this build.
    }

    func screen(_ name: String, _ props: [String: Any] = [:]) {
        guard isOptedIn else { return }
        // No-op: analytics disabled in this build.
    }

    // MARK: - Identity

    func identify(_ distinctId: String, properties: [String: Any] = [:]) {
        guard isOptedIn else { return }
        if !properties.isEmpty {
            setPersonProperties(properties)
        }
    }

    func alias(_ aliasId: String) {
        guard isOptedIn else { return }
    }

    // MARK: - Properties

    func registerSuperProperties(_ props: [String: Any]) {
        guard isOptedIn else { return }
    }

    func setPersonProperties(_ props: [String: Any]) {
        guard isOptedIn else { return }
    }

    // MARK: - Validation Failure Tracking

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
            "attempt": attempt,
        ]
        if let model = model { props["model"] = model }
        if let batchId = batchId { props["batch_id"] = batchId }
        if let errorDetail = errorDetail {
            // Truncate long error details to avoid bloating events
            props["error_detail"] = String(errorDetail.prefix(500))
        }
        capture("llm_validation_failed", props)
    }

    // MARK: - Sampling & Throttling

    func withSampling(probability: Double, action: () -> Void) {
        guard isOptedIn else { return }
        guard Double.random(in: 0..<1) < probability else { return }
        action()
    }

    func throttled(_ key: String, minInterval: TimeInterval, action: () -> Void) {
        guard isOptedIn else { return }
        throttleLock.lock()
        defer { throttleLock.unlock() }
        let now = Date()
        if let last = throttles[key], now.timeIntervalSince(last) < minInterval {
            return
        }
        throttles[key] = now
        action()
    }

    // MARK: - Backend Auth Token

    func backendAuthToken() -> String {
        // Check for an explicit override first (set via debug menu / defaults)
        if let override = UserDefaults.standard.string(forKey: backendAuthOverrideTokenKey),
           !override.isEmpty {
            return override
        }
        return UserDefaults.standard.string(forKey: backendAuthFallbackTokenKey) ?? ""
    }

    // MARK: - Bucket Helpers

    func pctBucket(_ value: Double) -> String {
        let pct = max(0.0, min(1.0, value))
        switch pct {
        case ..<0.25: return "0-25%"
        case ..<0.5: return "25-50%"
        case ..<0.75: return "50-75%"
        default: return "75-100%"
        }
    }

    func secondsBucket(_ seconds: Double) -> String {
        let s = max(0, Int(seconds))
        switch s {
        case 0..<5: return "0-5s"
        case 5..<15: return "5-15s"
        case 15..<30: return "15-30s"
        case 30..<60: return "30-60s"
        case 60..<300: return "1-5m"
        case 300..<900: return "5-15m"
        case 900..<1800: return "15-30m"
        case 1800..<3600: return "30-60m"
        default: return "60m+"
        }
    }

    // MARK: - Date Helpers

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func dayString(_ date: Date) -> String {
        Self.dayFormatter.string(from: date)
    }

    // MARK: - Private Helpers

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
        ])
    }

    private func sanitize(_ props: [String: Any]) -> [String: Any] {
        // Drop known sensitive keys if ever passed by mistake
        let blocked = Set([
            "api_key", "token", "authorization", "file_path", "url", "window_title", "clipboard",
            "screen_content",
        ])
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
