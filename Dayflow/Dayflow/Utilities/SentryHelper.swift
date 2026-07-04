//
//  SentryHelper.swift
//  Dayflow
//
//  No-op stub: Sentry is disabled in this build.
//

import Foundation

// MARK: - Sentry type stubs (no-op)

/// No-op replacement for Sentry's Breadcrumb type.
final class Breadcrumb {
    enum SentryLevel { case debug, info, warning, error, fatal }
    var message: String?
    var data: [String: Any]?
    var type: String?
    init(level: SentryLevel = .info, category: String) {}
}

/// No-op replacement for Sentry's Scope type.
final class Scope {
    func setContext(value: [String: Any], key: String) {}
}

/// No-op stub replacing Sentry integration. All calls are silently ignored.
final class SentryHelper {
    static var isEnabled: Bool = false
    static func setEnabled(_ enabled: Bool) {}
    static func addBreadcrumb(_ breadcrumb: Breadcrumb) {}
    static func configureScope(_ configure: @escaping (Scope) -> Void) {}
    static func startTransaction(name: String, operation: String) -> SpanStub? { nil }
}

/// No-op stub for SentrySDK calls sprinkled through upstream code.
enum SentrySDK {
    static func start(_ configure: (Any) -> Void) {}
    static func addBreadcrumb(_ breadcrumb: Breadcrumb) {}
    static func configureScope(_ configure: @escaping (Scope) -> Void) {}
    static func startTransaction(name: String, operation: String) -> SpanStub {
        SpanStub()
    }
}

/// No-op span returned by startTransaction.
final class SpanStub {
    func finish() {}
    func finish(status: SentrySpanStatus) {}
    func setData(value: Any, key: String) {}
}

/// No-op replacement for Sentry's SpanStatus enum.
enum SentrySpanStatus {
    case ok, internalError, cancelled, unknown
}
