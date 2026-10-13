import Foundation
import SwiftUI

struct AutoDailyReportSettings: Codable, Equatable {
    var isEnabled: Bool = false
    var scheduledHour: Int = 21    // default 9 PM
    var scheduledMinute: Int = 0
    var lastRunTime: Date?
    var nextRunTime: Date?

    func normalized() -> AutoDailyReportSettings {
        var copy = self
        copy.scheduledHour = max(0, min(23, copy.scheduledHour))
        copy.scheduledMinute = max(0, min(59, copy.scheduledMinute))
        return copy
    }

    /// The scheduled time as a Date (today at the configured hour:minute).
    var scheduledDate: Date {
        get {
            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            components.hour = scheduledHour
            components.minute = scheduledMinute
            return Calendar.current.date(from: components) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            scheduledHour = components.hour ?? 21
            scheduledMinute = components.minute ?? 0
        }
    }
}

final class AutoDailyReportSettingsStore: ObservableObject {
    private let defaultsKey = "autoDailyReportSettings"
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    @Published var settings: AutoDailyReportSettings {
        didSet {
            persist(settings)
        }
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        if let data = userDefaults.data(forKey: defaultsKey),
           let decoded = try? decoder.decode(AutoDailyReportSettings.self, from: data) {
            self.settings = decoded.normalized()
        } else {
            self.settings = AutoDailyReportSettings()
        }
    }

    func reload() {
        if let data = userDefaults.data(forKey: defaultsKey),
           let decoded = try? decoder.decode(AutoDailyReportSettings.self, from: data) {
            self.settings = decoded.normalized()
        }
    }

    private func persist(_ settings: AutoDailyReportSettings) {
        guard let data = try? encoder.encode(settings) else { return }
        userDefaults.set(data, forKey: defaultsKey)
    }
}
