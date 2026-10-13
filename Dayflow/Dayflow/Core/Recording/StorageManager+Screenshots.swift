import Foundation
import GRDB

extension StorageManager {
  // MARK: - Screenshot Management (new - replaces video chunks)

  /// Returns the URL for a new HEVC segment file inside the recordings folder.
  func nextSegmentURL() -> URL {
    let df = DateFormatter()
    df.dateFormat = "yyyyMMdd_HHmmssSSS"
    return root.appendingPathComponent("\(df.string(from: Date())).mp4")
  }

  /// Records one captured frame. `file_size` stays NULL until the segment is finalized.
  func saveScreenshot(
    segmentPath: String, frameIndex: Int, capturedAt: Date, idleSecondsAtCapture: Int?
  ) -> Int64? {
    let timestamp = Int(capturedAt.timeIntervalSince1970)

    var screenshotId: Int64?
    try? timedWrite("saveScreenshot") { db in
      try db.execute(
        sql: """
              INSERT INTO screenshots(captured_at, file_path, frame_index, idle_seconds_at_capture)
              VALUES (?, ?, ?, ?)
          """, arguments: [timestamp, segmentPath, frameIndex, idleSecondsAtCapture])
      screenshotId = db.lastInsertedRowID
    }
    return screenshotId
  }

  /// Spreads a finalized segment's byte count evenly across its frames so purge accounting works per row.
  func updateScreenshotFileSizes(segmentPath: String, totalBytes: Int64) {
    try? timedWrite("updateScreenshotFileSizes") { db in
      let frameCount =
        try Int.fetchOne(
          db, sql: "SELECT COUNT(*) FROM screenshots WHERE file_path = ?", arguments: [segmentPath])
        ?? 0
      guard frameCount > 0 else { return }
      let perFrame = max(1, totalBytes / Int64(frameCount))
      try db.execute(
        sql: "UPDATE screenshots SET file_size = ? WHERE file_path = ?",
        arguments: [perFrame, segmentPath])
    }
  }

  /// Soft-deletes every frame of a segment (used when the segment file is lost or corrupt).
  func markScreenshotsDeleted(segmentPath: String) {
    try? timedWrite("markScreenshotsDeleted") { db in
      try db.execute(
        sql: "UPDATE screenshots SET is_deleted = 1 WHERE file_path = ?",
        arguments: [segmentPath])
    }
  }

  /// Path of the newest segment that still has live frames, for crash recovery at launch.
  func mostRecentSegmentPath() -> String? {
    try? timedRead("mostRecentSegmentPath") { db in
      try String.fetchOne(
        db,
        sql: """
              SELECT file_path FROM screenshots
              WHERE is_deleted = 0 AND frame_index IS NOT NULL
              ORDER BY captured_at DESC LIMIT 1
          """)
    }
  }

  /// Observed recording rate in bytes per hour over finalized frames captured since `since`.
  /// Returns nil until at least ten minutes of finalized frames exist.
  func observedRecordingBytesPerHour(since: Date) -> Int64? {
    let sinceTs = Int(since.timeIntervalSince1970)
    let row = try? timedRead("observedRecordingBytesPerHour") { db in
      try Row.fetchOne(
        db,
        sql: """
              SELECT SUM(file_size) AS bytes, MIN(captured_at) AS first_ts, MAX(captured_at) AS last_ts
              FROM screenshots
              WHERE captured_at >= ? AND is_deleted = 0 AND file_size IS NOT NULL
          """, arguments: [sinceTs])
    }
    guard let row, let bytes: Int64 = row["bytes"],
      let firstTs: Int = row["first_ts"], let lastTs: Int = row["last_ts"]
    else { return nil }
    let spanSeconds = lastTs - firstTs
    guard spanSeconds >= 600 else { return nil }
    return Int64(Double(bytes) * 3600 / Double(spanSeconds))
  }

}
