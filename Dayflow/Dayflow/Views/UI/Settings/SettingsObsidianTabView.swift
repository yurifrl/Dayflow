//
//  SettingsObsidianTabView.swift
//  Dayflow
//
//  Obsidian vault export: folder picker, date-range export, export-now, and scheduled auto-export.
//

import SwiftUI
import AppKit

struct SettingsObsidianTabView: View {
    @ObservedObject var obsidianStore: ObsidianSettingsStore
    @ObservedObject var autoReportStore: AutoDailyReportSettingsStore

    // Date-range export state
    @State private var exportStartDate: Date = timelineDisplayDate(from: Date())
    @State private var exportEndDate: Date = timelineDisplayDate(from: Date())
    @State private var activeExportDatePicker: ExportDatePicker?
    @State private var isExportingRange = false
    @State private var rangeExportMessage: String?
    @State private var rangeExportError: String?

    // Export-now state
    @State private var isExportingNow = false
    @State private var exportNowMessage: String?
    @State private var exportNowError: String?

    private enum ExportDatePicker {
        case start, end
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            vaultFolderCard
            dateRangeExportCard
            exportNowCard
            autoExportCard
        }
    }

    // MARK: - Vault Folder

    private var vaultFolderCard: some View {
        settingsCard {
            VStack(alignment: .leading, spacing: 14) {
                cardHeader(icon: "folder", title: "Vault Folder")

                Text("Choose the Obsidian vault folder where exports are saved.")
                    .font(.custom("Nunito", size: 13))
                    .foregroundColor(.black.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "folder.fill")
                            .font(.system(size: 12))
                            .foregroundColor(obsidianStore.settings.directoryPath.isEmpty
                                ? .black.opacity(0.25)
                                : Color(red: 0.45, green: 0.26, blue: 0.04))

                        if obsidianStore.settings.directoryPath.isEmpty {
                            Text("No folder selected")
                                .font(.custom("Nunito", size: 13))
                                .foregroundColor(.black.opacity(0.35))
                        } else {
                            Text(abbreviatedPath(obsidianStore.settings.directoryPath))
                                .font(.custom("Nunito", size: 13))
                                .foregroundColor(.black.opacity(0.7))
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(fieldBackground)

                    plainButton("Choose…") { chooseFolder() }
                }
            }
        }
    }

    // MARK: - Date Range Export

    private var dateRangeExportCard: some View {
        settingsCard {
            let rangeInvalid = timelineDisplayDate(from: exportStartDate) > timelineDisplayDate(from: exportEndDate)

            VStack(alignment: .leading, spacing: 14) {
                cardHeader(icon: "square.and.arrow.up", title: "Export to Vault")

                Text("Export a date range from your timeline to the vault folder.")
                    .font(.custom("Nunito", size: 13))
                    .foregroundColor(.black.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)

                // Date pickers
                HStack(alignment: .bottom, spacing: 12) {
                    datePillField(
                        label: "From",
                        date: exportStartDate,
                        isExpanded: activeExportDatePicker == .start,
                        onTap: {
                            withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
                                activeExportDatePicker = activeExportDatePicker == .start ? nil : .start
                            }
                        }
                    )

                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black.opacity(0.35))
                        .padding(.bottom, 12)

                    datePillField(
                        label: "To",
                        date: exportEndDate,
                        isExpanded: activeExportDatePicker == .end,
                        onTap: {
                            withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
                                activeExportDatePicker = activeExportDatePicker == .end ? nil : .end
                            }
                        }
                    )
                }

                if let picker = activeExportDatePicker {
                    inlineCalendarField(
                        date: exportDateBinding(for: picker),
                        onDateSelected: {
                            withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
                                activeExportDatePicker = nil
                            }
                        }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                // File preview
                if !obsidianStore.settings.directoryPath.isEmpty {
                    let fileName = exportFileName(from: exportStartDate, to: exportEndDate)
                    HStack(spacing: 6) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 11))
                            .foregroundColor(.black.opacity(0.35))
                        Text(fileName)
                            .font(.custom("Nunito", size: 12))
                            .foregroundColor(.black.opacity(0.45))
                            .italic()
                    }
                }

                HStack(spacing: 10) {
                    actionButton(
                        label: "Export as Markdown",
                        icon: "square.and.arrow.down",
                        isLoading: isExportingRange,
                        disabled: !canExport || rangeInvalid
                    ) {
                        exportRange()
                    }

                    if rangeInvalid {
                        Text("Start date must be on or before end date.")
                            .font(.custom("Nunito", size: 12))
                            .foregroundColor(Color(hex: "E91515"))
                    }
                }

                statusMessages(success: rangeExportMessage, error: rangeExportError)
            }
        }
    }

    // MARK: - Export Now

    private var exportNowCard: some View {
        settingsCard {
            VStack(alignment: .leading, spacing: 14) {
                cardHeader(icon: "arrow.clockwise", title: "Export Now")

                Text("Export from the last exported date to today. If nothing was exported before, exports today.")
                    .font(.custom("Nunito", size: 13))
                    .foregroundColor(.black.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)

                if let lastRun = autoReportStore.settings.lastRunTime {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                            .foregroundColor(.black.opacity(0.35))
                        Text("Last export: \(lastRun.formatted(date: .abbreviated, time: .shortened))")
                            .font(.custom("Nunito", size: 12))
                            .foregroundColor(.black.opacity(0.45))
                    }
                }

                HStack(spacing: 10) {
                    actionButton(
                        label: "Export Now",
                        icon: "arrow.up.doc",
                        isLoading: isExportingNow,
                        disabled: !canExport
                    ) {
                        exportNow()
                    }
                }

                statusMessages(success: exportNowMessage, error: exportNowError)

                if !canExport {
                    warningLabel("Choose a vault folder first.")
                }
            }
        }
    }

    // MARK: - Auto Export

    private var autoExportCard: some View {
        settingsCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    Image(systemName: "clock.arrow.2.circlepath")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black.opacity(0.55))
                    Text("Auto Export")
                        .font(.custom("Nunito", size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.85))

                    Spacer()

                    Toggle("", isOn: Binding(
                        get: { autoReportStore.settings.isEnabled },
                        set: { newValue in
                            autoReportStore.settings.isEnabled = newValue
                            obsidianStore.settings.isEnabled = newValue
                            if newValue {
                                AutoDailyReportService.shared.start()
                            } else {
                                AutoDailyReportService.shared.stop()
                            }
                        }
                    ))
                    .toggleStyle(.switch)
                    .labelsHidden()
                }

                Text("Automatically export yesterday's timeline at a set time each day.")
                    .font(.custom("Nunito", size: 13))
                    .foregroundColor(.black.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)

                if autoReportStore.settings.isEnabled {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 10) {
                            Text("Export at")
                                .font(.custom("Nunito", size: 13))
                                .foregroundColor(.black.opacity(0.6))

                            DatePicker(
                                "",
                                selection: Binding(
                                    get: { autoReportStore.settings.scheduledDate },
                                    set: { newDate in
                                        autoReportStore.settings.scheduledDate = newDate
                                        AutoDailyReportService.shared.reschedule()
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                            .frame(width: 100)

                            Text("every day")
                                .font(.custom("Nunito", size: 13))
                                .foregroundColor(.black.opacity(0.6))
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            if let lastRun = autoReportStore.settings.lastRunTime {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 11))
                                        .foregroundColor(.green.opacity(0.7))
                                    Text("Last export: \(lastRun.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.custom("Nunito", size: 12))
                                        .foregroundColor(.black.opacity(0.45))
                                }
                            }
                            if let nextRun = autoReportStore.settings.nextRunTime {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 11))
                                        .foregroundColor(.black.opacity(0.35))
                                    Text("Next export: \(nextRun.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.custom("Nunito", size: 12))
                                        .foregroundColor(.black.opacity(0.45))
                                }
                            }
                        }

                        if obsidianStore.settings.directoryPath.isEmpty {
                            warningLabel("Choose a vault folder above to enable auto export.")
                        }
                    }
                }
            }
        }
    }

    // MARK: - Actions

    private var canExport: Bool {
        !obsidianStore.settings.directoryPath.isEmpty
    }

    private func chooseFolder() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.prompt = "Select Vault Folder"
        panel.message = "Choose your Obsidian vault folder for daily note exports."

        guard panel.runModal() == .OK, let url = panel.url else { return }

        do {
            let bookmark = try url.bookmarkData(
                options: .withSecurityScope,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            obsidianStore.settings.directoryBookmark = bookmark
        } catch {
            print("Failed to create bookmark: \(error)")
        }

        obsidianStore.settings.directoryPath = url.path
        obsidianStore.settings.isEnabled = true
    }

    private func exportRange() {
        guard !isExportingRange else { return }
        isExportingRange = true
        rangeExportMessage = nil
        rangeExportError = nil

        let start = timelineDisplayDate(from: exportStartDate)
        let end = timelineDisplayDate(from: exportEndDate)

        Task.detached(priority: .userInitiated) {
            let result = Self.buildMarkdownExport(from: start, to: end)

            await MainActor.run {
                do {
                    let url = try writeToVault(
                        text: result.text,
                        startDate: start,
                        endDate: end
                    )
                    rangeExportMessage = "Saved \(result.activityCount) activit\(result.activityCount == 1 ? "y" : "ies") across \(result.dayCount) day\(result.dayCount == 1 ? "" : "s") → \(url.lastPathComponent)"
                    rangeExportError = nil
                } catch {
                    rangeExportMessage = nil
                    rangeExportError = error.localizedDescription
                }
                isExportingRange = false
            }
        }
    }

    private func exportNow() {
        guard !isExportingNow else { return }
        isExportingNow = true
        exportNowMessage = nil
        exportNowError = nil

        // From last export date (or today if never exported)
        let today = timelineDisplayDate(from: Date())
        let startDate: Date
        if let lastRun = autoReportStore.settings.lastRunTime {
            startDate = timelineDisplayDate(from: lastRun)
        } else {
            startDate = today
        }

        Task.detached(priority: .userInitiated) {
            let result = Self.buildMarkdownExport(from: startDate, to: today)

            await MainActor.run {
                do {
                    let url = try writeToVault(
                        text: result.text,
                        startDate: startDate,
                        endDate: today
                    )
                    autoReportStore.settings.lastRunTime = Date()
                    exportNowMessage = "Saved \(result.activityCount) activit\(result.activityCount == 1 ? "y" : "ies") across \(result.dayCount) day\(result.dayCount == 1 ? "" : "s") → \(url.lastPathComponent)"
                    exportNowError = nil
                } catch {
                    exportNowMessage = nil
                    exportNowError = error.localizedDescription
                }
                isExportingNow = false
            }
        }
    }

    // MARK: - Export Logic

    private struct ExportResult {
        let text: String
        let dayCount: Int
        let activityCount: Int
    }

    private static func buildMarkdownExport(from start: Date, to end: Date) -> ExportResult {
        let calendar = Calendar.current
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"

        var cursor = start
        var sections: [String] = []
        var totalActivities = 0
        var dayCount = 0

        while cursor <= end {
            let dayString = dayFormatter.string(from: cursor)
            let cards = StorageManager.shared.fetchTimelineCards(forDay: dayString)
            totalActivities += cards.count
            let section = TimelineClipboardFormatter.makeMarkdown(for: cursor, cards: cards)
            sections.append(section)
            dayCount += 1

            guard let next = calendar.date(byAdding: .day, value: 1, to: cursor) else { break }
            cursor = next
        }

        let text = sections.joined(separator: "\n\n---\n\n")
        return ExportResult(text: text, dayCount: dayCount, activityCount: totalActivities)
    }

    @MainActor
    private func writeToVault(text: String, startDate: Date, endDate: Date) throws -> URL {
        guard let directoryURL = obsidianStore.settings.accessDirectoryURL() else {
            throw NSError(domain: "ObsidianExport", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Could not access vault folder."])
        }
        defer { ObsidianExportSettings.stopAccessingSecurityScopedResource(for: directoryURL) }

        let fileName = exportFileName(from: startDate, to: endDate)
        let fileURL = directoryURL.appendingPathComponent(fileName)

        try text.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }

    private func exportFileName(from start: Date, to end: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return "Dayflow timeline \(fmt.string(from: timelineDisplayDate(from: start))) to \(fmt.string(from: timelineDisplayDate(from: end))).md"
    }

    // MARK: - Shared UI Components

    private func cardHeader(icon: String, title: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black.opacity(0.55))
            Text(title)
                .font(.custom("Nunito", size: 15))
                .fontWeight(.semibold)
                .foregroundColor(.black.opacity(0.85))
        }
    }

    private var fieldBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.white.opacity(0.7))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
    }

    private func plainButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.custom("Nunito", size: 13))
                .fontWeight(.medium)
                .foregroundColor(.black.opacity(0.7))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.9))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black.opacity(0.1), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
        .pointingHandCursor()
    }

    private func actionButton(label: String, icon: String, isLoading: Bool, disabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView().scaleEffect(0.75)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 13, weight: .semibold))
                }
                Text(isLoading ? "Exporting…" : label)
                    .font(.custom("Nunito", size: 13))
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(minWidth: 150)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(disabled
                        ? Color.black.opacity(0.15)
                        : Color(red: 0.25, green: 0.17, blue: 0))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(disabled || isLoading)
        .pointingHandCursor()
    }

    @ViewBuilder
    private func statusMessages(success: String?, error: String?) -> some View {
        if let msg = success {
            Text(msg)
                .font(.custom("Nunito", size: 12))
                .foregroundColor(Color(red: 0.1, green: 0.5, blue: 0.22))
        }
        if let err = error {
            Text(err)
                .font(.custom("Nunito", size: 12))
                .foregroundColor(Color(hex: "E91515"))
        }
    }

    private func warningLabel(_ text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 11))
                .foregroundColor(.orange)
            Text(text)
                .font(.custom("Nunito", size: 12))
                .foregroundColor(.orange.opacity(0.8))
        }
    }

    // MARK: - Date Picker Components (matching Export tab style)

    private func datePillField(label: String, date: Date, isExpanded: Bool, onTap: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(label)
                .font(.custom("Nunito", size: 11.5))
                .foregroundColor(.black.opacity(0.52))

            Button(action: onTap) {
                HStack(spacing: 10) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(red: 0.25, green: 0.17, blue: 0).opacity(0.75))

                    Text(Self.dateLabelFormatter.string(from: timelineDisplayDate(from: date)))
                        .font(.custom("Nunito", size: 14))
                        .foregroundColor(.black.opacity(0.82))

                    Spacer(minLength: 4)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.black.opacity(0.35))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .frame(minWidth: 176)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.88))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isExpanded ? Color(hex: "F9C36B") : Color(hex: "FFE0A5"), lineWidth: 1.2)
                        )
                )
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
            }
            .buttonStyle(.plain)
        }
    }

    private func inlineCalendarField(date: Binding<Date>, onDateSelected: @escaping () -> Void) -> some View {
        DatePicker("", selection: date, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .labelsHidden()
            .onChange(of: date.wrappedValue) { _, _ in onDateSelected() }
            .frame(maxWidth: 290, alignment: .leading)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.82))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "FFE0A5"), lineWidth: 1.2)
                    )
            )
            .shadow(color: .black.opacity(0.04), radius: 7, x: 0, y: 2)
    }

    private func exportDateBinding(for picker: ExportDatePicker) -> Binding<Date> {
        switch picker {
        case .start: return $exportStartDate
        case .end: return $exportEndDate
        }
    }

    @ViewBuilder
    private func settingsCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.black.opacity(0.06), lineWidth: 1)
                    )
            )
    }

    private static let dateLabelFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.setLocalizedDateFormatFromTemplate("MMM d, yyyy")
        return fmt
    }()

    private func abbreviatedPath(_ path: String) -> String {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        if path.hasPrefix(home) {
            return "~" + path.dropFirst(home.count)
        }
        return path
    }
}
