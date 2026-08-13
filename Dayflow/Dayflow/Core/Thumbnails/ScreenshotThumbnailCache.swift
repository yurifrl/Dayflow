//
//  ScreenshotThumbnailCache.swift
//  Dayflow
//
//  On-demand screenshot thumbnail generation (no cache, memory efficient).
//

import AppKit
import Foundation

final class ScreenshotThumbnailCache {
  static let shared = ScreenshotThumbnailCache()

  private let queue: OperationQueue = {
    let q = OperationQueue()
    q.name = "com.dayflow.screenshotthumbnailgen"
    q.maxConcurrentOperationCount = 2
    q.qualityOfService = .userInitiated
    return q
  }()

  private init() {}

  func fetchThumbnail(fileURL: URL, targetSize: CGSize, completion: @escaping (NSImage?) -> Void) {
    queue.addOperation { [weak self] in
      let image = self?.generateThumbnail(url: fileURL, targetSize: targetSize)
      DispatchQueue.main.async {
        completion(image)
      }
    }
  }

  private func generateThumbnail(screenshot: Screenshot, targetSize: CGSize) -> NSImage? {
    guard screenshot.isAvailable else { return nil }
    let targetMaxDimension = max(targetSize.width, targetSize.height)
    let scale = NSScreen.main?.backingScaleFactor ?? 2.0
    let maxPixel = max(64, Int(targetMaxDimension * scale))

    guard let cg = screenshot.loadCGImage(maxPixelSize: maxPixel) else { return nil }
    return NSImage(cgImage: cg, size: NSSize(width: cg.width, height: cg.height))
  }
}
