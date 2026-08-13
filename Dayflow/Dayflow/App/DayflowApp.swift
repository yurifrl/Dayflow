//
//  DayflowApp.swift
//  Dayflow
//

import SwiftUI

struct AppRootView: View {
    @EnvironmentObject private var categoryStore: CategoryStore
    @State private var whatsNewNote: ReleaseNote? = nil
    @State private var activeWhatsNewVersion: String? = nil
    @State private var shouldMarkWhatsNewSeen = false
    @StateObject private var obsidianSettings = ObsidianSettingsStore()
    @StateObject private var autoDailyReportSettings = AutoDailyReportSettingsStore()
    @StateObject private var autoDailyReportService = AutoDailyReportService.shared

    var body: some View {
        MainView()
            .environmentObject(AppState.shared)
            .environmentObject(categoryStore)
            .environmentObject(obsidianSettings)
            .environmentObject(autoDailyReportSettings)
            .onAppear {
                autoDailyReportService.start()
            }
            .onDisappear {
                autoDailyReportService.stop()
            }
            .onAppear {
                guard whatsNewNote == nil else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let note = WhatsNewConfiguration.pendingReleaseForCurrentBuild() {
                        whatsNewNote = note
                        activeWhatsNewVersion = note.version
                        shouldMarkWhatsNewSeen = true
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .showWhatsNew)) { _ in
                guard let release = WhatsNewConfiguration.latestRelease() else { return }
                whatsNewNote = release
                activeWhatsNewVersion = release.version
                shouldMarkWhatsNewSeen = release.version == currentAppVersion

                // Analytics: track manual view
                AnalyticsService.shared.capture("whats_new_viewed_manual", [
                    "version": release.version
                ])
            }
            .sheet(item: $whatsNewNote, onDismiss: handleWhatsNewDismissed) { note in
                ZStack {
                    // Backdrop
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    WhatsNewView(releaseNote: note) {
                        closeWhatsNew()
                    }
                }
            }
    }

    private func closeWhatsNew() {
        whatsNewNote = nil
    }

    private func handleWhatsNewDismissed() {
        guard let version = activeWhatsNewVersion else { return }
        if shouldMarkWhatsNewSeen {
            WhatsNewConfiguration.markReleaseAsSeen(version: version)
        }
        activeWhatsNewVersion = nil
        shouldMarkWhatsNewSeen = false
    }

    private var currentAppVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
}

