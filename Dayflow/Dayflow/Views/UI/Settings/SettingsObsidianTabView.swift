//
//  SettingsObsidianTabView.swift
//  Dayflow
//
//  Obsidian vault export configuration and auto-export toggle.
//

import SwiftUI
import AppKit

struct SettingsObsidianTabView: View {
    @ObservedObject var obsidianStore: ObsidianSettingsStore
    @ObservedObject var autoReportStore: AutoDailyReportSettingsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // MARK: - Vault Path
            settingsCard {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 8) {
                        Image(systemName: "folder")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black.opacity(0.55))
                        Text("Vault Folder")
                            .font(.custom("Nunito", size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(.black.opacity(0.85))
                    }

                    Text("Choose the Obsidian vault folder where daily notes will be saved as markdown files (e.g. 2026-03-06.md).")
                        .font(.custom("Nunito", size: 13))
                        .foregroundColor(.black.opacity(0.5))
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "folder.fill")
                                .font(.system(size: 12))
                                .foregroundColor(obsidianStore.settings.directoryPath.isEmpty ? .black.opacity(0.25) : Color(red: 0.45, green: 0.26, blue: 0.04))

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
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.7))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                                )
                        )

                        Button {
                            chooseFolder()
                        } label: {
                            Text("Choose…")
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
                }
            }

            // MARK: - Write Position
            settingsCard {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 8) {
                        Image(systemName: "text.insert")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black.opacity(0.55))
                        Text("Write Position")
                            .font(.custom("Nunito", size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(.black.opacity(0.85))
                    }

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
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white.opacity(0.7))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.black.opacity(0.08), lineWidth: 1)
                                        )
                                )
                        }
                    }
                }
            }

            // MARK: - Section Title
            settingsCard {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 8) {
                        Image(systemName: "textformat")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black.opacity(0.55))
                        Text("Section Title")
                            .font(.custom("Nunito", size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(.black.opacity(0.85))
                    }

                    TextField(ObsidianExportSettings.defaultTitle, text: $obsidianStore.settings.title)
                        .textFieldStyle(.plain)
                        .font(.custom("Nunito", size: 13))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.7))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                                )
                        )
                }
            }

            // MARK: - Auto Export
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
                            get: { autoReportStore.settings.isEnabled && obsidianStore.settings.isEnabled },
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

                    Text("Automatically export yesterday's journal to your vault once per day. Checks every hour in the background.")
                        .font(.custom("Nunito", size: 13))
                        .foregroundColor(.black.opacity(0.5))
                        .fixedSize(horizontal: false, vertical: true)

                    if autoReportStore.settings.isEnabled, !obsidianStore.settings.directoryPath.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            if let lastRun = autoReportStore.settings.lastRunTime {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 11))
                                        .foregroundColor(.green.opacity(0.7))
                                    Text("Last run: \(lastRun.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.custom("Nunito", size: 12))
                                        .foregroundColor(.black.opacity(0.45))
                                }
                            }
                            if let nextRun = autoReportStore.settings.nextRunTime {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 11))
                                        .foregroundColor(.black.opacity(0.35))
                                    Text("Next check: \(nextRun.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.custom("Nunito", size: 12))
                                        .foregroundColor(.black.opacity(0.45))
                                }
                            }
                        }
                    }

                    if autoReportStore.settings.isEnabled && obsidianStore.settings.directoryPath.isEmpty {
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

    // MARK: - Helpers

    private func chooseFolder() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.prompt = "Select Vault Folder"
        panel.message = "Choose your Obsidian vault folder for daily note exports."

        guard panel.runModal() == .OK, let url = panel.url else { return }

        // Store security-scoped bookmark
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

    private func abbreviatedPath(_ path: String) -> String {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        if path.hasPrefix(home) {
            return "~" + path.dropFirst(home.count)
        }
        return path
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
