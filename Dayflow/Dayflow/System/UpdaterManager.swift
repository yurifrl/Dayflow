//
//  UpdaterManager.swift
//  Dayflow
//
//  Enterprise build: explicit no-op updater used to satisfy SwiftUI bindings.
//

import Foundation

/// Minimal updater façade that keeps the app UI happy while blocking
/// all external update traffic. Enterprise builds are managed manually.
@MainActor
final class UpdaterManager: NSObject, ObservableObject {
    static let shared = UpdaterManager()

    // Simple state for Settings UI
    @Published var isChecking = false
    @Published var statusText: String = "Updates disabled"
    @Published var updateAvailable = false
    @Published var latestVersionString: String? = nil

    private override init() {
        super.init()
    }

    func checkForUpdates(showUI: Bool = false) {
        // Immediately report that automatic updates are disabled in this build.
        isChecking = false
        updateAvailable = false
        statusText = "Updates managed externally"
        if showUI {
            NSLog("[Updater] Ignoring manual update request; updates disabled in enterprise build")
        }
    }
}
