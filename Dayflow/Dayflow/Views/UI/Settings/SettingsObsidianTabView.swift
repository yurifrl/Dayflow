//
//  SettingsObsidianTabView.swift
//  Dayflow
//
//  Obsidian vault export configuration, manual export button, and scheduled auto-export.
//

import SwiftUI
import AppKit

struct SettingsObsidianTabView: View {
    @ObservedObject var obsidianStore: ObsidianSettingsStore
    @ObservedObject var autoReportStore: AutoDailyReportSettingsStore

    @State private var isExporting = false
    @State private var exportResult: ExportResult?

    private enum ExportResult: Identifiable {
        case success(URL)
        case error(String)

        var id: String {
            switch self {
            case .success(let url): return "ok:\(url.path)"
            case .error(let msg): return "err:\(msg)"
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            vaultFolderCard
            writePositionCard
            sectionTitleCard
            exportCard
            autoExportCard
        }
    }

    // MARK: - Vault Folder

    private var vaultFolderCard: some View {
        settingsCard {
            VStack(alignment: .leading, spacing: 14) {
                cardHeader(icon: "folder", title: "Vault Folder")

                Text("Choose the Obsidian vault folder where daily notes will be saved as markdown files (e.g. 2026-03-06.md).")
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

    // MARK: - Write Position

    private var writePositionCard: some View {
        settingsCard {
            VStack(alignment: .leading, spacing: 14) {
                cardHeader(icon: "text.insert", title: "Write Position")

                Text("Where to insert the Dayflow section when the daily note already exists.")
                    .font(.custom("Nunito", size: 13))
                    .foregroundColor(.black.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)

                Picker("", selection: $obsidianStore.settings.writePosition) {
                    ForEach(ObsidianWritePosition.allCases) { position in
                        Text(position.label).tag(position)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()

                if obsidianStore.settings.writePosition.requiresAnchor {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Anchor text")
                            .font(.custom("Nunito", size: 12))
                            .foregroundColor(.black.opacity(0.5))

                        TextField("e.g. ## Daily Log", text: $obsidianStore.settings.anchorText)
                            .textFieldStyle(.plain)
                            .font(.custom("Nunito", size: 13))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(fieldBackground)
                    }
                }
            }
        }
    }

    // MARK: - Section Title

    private var sectionTitleCard: some View {
        settingsCard {
            VStack(alignment: .leading, spacing: 14) {
                cardHeader(icon: "textformat", title: "Section Title")

                TextField(ObsidianExportSettings.defaultTitle, text: $obsidianStore.settings.title)
                    .textFieldStyle(.plain)
                    .font(.custom("Nunito", size: 13))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(fieldBackground)
            }
        }
    }

    // MARK: - Export (manual)

    private var exportCard: some View {
        settingsCard {
            VStack(alignment: .leading, spacing: 14) {
                cardHeader(icon: "square.and.arrow.up", title: "Export")

                Text("Export yesterday's journal to your vault now.")
                    .font(.custom("Nunito", size: 13))
                    .foregroundColor(.black.opacity(0.5))

                HStack(spacing: 12) {
                    Button {
                        exportNow()
                    } label: {
                        HStack(spacing: 6) {
                            if isExporting {
                                ProgressView()
                                    .controlSize(.small)
                            } else {
                                Image(systemName: "arrow.up.doc")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            Text(isExporting ? "Exporting…" : "Export Now")
                                .font(.custom("Nunito", size: 13))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(canExport
                                    ? Color(red: 0.45, green: 0.26, blue: 0.04)
                                    : Color.black.opacity(0.15))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(!canExport || isExporting)
                    .pointingHandCursor()

                    if let result = exportResult {
                        resultBadge(result)
                    }
                }

                if !canExport {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                        Text("Choose a vault folder first.")
                            .font(.custom("Nunito", size: 12))
                            .foregroundColor(.orange.opacity(0.8))
                    }
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

                Text("Automatically export yesterday's journal at a set time each day.")
                    .font(.custom("Nunito", size: 13))
                    .foregroundColor(.black.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)

                if autoReportStore.settings.isEnabled {
                    VStack(alignment: .leading, spacing: 12) {
                        // Time picker
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

                        // Status
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
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(.orange)
                                Text("Choose a vault folder above to enable auto export.")
                                    .font(.custom("Nunito", size: 12))
                                    .foregroundColor(.orange.opacity(0.8))
                            }
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

    private func exportNow() {
        isExporting = true
        exportResult = nil

        Task {
            do {
                let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
                let viewModel = DailyJournalViewModel()

                await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                    DispatchQueue.main.async {
                        viewModel.load(for: yesterday)
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
                    isExporting = false
                    exportResult = .error("No journal data for yesterday.")
                    return
                }

                var settings = obsidianStore.settings
                let fileURL = try ObsidianExporter.export(
                    journalMarkdown: markdown,
                    for: yesterday,
                    settings: &settings
                )

                if settings.directoryBookmark != obsidianStore.settings.directoryBookmark {
                    obsidianStore.settings = settings
                }

                isExporting = false
                exportResult = .success(fileURL)
            } catch {
                isExporting = false
                exportResult = .error(error.localizedDescription)
            }
        }
    }

    // MARK: - UI Helpers

    private func abbreviatedPath(_ path: String) -> String {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        if path.hasPrefix(home) {
            return "~" + path.dropFirst(home.count)
        }
        return path
    }

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

    @ViewBuilder
    private func resultBadge(_ result: ExportResult) -> some View {
        switch result {
        case .success(let url):
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
                Text(url.lastPathComponent)
                    .font(.custom("Nunito", size: 12))
                    .foregroundColor(.black.opacity(0.6))
            }
        case .error(let msg):
            HStack(spacing: 4) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                Text(msg)
                    .font(.custom("Nunito", size: 12))
                    .foregroundColor(.red.opacity(0.8))
                    .lineLimit(2)
            }
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
}
