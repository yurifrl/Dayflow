import Foundation
import SwiftUI

@MainActor
final class AutoDailyReportService: ObservableObject {
    static let shared = AutoDailyReportService()

    private var timer: Timer?
    private let settingsStore: AutoDailyReportSettingsStore
    private let obsidianSettingsStore: ObsidianSettingsStore

    private let checkInterval: TimeInterval = 3600 // 1 hour in seconds
    private let lastCheckKey = "autoDailyReportLastCheck"

    init(
        settingsStore: AutoDailyReportSettingsStore = AutoDailyReportSettingsStore(),
        obsidianSettingsStore: ObsidianSettingsStore = ObsidianSettingsStore()
    ) {
        self.settingsStore = settingsStore
        self.obsidianSettingsStore = obsidianSettingsStore
    }

    func start() {
        guard settingsStore.settings.isEnabled else { return }

        // Check immediately on start
        checkAndCreateReport()

        // Update next run time
        updateNextRunTime()

        // Schedule hourly checks
        timer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.checkAndCreateReport()
                self?.updateNextRunTime()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func updateNextRunTime() {
        let nextRun = Date().addingTimeInterval(checkInterval)
        settingsStore.settings.nextRunTime = nextRun
    }

    private func checkAndCreateReport() {
        guard settingsStore.settings.isEnabled else { return }
        guard obsidianSettingsStore.settings.isEnabled else { return }

        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()

        // Check if we already checked today
        let lastCheck = UserDefaults.standard.object(forKey: lastCheckKey) as? Date
        if let lastCheck = lastCheck, Calendar.current.isDateInToday(lastCheck) {
            return
        }

        // Check if yesterday's report exists
        guard let directoryURL = obsidianSettingsStore.settings.accessDirectoryURL() else {
            return
        }

        defer { ObsidianExportSettings.stopAccessingSecurityScopedResource(for: directoryURL) }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fileName = formatter.string(from: yesterday) + ".md"
        let fileURL = directoryURL.appendingPathComponent(fileName)

        let fileExists = FileManager.default.fileExists(atPath: fileURL.path)

        if !fileExists {
            createReport(for: yesterday)
        }

        // Update last check time
        let now = Date()
        UserDefaults.standard.set(now, forKey: lastCheckKey)
        settingsStore.settings.lastRunTime = now
    }

    private func createReport(for date: Date) {
        Task {
            do {
                let viewModel = DailyJournalViewModel()

                // Wait for the view model to load the data
                await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                    DispatchQueue.main.async {
                        viewModel.load(for: date)

                        // Poll until loading completes (with timeout)
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

                // Update settings if bookmark was created
                if settings.directoryBookmark != obsidianSettingsStore.settings.directoryBookmark {
                    obsidianSettingsStore.settings = settings
                }

                print("Auto-created daily report for \(date): \(fileURL.path)")
            } catch {
                print("Failed to auto-create daily report: \(error)")
            }
        }
    }
}