import AppKit
import Foundation
import SwiftUI
import UserNotifications

struct DailyView: View {
  // Fork: keep Daily unlocked by default (bypass beta gate). Non-private so extensions can read it.
  @AppStorage("isDailyUnlocked") var isUnlocked: Bool = true
  @Binding var selectedDate: Date
  @EnvironmentObject var categoryStore: CategoryStore

  @State var accessFlowStep: DailyAccessFlowStep = .intro
  @State var lockScreenConfettiTrigger: Int = 0
  @State var notificationAuthorizationStatus: UNAuthorizationStatus = .notDetermined
  @State var isCheckingNotificationAuthorization: Bool = false
  @State var isRequestingNotificationPermission: Bool = false
  @State var completedAccessBatchCount: Int = 0
  @State var workflowRows: [DailyWorkflowGridRow] = []
  @State var workflowTotals: [DailyWorkflowTotalItem] = []
  @State var workflowStats: [DailyWorkflowStatChip] = DailyWorkflowStatChip.placeholder
  @State var workflowWindow: DailyWorkflowTimelineWindow = .placeholder
  @State var workflowDistractionMarkers: [DailyWorkflowDistractionMarker] = []
  @State var workflowHasDistractionCategory: Bool = false
  @State var workflowHoveredCellKey: String? = nil
  @State var workflowHoveredDistractionId: String? = nil
  @State var workflowLoadTask: Task<Void, Never>? = nil
  @State var standupDraft: DailyStandupDraft = .default
  @State var standupSourceDay: DailyStandupDayInfo? = nil
  @State var loadedStandupDraftDay: String? = nil
  @State var loadedStandupFallbackSourceDay: String? = nil
  @State var standupDraftSaveTask: Task<Void, Never>? = nil
  @State var standupCopyState: DailyStandupCopyState = .idle
  @State var standupCopyResetTask: Task<Void, Never>? = nil
  @State var standupRegenerateState: DailyStandupRegenerateState = .idle
  @State var standupRegenerateTask: Task<Void, Never>? = nil
  @State var standupRegenerateResetTask: Task<Void, Never>? = nil
  @State var standupRegeneratingDotsPhase: Int = 1
  @State var hasPersistedStandupEntry: Bool = false
  @State var dailyRecapProvider: DailyRecapProvider = DailyRecapProvider.load()
  @State var isShowingProviderPicker: Bool = false
  @State var isRefreshingProviderAvailability: Bool = false
  @State var providerAvailabilityTask: Task<Void, Never>? = nil
  @State var providerAvailability: [DailyRecapProvider: DailyRecapProviderAvailability] =
    [:]
  // Fork: "Watch" day-recording slideshow state.
  @State var showDayRecording: Bool = false
  @State var dayRecordingScreenshots: [Screenshot] = []
  @State var dayRecordingLoadTask: Task<Void, Never>? = nil

  let betaNoticeCopy =
    "Daily is a new way to visualize your day and turn it into a standup update fast."
  let priorStandupHistoryLimit = 3
  static let maxDateTitleWidth: CGFloat = {
    let referenceText = "Wednesday, September 30"
    let font = NSFont(name: "InstrumentSerif-Regular", size: 26) ?? NSFont.systemFont(ofSize: 26)
    let width = referenceText.size(withAttributes: [.font: font]).width
    return ceil(width) + 6
  }()

  var body: some View {
    ZStack {
      if hasDailyMinimumAccess && isUnlocked {
        unlockedContent
          .transition(.opacity)
      } else {
        lockScreen
          .transition(.opacity.combined(with: .move(edge: .bottom)))
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .environment(\.colorScheme, .light)
    // Fork: "Watch" day-recording slideshow sheet.
    .sheet(isPresented: $showDayRecording) {
      if !dayRecordingScreenshots.isEmpty {
        ScreenshotSlideshowModal(
          screenshots: dayRecordingScreenshots,
          title: dailyDateTitle(for: selectedDate),
          startTime: nil,
          endTime: nil
        )
      }
    }
    .onAppear {
      refreshDailyAccessProgress()
      dailyRecapProvider = DailyRecapGenerator.shared.selectedProvider()
      refreshProviderAvailability()
      checkNotificationAuthorizationForUnlock()
    }
    .onReceive(Timer.publish(every: 30, on: .main, in: .common).autoconnect()) { _ in
      refreshDailyAccessProgress()
    }
    .onDisappear {
      workflowLoadTask?.cancel()
      workflowLoadTask = nil
      standupDraftSaveTask?.cancel()
      standupDraftSaveTask = nil
      standupCopyResetTask?.cancel()
      standupCopyResetTask = nil
      standupRegenerateTask?.cancel()
      standupRegenerateTask = nil
      standupRegenerateResetTask?.cancel()
      standupRegenerateResetTask = nil
      standupRegenerateState = .idle
      standupRegeneratingDotsPhase = 1
      dayRecordingLoadTask?.cancel()
      dayRecordingLoadTask = nil
    }
    .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification))
    { _ in
      checkNotificationAuthorizationForUnlock()
    }
    .onChange(of: isUnlocked) { _, newValue in
      guard !newValue else { return }
      accessFlowStep = .intro
      checkNotificationAuthorizationForUnlock()
    }
  }

  var hasDailyMinimumAccess: Bool {
    FeatureAccessRequirements.hasRequiredBatches(
      completedAccessBatchCount,
      requiredBatchCount: FeatureAccessRequirements.dailyRequiredBatchCount
    )
  }

  // Fork: load and present the day's screenshots as a slideshow.
  func openDayRecording() {
    let timelineDate = timelineDisplayDate(from: selectedDate)
    let dayInfo = timelineDate.getDayInfoFor4AMBoundary()
    let startTs = Int(dayInfo.startOfDay.timeIntervalSince1970)
    let endTs = Int(dayInfo.endOfDay.timeIntervalSince1970)

    dayRecordingLoadTask?.cancel()
    dayRecordingLoadTask = Task.detached(priority: .userInitiated) {
      let shots = StorageManager.shared.fetchScreenshotsInTimeRange(startTs: startTs, endTs: endTs)
      await MainActor.run {
        dayRecordingScreenshots = shots
        if !shots.isEmpty {
          showDayRecording = true
        }
        dayRecordingLoadTask = nil
      }
    }
  }

  var dailyAccessProgressText: String {
    FeatureAccessRequirements.progressText(
      completedBatchCount: completedAccessBatchCount,
      requiredHours: FeatureAccessRequirements.dailyRequiredHours
    )
  }

  func refreshDailyAccessProgress() {
    completedAccessBatchCount = FeatureAccessRequirements.completedBatchCount()
  }
}

struct DailyView_Previews: PreviewProvider {
  static var previews: some View {
    DailyView(selectedDate: .constant(Date()))
      .environmentObject(CategoryStore.shared)
      .frame(width: 1180, height: 760)
  }
}