@main
struct DayflowApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @AppStorage("didOnboard") private var didOnboard = false
  @StateObject private var systemAppearance = SystemAppearanceObserver()
  @AppStorage(DayflowAppearance.storageKey) private var appearance: DayflowAppearance = .system
  @AppStorage("useBlankUI") private var useBlankUI = false
  /// Mirrors FlowNudgeVariant.current so the menu title re-renders on toggle.
  @AppStorage(FlowNudgeVariant.defaultsKey) private var flowNudgeVariant = FlowNudgeVariant.side
    .rawValue
  @State private var showVideoLaunch = true
  @State private var contentOpacity = 0.0
  @State private var contentScale = 0.98
  @State private var isShowingGitHubStarPrompt = false
  @State private var gitHubStarCount: Int? = nil
  @State private var gitHubStarPromptUsesBrowser = false
  @ObservedObject private var surveyCenter = SurveyCenter.shared
  // Must be the shared instance: the agent bridge (AgentWriteHandlers) writes to
  // CategoryStore.shared, and a second in-memory copy here would overwrite those
  // edits on the next UI-triggered save (GitHub issue #375).
  @StateObject private var categoryStore = CategoryStore.shared

    init() {
        // Comment out for production - only use for testing onboarding
        // UserDefaults.standard.set(false, forKey: "didOnboard")
    }
    
    // Enterprise updater stub (no network traffic)
    private let updaterManager = UpdaterManager.shared

  var body: some Scene {
    WindowGroup {
      ZStack {
        // Main app UI or onboarding with entrance animation
        Group {
          if didOnboard {
            // Show UI after onboarding
            AppRootView()
              .environmentObject(categoryStore)
              .environmentObject(updaterManager)
              .environmentObject(journalCoordinator)
          } else {
            OnboardingFlow()
              .environmentObject(AppState.shared)
              .environmentObject(categoryStore)
              .environmentObject(updaterManager)
              .dayflowTheme(.light)
          }
        }
        .opacity(contentOpacity)
        .scaleEffect(contentScale)
        .animation(.easeOut(duration: 0.3).delay(0.15), value: contentOpacity)
        .animation(.easeOut(duration: 0.3).delay(0.15), value: contentScale)

        // Video overlay on top with scale + opacity exit
        if showVideoLaunch {
          VideoLaunchView()
            .onVideoComplete {
              // Overlapping animations for smooth handoff
              withAnimation(.easeOut(duration: 0.25)) {
                // Start revealing content while video fades
                contentOpacity = 1.0
                contentScale = 1.0
              }

              // Slightly delayed video exit for overlap
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeIn(duration: 0.2)) {
                  showVideoLaunch = false
                }
              }

              dispatchPendingNotificationNavigation(after: 0.3)
            }
            
        }

        if didOnboard && !showVideoLaunch && isShowingGitHubStarPrompt {
          GitHubStarPromptCard(
            starCount: gitHubStarCount,
            usesBrowser: gitHubStarPromptUsesBrowser,
            onStar: starDayflow,
            onDismiss: dismissGitHubStarPrompt
          )
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
          .padding(.trailing, 24)
          .padding(.bottom, 24)
          .transition(.move(edge: .trailing).combined(with: .opacity))
          .zIndex(10)
        }

        if didOnboard && !showVideoLaunch, let survey = surveyCenter.activeSurvey {
          SurveyPromptCard(survey: survey, center: surveyCenter)
            .id(survey.id)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 24)
            .padding(.bottom, 24)
            .transition(.move(edge: .trailing).combined(with: .opacity))
            .zIndex(10)
        }

      }
      .animation(
        .spring(response: 0.34, dampingFraction: 0.88), value: surveyCenter.activeSurvey?.id
      )
      // Inline background behind the main app UI only
      .background {
        if didOnboard {
          Image("MainUIBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
      }
      .frame(minWidth: 900, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(.contentMinSize)
    .defaultSize(width: 1200, height: 800)
    .commands {
      // Remove the "New Window" command if you want a single window app
      CommandGroup(replacing: .newItem) {}

      // Add custom menu items after the app info section
      CommandGroup(after: .appInfo) {
        Divider()
        Button("Reset Onboarding") {
          // Reset the onboarding flag
          UserDefaults.standard.set(false, forKey: "didOnboard")
          // Reset the saved onboarding step to start from beginning
          UserDefaults.standard.set(0, forKey: "onboardingStep")
          // Reset the selected LLM provider to default
          UserDefaults.standard.set("gemini", forKey: "selectedLLMProvider")
          // Force quit and restart the app to show onboarding
          Task { @MainActor in
            AppDelegate.allowTermination = true
            NSApp.terminate(nil)
          }
        }
        .keyboardShortcut("R", modifiers: [.command, .shift])
      }

      // Add Sparkle's update menu item
      CommandGroup(after: .appInfo) {
        Button("Check for Updates…") {
          updaterManager.checkForUpdates(showUI: true)
        }

        Button("View Release Notes") {
          // Activate the app and bring to foreground
          NSApp.activate(ignoringOtherApps: true)

          // Post notification to show What's New modal
          NotificationCenter.default.post(name: .showWhatsNew, object: nil)
        }
        .keyboardShortcut("N", modifiers: [.command, .shift])
      }

      CommandGroup(after: .appInfo) {
        Divider()
        Button("Flow: Simulate Distraction") {
          FlowSessionMirror.shared.simulateDistraction()
        }
        .keyboardShortcut("D", modifiers: [.command, .shift])
        Button("Flow: Nudge Style — \(FlowNudgeVariant.current.title)") {
          FlowNudgeVariant.current = FlowNudgeVariant.current.next
          flowNudgeVariant = FlowNudgeVariant.current.rawValue
        }
      }
    }
    .defaultSize(width: 1200, height: 800)
  }

  private func starDayflow() async -> Bool {
    // Any click ends the reminders, even if the browser star can't be verified.
    GitHubStarPromptState.markDone()
    let promptNumber = GitHubStarPromptState.shownCount
    AnalyticsService.shared.capture("github_star_prompt_clicked", ["prompt_number": promptNumber])
    let starred = await GitHubStarService.starDayflow()
    if starred {
      AnalyticsService.shared.capture(
        "github_star_completed", ["method": "gh", "prompt_number": promptNumber])
      // Leave the card up briefly so the thank-you is visible.
      Task {
        try? await Task.sleep(for: .seconds(1.5))
        hideGitHubStarPrompt()
      }
    } else {
      AnalyticsService.shared.capture(
        "github_star_browser_fallback", ["prompt_number": promptNumber])
      NSWorkspace.shared.open(GitHubStarPromptState.repositoryURL)
      hideGitHubStarPrompt()
    }
    return starred
  }

  private func dismissGitHubStarPrompt() {
    AnalyticsService.shared.capture(
      "github_star_prompt_dismissed", ["prompt_number": GitHubStarPromptState.shownCount])
    hideGitHubStarPrompt()
  }

  private func hideGitHubStarPrompt() {
    withAnimation(.easeOut(duration: 0.2)) {
      isShowingGitHubStarPrompt = false
    }
  }

  private var hasPendingNotificationNavigation: Bool {
    AppDelegate.pendingNavigationToJournal || AppDelegate.pendingNavigationToDailyDay != nil
  }

  private func dispatchPendingNotificationNavigation(after delay: TimeInterval) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      if let day = AppDelegate.pendingNavigationToDailyDay, !day.isEmpty {
        AppDelegate.pendingNavigationToDailyDay = nil
        AppDelegate.pendingNavigationToJournal = false
        NotificationCenter.default.post(
          name: .navigateToDaily,
          object: nil,
          userInfo: ["day": day]
        )
        return
      }

      if AppDelegate.pendingNavigationToJournal {
        AppDelegate.pendingNavigationToJournal = false
        NotificationCenter.default.post(name: .navigateToJournal, object: nil)
      }
    }
  }
}

// MARK: - Notification Names

extension Notification.Name {
  static let showWhatsNew = Notification.Name("showWhatsNew")
  static let navigateToDaily = Notification.Name("navigateToDaily")
  static let timelineDataUpdated = Notification.Name("timelineDataUpdated")
  static let showTimelineFailureToast = Notification.Name("showTimelineFailureToast")
  static let openProvidersSettings = Notification.Name("openProvidersSettings")
}
