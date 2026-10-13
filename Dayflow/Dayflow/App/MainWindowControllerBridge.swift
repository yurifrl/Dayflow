//
//  MainWindowControllerBridge.swift
//  Dayflow
//
//  Grafted from upstream App/DayflowApp.swift so that base-new callers
//  (Core/Flow/FlowSessionMirror.swift) can reveal the main window even when
//  the app shell is the fork variant.
//

import SwiftUI

extension Notification.Name {
  static let navigateToFlow = Notification.Name("navigateToFlow")
}

@MainActor
final class MainWindowController {
  static let shared = MainWindowController()

  private var openWindowAction: OpenWindowAction?
  private var hasPendingOpenRequest = false

  func register(_ openWindowAction: OpenWindowAction) {
    self.openWindowAction = openWindowAction

    if hasPendingOpenRequest {
      hasPendingOpenRequest = false
      openWindowAction(id: "main")
    }
  }

  func showMainWindow() {
    guard let openWindowAction else {
      hasPendingOpenRequest = true
      return
    }

    openWindowAction(id: "main")
  }
}
