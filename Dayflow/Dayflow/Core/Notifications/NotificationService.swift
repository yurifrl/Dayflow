//
//  NotificationService.swift
//  Dayflow
//
//  Main orchestrator for Daily and Weekly notifications.
//  Handles scheduling, permission requests, and notification tap responses.
//

import AppKit
import Foundation
@preconcurrency import UserNotifications

@MainActor
final class NotificationService: NSObject, ObservableObject {
  static let shared = NotificationService()

  private let center = UNUserNotificationCenter.current()

  @Published private(set) var permissionGranted: Bool = false

  override private init() {
    super.init()
  }

  // MARK: - Public Methods

  /// Call this from AppDelegate.applicationDidFinishLaunching
  func start() {
    center.delegate = self

    // Check current permission status
    Task {
      await retireJournalNotifications()
      await checkPermissionStatus()
    }
  }

  func clearSupportReplyNotification() {
    center.removeDeliveredNotifications(withIdentifiers: ["support.reply"])
    center.removePendingNotificationRequests(withIdentifiers: ["support.reply"])
  }

  func notifySupportReply() {
    Task {
      var status = await authorizationStatus()
      if status == .notDetermined {
        await requestPermission()
        status = await authorizationStatus()
      }
      guard Self.canScheduleNotifications(for: status),
        NotificationBadgeManager.shared.supportUnreadCount > 0
      else { return }
      let content = UNMutableNotificationContent()
      content.title = String(localized: "New reply from Dayflow")
      content.body = String(localized: "You have a new support reply. Open Support to read it.")
      content.sound = .default
      do {
        try await center.add(
          UNNotificationRequest(identifier: "support.reply", content: content, trigger: nil))
      } catch {
        print("[NotificationService] Support notification failed: \(error)")
      }
    }
  }

  /// Request notification permission from the user
  @discardableResult
  func requestPermission() async -> Bool {
    do {
      let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
      await MainActor.run {
        self.permissionGranted = granted
      }
      print("[NotificationService] requestPermission granted=\(granted)")
      return granted
    } catch {
      print("[NotificationService] Permission request failed: \(error)")
      return false
    }
  }

  /// Schedule all reminders based on current preferences
  func scheduleReminders() {
    // First, cancel all existing journal reminders
    cancelAllReminders()

    let delivered = await center.deliveredNotifications()
    let deliveredIDs = delivered.map(\.request.identifier).filter { $0.hasPrefix("journal.") }
    center.removeDeliveredNotifications(withIdentifiers: deliveredIDs)
  }

  /// Notify the user that yesterday's daily recap is ready.
  /// Called only after successful generation + DB save.
  func scheduleDailyRecapReadyNotification(forDay day: String) {
    let trimmedDay = day.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedDay.isEmpty else {
      print("[NotificationService] Skipping daily recap notification: empty day")
      return
    }
    print("[NotificationService] scheduleDailyRecapReadyNotification requested day=\(trimmedDay)")

    Task {
      var settings = await center.notificationSettings()
      var status = settings.authorizationStatus
      print(
        "[NotificationService] daily recap notification settings day=\(trimmedDay) "
          + "authorization_status=\(Self.authorizationStatusName(status))"
      )

      if status == .notDetermined {
        let granted = await requestPermission()
        settings = await center.notificationSettings()
        status = settings.authorizationStatus
        print(
          "[NotificationService] daily recap permission prompt result day=\(trimmedDay) "
            + "granted=\(granted) final_status=\(Self.authorizationStatusName(status))"
        )

        AnalyticsService.shared.capture(
          "daily_auto_generation_notification_permission_prompt_result",
          [
            "target_day": trimmedDay,
            "granted": granted,
            "authorization_status": Self.authorizationStatusName(status),
          ])
      }

      guard Self.canScheduleNotifications(for: status) else {
        print(
          "[NotificationService] Skipping daily recap notification (\(trimmedDay)): "
            + "permission_status=\(Self.authorizationStatusName(status))"
        )
        AnalyticsService.shared.capture(
          "daily_auto_generation_notification_skipped",
          [
            "target_day": trimmedDay,
            "reason": "permission_not_authorized",
            "authorization_status": Self.authorizationStatusName(status),
          ])
        return
      }

      enqueueDailyRecapReadyNotification(forDay: trimmedDay, settings: settings)
    }
  }

  // MARK: - Private Methods

  private func checkPermissionStatus() async {
    let settings = await center.notificationSettings()
    await MainActor.run {
      self.permissionGranted = Self.canScheduleNotifications(for: settings.authorizationStatus)
    }
  }

