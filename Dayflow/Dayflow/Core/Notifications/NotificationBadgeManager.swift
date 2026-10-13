//
//  NotificationBadgeManager.swift
//  Dayflow
//
//  Manages badge state for Dock icon and sidebar indicator.
//

import AppKit
import SwiftUI

@MainActor
final class NotificationBadgeManager: ObservableObject {
  static let shared = NotificationBadgeManager()

  /// Whether there's a pending journal reminder the user hasn't acknowledged
  @Published private(set) var hasPendingReminder: Bool = false

  @Published private(set) var supportUnreadCount = UserDefaults.standard.integer(
    forKey: "support.unreadCount")

  func setSupportUnreadCount(_ count: Int) {
    supportUnreadCount = count
    UserDefaults.standard.set(count, forKey: "support.unreadCount")
    refreshDockBadge()
  }

  private init() {}

  private func refreshDockBadge() {
    let count = supportUnreadCount + (hasPendingReminder ? 1 : 0)
    NSApplication.shared.dockTile.badgeLabel = count > 0 ? String(count) : nil
  }

  // MARK: - Public Methods

  /// Shows the badge on both Dock icon and updates state for sidebar
  func showBadge() {
    hasPendingReminder = true
    refreshDockBadge()
  }

  /// Clears the badge from Dock icon and sidebar
  func clearBadge() {
    hasPendingReminder = false
    refreshDockBadge()
  }
}
