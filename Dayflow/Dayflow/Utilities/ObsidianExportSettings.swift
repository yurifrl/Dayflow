import Foundation
import SwiftUI

enum ObsidianWritePosition: String, CaseIterable, Codable, Identifiable {
    case beginFile = "begin_file"
    case endFile = "end_file"
    case afterLine = "after_line"
    case beforeLine = "before_line"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .beginFile: return "Beginning of file"
        case .endFile: return "End of file"
        case .afterLine: return "After matching line"
        case .beforeLine: return "Before matching line"
        }
    }

    var requiresAnchor: Bool {
        switch self {
        case .afterLine, .beforeLine:
            return true
        case .beginFile, .endFile:
            return false
        }
    }
}

struct ObsidianExportSettings: Codable, Equatable {
    static let defaultTitle = "☀️ Dailyflow"

    var isEnabled: Bool = false
    var directoryPath: String = ""
    var writePosition: ObsidianWritePosition = .endFile
    var anchorText: String = ""
    var title: String = ObsidianExportSettings.defaultTitle
    var directoryBookmark: Data?

    func normalized() -> ObsidianExportSettings {
        var copy = self
        if copy.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            copy.title = ObsidianExportSettings.defaultTitle
        }
        copy.anchorText = copy.anchorText.trimmingCharacters(in: .whitespacesAndNewlines)
        copy.directoryPath = copy.directoryPath.trimmingCharacters(in: .whitespacesAndNewlines)
        return copy
    }

    var directoryURL: URL? {
        let trimmed = directoryPath.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return URL(fileURLWithPath: trimmed, isDirectory: true)
    }

    func accessDirectoryURL() -> URL? {
        guard let bookmark = directoryBookmark else {
            return directoryURL
        }

        var isStale = false
        do {
            let url = try URL(resolvingBookmarkData: bookmark, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            if !isStale {
                _ = url.startAccessingSecurityScopedResource()
                return url
            }
        } catch {
            print("Failed to resolve bookmark: \(error)")
        }

        return directoryURL
    }

    static func stopAccessingSecurityScopedResource(for url: URL?) {
        url?.stopAccessingSecurityScopedResource()
    }
}

final class ObsidianSettingsStore: ObservableObject {
    private let defaultsKey = "obsidianExportSettings"
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var isNormalizing = false

    @Published var settings: ObsidianExportSettings {
        didSet {
            guard !isNormalizing else { return }
            let normalized = settings.normalized()
            if normalized != settings {
                isNormalizing = true
                settings = normalized
                isNormalizing = false
                return
            }
            persist(normalized)
        }
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        if let data = userDefaults.data(forKey: defaultsKey),
           let decoded = try? decoder.decode(ObsidianExportSettings.self, from: data) {
            self.settings = decoded.normalized()
        } else {
            self.settings = ObsidianExportSettings()
        }
    }

    func reload() {
        if let data = userDefaults.data(forKey: defaultsKey),
           let decoded = try? decoder.decode(ObsidianExportSettings.self, from: data) {
            self.settings = decoded.normalized()
        }
    }

    private func persist(_ normalized: ObsidianExportSettings) {
        guard let data = try? encoder.encode(normalized) else { return }
        userDefaults.set(data, forKey: defaultsKey)
    }
}