  private func enqueueDailyRecapReadyNotification(
    forDay day: String, settings: UNNotificationSettings
  ) {
    let identifier = "daily.recap.\(day)"
    print(
      "[NotificationService] enqueue daily recap identifier=\(identifier) "
        + "day=\(day) alert_setting=\(Self.notificationSettingName(settings.alertSetting)) "
        + "sound_setting=\(Self.notificationSettingName(settings.soundSetting))"
    )
    center.removePendingNotificationRequests(withIdentifiers: [identifier])
    print("[NotificationService] removed pending notification identifier=\(identifier)")

    let content = UNMutableNotificationContent()
    content.title = String(localized: "Your daily recap for yesterday is ready")
    content.body = String(localized: "Tap to open it in Daily view.")
    content.sound = .default
    content.categoryIdentifier = "daily_recap"
    content.userInfo = ["day": day]

    let request = UNNotificationRequest(
      identifier: identifier,
      content: content,
      trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    )

    let authStatus = Self.authorizationStatusName(settings.authorizationStatus)
    let alertSetting = Self.notificationSettingName(settings.alertSetting)
    let soundSetting = Self.notificationSettingName(settings.soundSetting)
    center.add(request) { error in
      if let error {
        print(
          "[NotificationService] Failed to schedule daily recap notification (\(day)): \(error)")
        AnalyticsService.shared.capture(
          "daily_auto_generation_notification_failed",
          [
            "target_day": day,
            "error_message": String(error.localizedDescription.prefix(500)),
            "authorization_status": authStatus,
            "alert_setting": alertSetting,
            "sound_setting": soundSetting,
          ])
        return
      }
      print(
        "[NotificationService] Scheduled daily recap notification "
          + "identifier=\(identifier) day=\(day)"
      )

      AnalyticsService.shared.capture(
        "daily_auto_generation_notification_scheduled",
        [
          "target_day": day,
          "authorization_status": authStatus,
          "alert_setting": alertSetting,
          "sound_setting": soundSetting,
        ])
    }
  }

  private static func authorizationStatusName(_ status: UNAuthorizationStatus) -> String {
    switch status {
    case .notDetermined:
      return "not_determined"
    case .denied:
      return "denied"
    case .authorized:
      return "authorized"
    case .provisional:
      return "provisional"
    @unknown default:
      return "unknown"
    }
  }

  private static func canScheduleNotifications(for status: UNAuthorizationStatus) -> Bool {
    switch status {
    case .authorized, .provisional:
      return true
    default:
      return false
    }
  }

  private static func notificationSettingName(_ setting: UNNotificationSetting) -> String {
    switch setting {
    case .notSupported:
      return "not_supported"
    case .disabled:
      return "disabled"
    case .enabled:
      return "enabled"
    @unknown default:
      return "unknown"
    }
  }

  private func activateAppForNotificationTap() {
    NSApp.activate(ignoringOtherApps: true)
    let showDockIcon = UserDefaults.standard.object(forKey: "showDockIcon") as? Bool ?? true
    if showDockIcon && NSApp.activationPolicy() == .accessory {
      NSApp.setActivationPolicy(.regular)
    }
    NSApp.windows.first?.makeKeyAndOrderFront(nil)
  }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
  /// Called when user taps on a notification
  nonisolated func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let identifier = response.notification.request.identifier
    let day = response.notification.request.content.userInfo["day"] as? String
    print(
      "[NotificationService] didReceive notification identifier=\(identifier) "
        + "action=\(response.actionIdentifier) day=\(day ?? "nil")"
    )

    let isDailyRecapNotification = identifier.hasPrefix("daily.")

    guard isJournalNotification || isDailyRecapNotification else {
      completionHandler()
      return
    }

    Task { @MainActor in
      if isJournalNotification {
        NotificationBadgeManager.shared.showBadge()
        NotificationCenter.default.post(name: .navigateToJournal, object: nil)
        AppDelegate.pendingNavigationToJournal = true
        activateAppForNotificationTap()
        print(
          "[NotificationService] didReceive journal notification handled identifier=\(identifier)")
      } else {
        AppDelegate.pendingNavigationToDailyDay = day
        AppDelegate.pendingNavigationToJournal = false

        if let day, !day.isEmpty {
          NotificationCenter.default.post(
            name: .navigateToDaily,
            object: nil,
            userInfo: ["day": day]
          )
          AnalyticsService.shared.capture(
            "daily_auto_generation_notification_clicked",
            [
              "target_day": day
            ])
          print("[NotificationService] didReceive daily notification navigation target_day=\(day)")
        } else {
          NotificationCenter.default.post(name: .navigateToDaily, object: nil)
          AnalyticsService.shared.capture(
            "daily_auto_generation_notification_clicked",
            [
              "target_day": "unknown"
            ])
          print("[NotificationService] didReceive daily notification navigation target_day=unknown")
        }

        activateAppForNotificationTap()
      }
    }

    completionHandler()
  }

  /// Called when notification fires while app is in foreground
  nonisolated func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    let identifier = notification.request.identifier
    let day = notification.request.content.userInfo["day"] as? String
    print("[NotificationService] willPresent identifier=\(identifier) day=\(day ?? "nil")")

    if identifier.hasPrefix("journal.") {
      Task { @MainActor in
        print("[NotificationService] willPresent: showing badge")
        NotificationBadgeManager.shared.showBadge()
      }

      print("[NotificationService] willPresent options=banner,sound,badge identifier=\(identifier)")
      completionHandler([.banner, .sound, .badge])
      return
    }

    if identifier.hasPrefix("support.") {
      completionHandler([.banner, .sound])
      return
    }

    print("[NotificationService] willPresent: unknown notification identifier, skipping")
    completionHandler([])
  }
}
