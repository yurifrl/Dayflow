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

    func start() {
        stop()
        guard settingsStore.settings.isEnabled else { return }
        scheduleNextRun()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        settingsStore.settings.nextRunTime = nil
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

        // Build today's scheduled time
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = settings.scheduledHour
        components.minute = settings.scheduledMinute
        components.second = 0

        guard var scheduledTime = calendar.date(from: components) else { return }

        // If today's time already passed and we already exported today, schedule for tomorrow
        let todayString = dayString(now)
        let lastExportDay = UserDefaults.standard.string(forKey: lastExportDayKey)

        if scheduledTime <= now {
            if lastExportDay == todayString {
                // Already exported today, schedule tomorrow
                scheduledTime = calendar.date(byAdding: .day, value: 1, to: scheduledTime) ?? scheduledTime
            }
            // else: time passed but haven't exported today — run now
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

        // Schedule tomorrow's run
        scheduleNextRun()
    }

    // MARK: - Export

    private func exportYesterday() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        createReport(for: yesterday)
    }

    private func createReport(for date: Date) {
        Task {
            do {
                let viewModel = DailyJournalViewModel()

                await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                    DispatchQueue.main.async {
                        viewModel.load(for: date)

                        var attempts = 0
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            attempts += 1
                            if !viewModel.isLoading || attempts > 100 {
                                timer.invalidate()
                                continuation.resume()
                            }
                        }
                    }
                }

                let markdown = viewModel.markdown
                guard !markdown.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    return
                }

                var settings = obsidianSettingsStore.settings
                let fileURL = try ObsidianExporter.export(
                    journalMarkdown: markdown,
                    for: date,
                    settings: &settings
                )

                if settings.directoryBookmark != obsidianSettingsStore.settings.directoryBookmark {
                    obsidianSettingsStore.settings = settings
                }

                print("Auto-exported daily report for \(date): \(fileURL.path)")
            } catch {
                print("Failed to auto-export daily report: \(error)")
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
