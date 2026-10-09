import Foundation

struct ObsidianVaultExportDestination {
    let directoryURL: URL
    let fileURL: URL
    let relativePath: String

    init(vaultURL: URL, startDate: Date, endDate: Date, calendar: Calendar = .current) {
        let start = calendar.dateComponents([.year, .month, .day], from: startDate)
        let end = calendar.dateComponents([.year, .month, .day], from: endDate)
        let year = start.year!
        let month = start.month!
        let startDay = start.day!
        let endYear = end.year!
        let endMonth = end.month!
        let endDay = end.day!

        directoryURL = vaultURL
            .appendingPathComponent(String(format: "%04d", year), isDirectory: true)
            .appendingPathComponent(String(format: "%02d", month), isDirectory: true)

        let fileName = String(
            format: "%04d-%02d-%02d_%04d-%02d-%02d.md",
            year,
            month,
            startDay,
            endYear,
            endMonth,
            endDay
        )
        fileURL = directoryURL.appendingPathComponent(fileName, isDirectory: false)
        relativePath = String(format: "%04d/%02d/%@", year, month, fileName)
    }

    static func write(
        _ markdown: String,
        to vaultURLs: [URL],
        startDate: Date,
        endDate: Date,
        calendar: Calendar = .current,
        fileManager: FileManager = .default
    ) throws -> [URL] {
        try vaultURLs.map {
            try write(
                markdown,
                to: $0,
                startDate: startDate,
                endDate: endDate,
                calendar: calendar,
                fileManager: fileManager
            )
        }
    }

    static func write(
        _ markdown: String,
        to vaultURL: URL,
        startDate: Date,
        endDate: Date,
        calendar: Calendar = .current,
        fileManager: FileManager = .default
    ) throws -> URL {
        let destination = ObsidianVaultExportDestination(
            vaultURL: vaultURL,
            startDate: startDate,
            endDate: endDate,
            calendar: calendar
        )
        try fileManager.createDirectory(
            at: destination.directoryURL,
            withIntermediateDirectories: true
        )
        try markdown.write(to: destination.fileURL, atomically: true, encoding: .utf8)
        return destination.fileURL
    }
}
