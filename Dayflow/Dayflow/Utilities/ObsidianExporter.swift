import Foundation
import AppKit

enum ObsidianExportError: LocalizedError {
    case settingsDisabled
    case missingDirectory
    case invalidDirectory
    case missingAnchor
    case emptyContent
    case permissionDenied(fileName: String, folderName: String)
    case writeFailed(Error)

    var errorDescription: String? {
        switch self {
        case .settingsDisabled:
            return "Enable Obsidian export in Settings before exporting."
        case .missingDirectory:
            return "Choose an export folder in Settings to continue."
        case .invalidDirectory:
            return "The configured export path is not a folder."
        case .missingAnchor:
            return "Provide the text Dayflow should insert before or after."
        case .emptyContent:
            return "Nothing to export yet for this day."
        case .permissionDenied(let fileName, let folderName):
            return "You don't have permission to save the file \"\(fileName).md\" in the folder \"\(folderName)\"."
        case .writeFailed(let error):
            return "Failed to write journal: \(error.localizedDescription)"
        }
    }
}

struct ObsidianExporter {
    private enum AnchorMode { case before, after }

    @MainActor
    private static func requestDirectoryAccess(for directoryURL: URL, settings: inout ObsidianExportSettings) throws -> URL {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.directoryURL = directoryURL
        panel.prompt = "Grant Access"
        panel.message = "Dayflow needs permission to write to this directory. Please select the folder to grant access."

        guard panel.runModal() == .OK, let selectedURL = panel.url else {
            throw ObsidianExportError.permissionDenied(
                fileName: fileName(for: Date()),
                folderName: directoryURL.lastPathComponent
            )
        }

        // Store the bookmark for future use
        do {
            let bookmark = try selectedURL.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            settings.directoryBookmark = bookmark
            settings.directoryPath = selectedURL.path
        } catch {
            print("Failed to create bookmark: \(error)")
        }

        return selectedURL
    }

    @MainActor
    static func export(journalMarkdown: String, for date: Date, settings: inout ObsidianExportSettings) throws -> URL {
        var normalizedSettings = settings.normalized()
        guard normalizedSettings.isEnabled else { throw ObsidianExportError.settingsDisabled }

        let sanitized = journalMarkdown
            .replacingOccurrences(of: "\r\n", with: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard sanitized.isEmpty == false else { throw ObsidianExportError.emptyContent }

        var directoryURL = normalizedSettings.accessDirectoryURL()
        if directoryURL == nil {
            throw ObsidianExportError.missingDirectory
        }

        // Test if we can write to the directory, if not, request access
        var accessibleDirectoryURL = directoryURL!
        defer { ObsidianExportSettings.stopAccessingSecurityScopedResource(for: accessibleDirectoryURL) }

        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        if !fileManager.fileExists(atPath: accessibleDirectoryURL.path, isDirectory: &isDirectory) {
            do {
                try fileManager.createDirectory(at: accessibleDirectoryURL, withIntermediateDirectories: true)
                isDirectory = true
            } catch {
                // If we can't create the directory, try requesting access
                if normalizedSettings.directoryBookmark == nil {
                    accessibleDirectoryURL = try requestDirectoryAccess(for: accessibleDirectoryURL, settings: &normalizedSettings)
                    settings = normalizedSettings  // Update the original settings
                    try fileManager.createDirectory(at: accessibleDirectoryURL, withIntermediateDirectories: true)
                    isDirectory = true
                } else {
                    throw error
                }
            }
        }
        guard isDirectory.boolValue else { throw ObsidianExportError.invalidDirectory }

        if normalizedSettings.writePosition.requiresAnchor && normalizedSettings.anchorText.isEmpty {
            throw ObsidianExportError.missingAnchor
        }

        let fileURL = accessibleDirectoryURL
            .appendingPathComponent(fileName(for: date))
            .appendingPathExtension("md")

        let existing = (try? String(contentsOf: fileURL, encoding: .utf8))?.replacingOccurrences(of: "\r\n", with: "\n") ?? ""
        let section = buildSection(from: sanitized, title: normalizedSettings.title)

        let updated: String
        switch normalizedSettings.writePosition {
        case .beginFile:
            updated = insert(section: section, into: existing, at: existing.startIndex)
        case .endFile:
            updated = insert(section: section, into: existing, at: existing.endIndex)
        case .afterLine:
            updated = insert(section: section, existing: existing, anchor: normalizedSettings.anchorText, mode: .after)
        case .beforeLine:
            updated = insert(section: section, existing: existing, anchor: normalizedSettings.anchorText, mode: .before)
        }

        do {
            try updated.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch let error as CocoaError {
            if error.code == .fileWriteNoPermission && normalizedSettings.directoryBookmark == nil {
                // Try to request access if we don't have a bookmark
                accessibleDirectoryURL = try requestDirectoryAccess(for: accessibleDirectoryURL, settings: &normalizedSettings)
                settings = normalizedSettings  // Update the original settings
                let newFileURL = accessibleDirectoryURL
                    .appendingPathComponent(fileName(for: date))
                    .appendingPathExtension("md")
                try updated.write(to: newFileURL, atomically: true, encoding: .utf8)
                return newFileURL
            }
            if error.code == .fileWriteNoPermission {
                throw ObsidianExportError.permissionDenied(
                    fileName: fileName(for: date),
                    folderName: accessibleDirectoryURL.lastPathComponent
                )
            }
            throw ObsidianExportError.writeFailed(error)
        } catch {
            throw ObsidianExportError.writeFailed(error)
        }
    }

    private static func fileName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private static func buildSection(from content: String, title: String) -> String {
        let headingTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? ObsidianExportSettings.defaultTitle : title
        var block = "## \(headingTitle)\n\n"
        block += content
        if !content.hasSuffix("\n") {
            block += "\n"
        }
        if !block.hasSuffix("\n\n") {
            block += "\n"
        }
        return block
    }

    private static func insert(section: String, existing: String, anchor: String, mode: AnchorMode) -> String {
        guard let range = existing.range(of: anchor) else {
            return insert(section: section, into: existing, at: existing.endIndex)
        }
        let lineRange = existing.lineRange(for: range)
        let insertionIndex = (mode == .after) ? lineRange.upperBound : lineRange.lowerBound
        return insert(section: section, into: existing, at: insertionIndex)
    }

    private static func insert(section: String, into existing: String, at index: String.Index) -> String {
        let prefix = existing[..<index]
        let suffix = existing[index...]
        let adjusted = addSpacing(to: section, before: prefix, after: suffix)
        let combined = String(prefix) + adjusted + String(suffix)
        return combined.hasSuffix("\n") ? combined : combined + "\n"
    }

    private static func addSpacing(to section: String, before prefix: Substring, after suffix: Substring) -> String {
        var block = section
        let prefixString = String(prefix)
        if !prefixString.isEmpty {
            if prefixString.hasSuffix("\n\n") {
                // already padded
            } else if prefixString.hasSuffix("\n") {
                block = "\n" + block
            } else {
                block = "\n\n" + block
            }
        }

        let suffixString = String(suffix)
        if !suffixString.isEmpty {
            if suffixString.hasPrefix("\n\n") {
                // already padded
            } else if suffixString.hasPrefix("\n") {
                if !block.hasSuffix("\n\n") {
                    block += "\n"
                }
            } else {
                if !block.hasSuffix("\n\n") {
                    block += "\n\n"
                }
            }
        }

        return block
    }
}
