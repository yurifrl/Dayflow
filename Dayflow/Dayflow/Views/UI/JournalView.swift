import SwiftUI
import AppKit

struct JournalView: View {
    @Binding var selectedDate: Date
    @Binding var showDatePicker: Bool
    @Binding var lastDateNavMethod: String?
    @Binding var previousDate: Date

    @EnvironmentObject private var categoryStore: CategoryStore
    @EnvironmentObject private var obsidianSettingsStore: ObsidianSettingsStore
    @StateObject private var viewModel = DailyJournalViewModel()
    @State private var statusMessage: JournalStatusMessage?
    @State private var statusTask: Task<Void, Never>?
    @State private var didAppear = false

    private static let dateDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter
    }()

    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header
                .padding(.horizontal, 10)

            DateNavigationControls(
                selectedDate: $selectedDate,
                showDatePicker: $showDatePicker,
                lastDateNavMethod: $lastDateNavMethod,
                previousDate: $previousDate
            )
            .padding(.horizontal, 10)

            if let message = statusMessage {
                JournalStatusBanner(message: message)
                    .padding(.horizontal, 10)
            }

            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(0.97))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color(hex: "E5E5E5"), lineWidth: 1)
                    )

                content
                    .padding(22)
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            guard !didAppear else { return }
            didAppear = true
            viewModel.load(for: selectedDate)
        }
        .onChange(of: selectedDate) { newValue in
            viewModel.load(for: newValue)
        }
        .onDisappear {
            statusTask?.cancel()
            statusTask = nil
            viewModel.cancelInFlightLoad()
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Daily Journal")
                    .font(.custom("InstrumentSerif-Regular", size: 42))
                    .foregroundColor(.black.opacity(0.95))

                Text(Self.dateDisplayFormatter.string(from: selectedDate))
                    .font(.custom("Nunito", size: 14))
                    .foregroundColor(.black.opacity(0.6))
            }

            Spacer()

            HStack(spacing: 10) {
                JournalActionButton(
                    title: "Copy",
                    systemImage: "doc.on.doc",
                    style: .secondary,
                    isDisabled: viewModel.isLoading || viewModel.markdown.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                    action: copyJournal
                )

                JournalActionButton(
                    title: "Export",
                    systemImage: "arrow.down.doc",
                    style: .primary,
                    isDisabled: viewModel.isLoading || viewModel.markdown.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                    action: exportJournal
                )
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            VStack(spacing: 12) {
                ProgressView()
                Text("Collecting your journal for this day…")
                    .font(.custom("Nunito", size: 13))
                    .foregroundColor(.black.opacity(0.6))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.entries.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "moon.zzz.fill")
                    .font(.system(size: 34))
                    .foregroundColor(Color(hex: "FF7506"))
                Text("No journal entries yet")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black.opacity(0.75))
                Text("Once Dayflow finishes analyzing a few timeline cards for this date, your journal will appear here with the new export options.")
                    .font(.custom("Nunito", size: 13))
                    .foregroundColor(.black.opacity(0.58))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 360)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 18) {
                    ForEach(viewModel.entries) { entry in
                        JournalEntryCard(
                            entry: entry,
                            accentColor: accentColor(for: entry)
                        )
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private func copyJournal() {
        let text = viewModel.markdown.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
            showStatus("Nothing to copy yet.", tint: Color(hex: "E91515"))
            return
        }
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        showStatus("Copied journal to clipboard.", tint: Color(hex: "0F9154"))
    }

    private func exportJournal() {
        let journalText = viewModel.markdown.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !journalText.isEmpty else {
            showStatus("Nothing to export yet.", tint: Color(hex: "E91515"))
            return
        }

        Task { @MainActor in
            var settings = obsidianSettingsStore.settings
            do {
                let fileURL = try ObsidianExporter.export(
                    journalMarkdown: journalText,
                    for: selectedDate,
                    settings: &settings
                )
                // Update the settings store if it was modified (e.g., new bookmark was created)
                obsidianSettingsStore.settings = settings
                showStatus("Exported to \(fileURL.lastPathComponent).", tint: Color(hex: "0F9154"))
            } catch let error as ObsidianExportError {
                showStatus(error.localizedDescription, tint: Color(hex: "E91515"))
            } catch {
                showStatus("Unable to export journal (\(error.localizedDescription)).", tint: Color(hex: "E91515"))
            }
        }
    }

    private func showStatus(_ text: String, tint: Color) {
        statusTask?.cancel()
        let message = JournalStatusMessage(text: text, tint: tint)
        statusMessage = message
        statusTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            if !Task.isCancelled {
                statusMessage = nil
            }
        }
    }

    private func accentColor(for entry: DailyJournalEntry) -> Color {
        let normalizedCategory = entry.category.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if let match = categoryStore.categories.first(where: { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == normalizedCategory }),
           let baseNSColor = NSColor(hex: match.colorHex)?.blended(withFraction: 0.2, of: .white) {
            return Color(nsColor: baseNSColor)
        }
        return Color(hex: "FF7506")
    }
}

