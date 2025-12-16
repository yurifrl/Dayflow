import Foundation
import SwiftUI

struct AutoDailyReportSettings: Codable, Equatable {
    var isEnabled: Bool = false
    var lastRunTime: Date?
    var nextRunTime: Date?

    func normalized() -> AutoDailyReportSettings {
        return self
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

    private func persist(_ settings: AutoDailyReportSettings) {
        guard let data = try? encoder.encode(settings) else { return }
        userDefaults.set(data, forKey: defaultsKey)
    }
}