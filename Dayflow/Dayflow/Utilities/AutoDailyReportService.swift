import Foundation
import SwiftUI

@MainActor
final class AutoDailyReportService: ObservableObject {
    static let shared = AutoDailyReportService()

    private var timer: Timer?
    private let settingsStore: AutoDailyReportSettingsStore
    private let obsidianSettingsStore: ObsidianSettingsStore

    private let lastExportDayKey = "autoDailyReportLastExportDay"

    init(
        settingsStore: AutoDailyReportSettingsStore = AutoDailyReportSettingsStore(),
        obsidianSettingsStore: ObsidianSettingsStore = ObsidianSettingsStore()
    ) {
        self.settingsStore = settingsStore
        self.obsidianSettingsStore = obsidianSettingsStore
    }

    /// Re-read settings from UserDefaults so the service picks up changes made by the UI.
    func reloadSettings() {
        settingsStore.reload()
        obsidianSettingsStore.reload()
    }

    func start() {
        reloadSettings()
        stopTimer()
        guard settingsStore.settings.isEnabled else { return }
        scheduleNextRun()
    }

    func stop() {
        stopTimer()
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    /// Reschedule after settings change (e.g. time picker updated).
    func reschedule() {
        start()
    }

    // MARK: - Scheduling

    private func scheduleNextRun() {
        let now = Date()
        let calendar = Calendar.current
        let settings = settingsStore.settings

        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = settings.scheduledHour
        components.minute = settings.scheduledMinute
        components.second = 0

        guard var scheduledTime = calendar.date(from: components) else { return }

        let todayString = dayString(now)
        let lastExportDay = UserDefaults.standard.string(forKey: lastExportDayKey)

        if scheduledTime <= now {
            if lastExportDay == todayString {
                scheduledTime = calendar.date(byAdding: .day, value: 1, to: scheduledTime) ?? scheduledTime
            }
        }

        let delay = max(1, scheduledTime.timeIntervalSince(now))
        settingsStore.settings.nextRunTime = scheduledTime

        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.fireExport()
            }
        }
    }

    private func fireExport() {
        reloadSettings()
        guard settingsStore.settings.isEnabled else { return }
        guard obsidianSettingsStore.settings.isEnabled else {
            scheduleNextRun()
            return
        }

        let today = dayString(Date())
        let lastExportDay = UserDefaults.standard.string(forKey: lastExportDayKey)

        if lastExportDay != today {
            exportYesterday()
            UserDefaults.standard.set(today, forKey: lastExportDayKey)
            settingsStore.settings.lastRunTime = Date()
        }

        scheduleNextRun()
    }

    // MARK: - Export

    private func exportYesterday() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let normalizedDate = timelineDisplayDate(from: yesterday)
        let dayStr = dayString(normalizedDate)

        Task.detached(priority: .userInitiated) {
            let dayString = dayStr
            let cards = StorageManager.shared.fetchTimelineCards(forDay: dayString)

            guard !cards.isEmpty else {
                print("[AutoExport] No cards for \(dayString), skipping.")
                return
            }

            let markdown = TimelineClipboardFormatter.makeMarkdown(for: normalizedDate, cards: cards)

            await MainActor.run {
                guard let directoryURL = self.obsidianSettingsStore.settings.accessDirectoryURL() else {
                    print("[AutoExport] Could not access vault folder.")
                    return
                }
                defer { ObsidianExportSettings.stopAccessingSecurityScopedResource(for: directoryURL) }

                let fmt = DateFormatter()
                fmt.dateFormat = "yyyy-MM-dd"
                let dateStr = fmt.string(from: normalizedDate)
                let fileName = "Dayflow timeline \(dateStr) to \(dateStr).md"
                let fileURL = directoryURL.appendingPathComponent(fileName)

                do {
                    try markdown.write(to: fileURL, atomically: true, encoding: .utf8)
                    print("[AutoExport] Saved \(fileURL.lastPathComponent)")
                } catch {
                    print("[AutoExport] Failed to write: \(error)")
                }
            }
        }
    }

    // MARK: - Helpers

    private func dayString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
