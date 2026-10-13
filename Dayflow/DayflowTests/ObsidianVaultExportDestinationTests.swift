import XCTest

@testable import Dayflow

final class ObsidianVaultExportDestinationTests: XCTestCase {
    func testDestinationPlacesDateRangeInStartingMonthWithISOFilename() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let start = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 8, day: 26)))
        let end = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 9, day: 2)))
        let vaultURL = URL(fileURLWithPath: "/tmp/DayflowVault", isDirectory: true)

        let destination = ObsidianVaultExportDestination(
            vaultURL: vaultURL,
            startDate: start,
            endDate: end,
            calendar: calendar
        )

        XCTAssertEqual(destination.relativePath, "2026/08/2026-08-26_2026-09-02.md")
        XCTAssertEqual(destination.fileURL.path, "/tmp/DayflowVault/2026/08/2026-08-26_2026-09-02.md")
    }

    func testDestinationUsesSameDateAtEachEndForSingleDayExport() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let date = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 1, day: 3)))
        let vaultURL = URL(fileURLWithPath: "/tmp/DayflowVault", isDirectory: true)

        let destination = ObsidianVaultExportDestination(
            vaultURL: vaultURL,
            startDate: date,
            endDate: date,
            calendar: calendar
        )

        XCTAssertEqual(destination.relativePath, "2026/01/2026-01-03_2026-01-03.md")
    }
    func testWriteCreatesDateHierarchyAndPersistsMarkdown() throws {
        let temporaryDirectory = try makeTemporaryDirectory()
        defer { try? FileManager.default.removeItem(at: temporaryDirectory) }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let date = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 8, day: 26)))

        let fileURL = try ObsidianVaultExportDestination.write(
            "# Timeline",
            to: temporaryDirectory,
            startDate: date,
            endDate: date,
            calendar: calendar
        )

        XCTAssertEqual(fileURL.path, temporaryDirectory.appendingPathComponent("2026/08/2026-08-26_2026-08-26.md").path)
        XCTAssertEqual(try String(contentsOf: fileURL, encoding: .utf8), "# Timeline")
    }

    func testWritePersistsMarkdownToEveryVault() throws {
        let firstVault = try makeTemporaryDirectory()
        let secondVault = try makeTemporaryDirectory()
        defer {
            try? FileManager.default.removeItem(at: firstVault)
            try? FileManager.default.removeItem(at: secondVault)
        }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let date = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 8, day: 26)))

        let fileURLs = try ObsidianVaultExportDestination.write(
            "# Timeline",
            to: [firstVault, secondVault],
            startDate: date,
            endDate: date,
            calendar: calendar
        )

        XCTAssertEqual(fileURLs.count, 2)
        for fileURL in fileURLs {
            XCTAssertTrue(fileURL.path.hasSuffix("2026/08/2026-08-26_2026-08-26.md"))
            XCTAssertEqual(try String(contentsOf: fileURL, encoding: .utf8), "# Timeline")
        }
    }

    func testSettingsSplitsCommaSeparatedVaultPaths() {
        let settings = ObsidianExportSettings(directoryPath: " /Vault/First, /Vault/Second ")

        XCTAssertEqual(settings.normalized().directoryPaths, ["/Vault/First", "/Vault/Second"])
    }

    private func makeTemporaryDirectory() throws -> URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