private struct JournalStatusMessage: Identifiable {
    let id = UUID()
    let text: String
    let tint: Color
}

private struct JournalStatusBanner: View {
    let message: JournalStatusMessage

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(message.tint)
                .font(.system(size: 14, weight: .semibold))
            Text(message.text)
                .font(.custom("Nunito", size: 12))
                .foregroundColor(.black.opacity(0.75))
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(message.tint.opacity(0.12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(message.tint.opacity(0.2), lineWidth: 1)
        )
    }
}

private struct JournalActionButton: View {
    enum Style { case primary, secondary }

    let title: String
    let systemImage: String
    let style: Style
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .labelStyle(.titleAndIcon)
                .font(.system(size: 13, weight: .semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(background)
                .foregroundColor(foreground)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.45 : 1.0)
    }

    private var background: Color {
        switch style {
        case .primary:
            return Color(hex: "FF7506")
        case .secondary:
            return Color.black.opacity(0.08)
        }
    }

    private var foreground: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return .black.opacity(0.82)
        }
    }
}

private struct JournalEntryCard: View {
    let entry: DailyJournalEntry
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(timeRange)
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(accentColor)
                    Text(entry.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black.opacity(0.9))
                }
                Spacer()
                if !entry.category.isEmpty {
                    Text(entry.category)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(accentColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(accentColor.opacity(0.16))
                        )
                }
            }

            Text(entry.summary)
                .font(.system(size: 13))
                .foregroundColor(.black.opacity(0.82))
                .fixedSize(horizontal: false, vertical: true)

            if let detail = entry.detailedSummary,
               !detail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
               detail != entry.summary {
                Text(detail)
                    .font(.system(size: 13))
                    .foregroundColor(.black.opacity(0.72))
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(alignment: .leading, spacing: 6) {
                if let apps = entry.appsSummary {
                    Label(apps, systemImage: "macwindow.on.rectangle")
                        .font(.system(size: 12))
                        .foregroundColor(.black.opacity(0.65))
                }

                if !entry.distractions.isEmpty {
                    let list = entry.distractions.map { $0.title }.joined(separator: ", ")
                    Label(list, systemImage: "exclamationmark.triangle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "C05621"))
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(accentColor.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: accentColor.opacity(0.12), radius: 16, x: 0, y: 10)
    }

    private var timeRange: String {
        let start = JournalView.timeFormatter.string(from: entry.start)
        let end = JournalView.timeFormatter.string(from: entry.end)
        return "\(start) – \(end)"
    }
}

// MARK: - View Model & Models

@MainActor
final class DailyJournalViewModel: ObservableObject {
    @Published private(set) var entries: [DailyJournalEntry] = []
    @Published private(set) var markdown: String = ""
    @Published private(set) var isLoading = false

    private let storage: StorageManaging
    private var loadTask: Task<Void, Never>?

    init(storage: StorageManaging = StorageManager.shared) {
        self.storage = storage
    }

    func load(for date: Date) {
        loadTask?.cancel()
        isLoading = true

        let targetDate = date
        loadTask = Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            let dayKey = Self.dayFormatter.string(from: targetDate)
            let cards = storage.fetchTimelineCards(forDay: dayKey)
            if Task.isCancelled { return }
            let entries = Self.makeEntries(from: cards, for: targetDate)
            let markdown = Self.makeMarkdown(from: entries)
            if Task.isCancelled { return }
            await MainActor.run {
                self.entries = entries
                self.markdown = markdown
                self.isLoading = false
            }
        }
    }

    func cancelInFlightLoad() {
        loadTask?.cancel()
        loadTask = nil
    }

    deinit {
        loadTask?.cancel()
    }

    private static let timeParser: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static func makeEntries(from cards: [TimelineCard], for baseDate: Date) -> [DailyJournalEntry] {
        let calendar = Calendar.current
        let startOfBaseDay = calendar.startOfDay(for: baseDate)

        func actualDate(from timeString: String) -> Date? {
            guard let parsed = timeParser.date(from: timeString) else { return nil }
            var comps = calendar.dateComponents([.hour, .minute], from: parsed)
            comps.second = 0
            guard var date = calendar.date(bySettingHour: comps.hour ?? 0,
                                           minute: comps.minute ?? 0,
                                           second: 0,
                                           of: startOfBaseDay) else { return nil }
            let hour = calendar.component(.hour, from: date)
            if hour < 4 {
                date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
            }
            return date
        }

        return cards.compactMap { card -> DailyJournalEntry? in
            guard let start = actualDate(from: card.startTimestamp),
                  let proposedEnd = actualDate(from: card.endTimestamp) else {
                return nil
            }

            var end = proposedEnd
            if end < start {
                end = calendar.date(byAdding: .minute, value: 5, to: start) ?? start
            }

            let distractions = card.distractions ?? []

            return DailyJournalEntry(
                start: start,
                end: end,
                title: card.title,
                summary: card.summary,
                detailedSummary: card.detailedSummary,
                category: card.category,
                subcategory: card.subcategory,
                distractions: distractions,
                appSites: card.appSites
            )
        }
        .sorted { $0.start < $1.start }
    }

    private static func makeMarkdown(from entries: [DailyJournalEntry]) -> String {
        guard !entries.isEmpty else { return "" }
        let timeFormatter = JournalView.timeFormatter
        let lines: [String] = entries.map { entry in
            var block: [String] = []
            let start = timeFormatter.string(from: entry.start)
            let end = timeFormatter.string(from: entry.end)
            block.append("- **\(start) – \(end)** — \(entry.title)")
            block.append("  \(entry.summary)")

            if let detail = entry.detailedSummary,
               !detail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
               detail != entry.summary {
                block.append("  \(detail)")
            }

            if let apps = entry.appsSummary {
                block.append("  _Apps_: \(apps)")
            }

            if !entry.distractions.isEmpty {
                let distractions = entry.distractions.map { $0.title }.joined(separator: ", ")
                block.append("  _Distractions_: \(distractions)")
            }

            return block.joined(separator: "\n")
        }

        return lines.joined(separator: "\n\n")
    }
}

struct DailyJournalEntry: Identifiable {
    let id = UUID()
    let start: Date
    let end: Date
    let title: String
    let summary: String
    let detailedSummary: String?
    let category: String
    let subcategory: String
    let distractions: [Distraction]
    let appSites: AppSites?

    var appsSummary: String? {
        guard let appSites else { return nil }
        let primary = appSites.primary?.trimmingCharacters(in: .whitespacesAndNewlines)
        let secondary = appSites.secondary?.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = [primary, secondary].compactMap { $0 }.filter { !$0.isEmpty }
        return parts.isEmpty ? nil : parts.joined(separator: ", ")
    }
}
