# Graph Report - Dayflow  (2026-08-26)

## Corpus Check
- 299 files · ~2,067,872 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 4571 nodes · 11516 edges · 222 communities (207 shown, 15 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 628 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `01a17d3d`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- TimelineReviewSummaryCard
- GeminiDirectProvider
- DailyRecapScheduler
- PauseManager
- OllamaProvider
- DaySummaryView
- StatusMenuView
- ChatCLITool
- ChatCLIProvider
- ProvidersSettingsViewModel
- LLMProviderRoutingTests
- ChatView
- SwiftUI
- ChatService
- ToolCallBubble
- LLMCallContext
- Observation
- Int
- CategorySelectionEditor
- AnalysisManager
- VideoProcessingError
- Sendable
- LocalEngine
- WorkStatusCard
- DailyView
- StorageManager.swift
- Date
- TimelineReviewOverlay
- TimelineCategory
- StorageSettingsViewModel
- OtherSettingsViewModel
- ProviderSetupState
- .generateActivityCards
- ColorOrganizerRoot
- DailyBulletCard
- Support.swift
- MainView
- ClaudeActivityCardBoundaryTests
- Identifiable
- TimelineReviewImageLayerHostView
- TimelineReviewCard
- Breadcrumb
- JournalDayManager
- VideoExpansionOverlay
- ChatStreamEvent
- NSColor
- SilentUserDriver
- CanvasTimelineDataView
- VideoLaunchView
- CLITool
- TimelineSpinnerModel
- ChatCLIProcessRunner
- ReferralOption
- CaseIterable
- CodexClaudeProviderTests
- json
- IntentionsEditForm
- TimelineReviewPlayerModel
- AppRootView
- ChatChartSpec
- JournalBoardLayout
- ColorPickerView
- JournalDayView.swift
- WhatsNewView
- MCPServer.swift
- XCTestCase
- TimelineActivity
- ScreenshotSlideshowPlaybackModel
- DayflowSurfaceButton
- String
- TimelineRateSummaryView
- .export
- ObsidianExportSettings
- SentryHelper.swift
- OnboardingFlow
- JournalRemindersView
- ScrubberView
- TimelineReviewRating
- ChatToolExecutor
- ScreenRecorder
- VideoPlayerViewModel
- FlexibleProviderCard
- ScreenshotScrubberView
- LLMService
- CategoryDonutChart
- CodingKeys
- .run
- Render.swift
- DayflowApp
- Codable
- SettingsView
- AnalyticsService
- ProviderPromptPreferencesTests
- VideoProcessingService
- SidebarIcon
- RetryCoordinator
- XCTest
- AppDelegate
- InactivityMonitor
- NotificationService
- LongestFocusCard
- JournalWeeklyReferenceCurve
- TimelapseStorageManager
- .timelineRightColumn
- Error
- Distraction
- MacTextView
- Weekday
- FaviconService
- CategoryPickerPill
- TestConnectionView
- AppDeepLinkRouter
- SetupSidebarItem
- Int
- DayflowPillButton
- Bool
- VideoThumbnailView
- PlayerLayerView
- JournalFlowState
- NotificationPreferences
- .load
- Database
- README.md
- CLIDetectionState
- ChatCLIPromptOverrides
- LogoBadgeView
- OnboardingLLMSelectionView
- AppKitComposerTextField
- TabFilterBar
- GeminiModel
- ChatCLIConfigManager
- ObservableObject
- GeminiPromptOverrides
- GeminiModelPreference
- DailyRecapGeneratorTests
- NSObject
- AutoDailyReportSettingsStore
- HoverScaleModifier
- BadgeView
- HowItWorksView
- .write
- StepContentType
- ActivityType
- TimelineFailureToastPayload
- .makeLog
- AutoDailyReportService
- CategoryPill
- DistractionSummaryCard
- CGRect
- ViewModifier
- DatabaseContentionTracker
- Dayflow Analytics Event Dictionary (Telemetry Disabled)
- .capture
- Screenshot
- CardsToReviewBadge
- .logGeminiFailure
- APIKeyInputView
- LLMProviderSetupView.swift
- FlowLayout
- StorageCategory
- ChatView.swift
- TimelineFeedbackModal
- sendOrFail
- OllamaPromptOverrides
- TimelineCard
- SunriseGlassPillToggleStyle
- ScreenRecordingPermissionView
- CanvasActivityCard
- HelpfulFeatureOption
- Field
- .usageRow
- Stage
- OpenAICompatibleConfigurationTests
- .userNotificationCenter
- .retrieve
- ObsidianWritePosition
- TimelineCanvas
- .migrateIfNeeded
- ProviderCardComponents.swift
- ReminderField
- WeeklyDashboardBuilderTests
- Repository Guidelines
- EntryType
- .body
- SplashView
- .activity
- View
- ProviderIconView
- LaunchAtLoginManager
- DayflowUITestsLaunchTests
- VideoCodec
- CodexExecutableResolverTests
- LLMProviderType
- TimelineCopyState
- .relocateDirectoryContents
- CompletionView
- SetupContinueButton
- DashboardToolName
- AnimationPhase
- Period
- release.sh
- DayflowUITests
- DebugLogEntry
- Direction
- Position
- .migrateIfNeeded
- JournalReminderPillButtonStyle
- APIError
- .validateTimeCoverage
- GatePhase
- DailyStandupRegenerateState
- Dayflow Assets
- supervisor.md
- Category
- LLMOutputLanguagePreferences
- PackageDescription
- make_appcast.sh
- release_dmg.sh
- sparkle_sign_from_keychain.sh
- update_appcast.sh
- ReviewRatingKey

## God Nodes (most connected - your core abstractions)
1. `ProvidersSettingsViewModel` - 95 edges
2. `GeminiDirectProvider` - 91 edges
3. `DaySummaryView` - 77 edges
4. `MainView` - 69 edges
5. `DailyView` - 65 edges
6. `TimelineCategory` - 64 edges
7. `ChatView` - 56 edges
8. `OllamaProvider` - 52 edges
9. `CanvasTimelineDataView` - 51 edges
10. `TimelineReviewOverlay` - 49 edges

## Surprising Connections (you probably didn't know these)
- `runMCPServer()` --calls--> `.message`  [INFERRED]
  tools/dayflow-cli/Sources/dayflow/MCPServer.swift → Dayflow/Dayflow/Views/Onboarding/TestConnectionView.swift
- `reportWrite()` --calls--> `data`  [INFERRED]
  tools/dayflow-cli/Sources/dayflow/WriteCommands.swift → Dayflow/Dayflow/Views/UI/SettingsView.swift
- `normalizedPrefix()` --references--> `String`  [EXTRACTED]
  Dayflow/Dayflow/Core/Recording/StorageManager.swift → tools/dayflow-cli/Sources/dayflow/Render.swift
- `Action` --implements--> `String`  [EXTRACTED]
  Dayflow/Dayflow/App/AppDeepLinkRouter.swift → tools/dayflow-cli/Sources/dayflow/Render.swift
- `AppDelegate` --references--> `String`  [EXTRACTED]
  Dayflow/Dayflow/App/AppDelegate.swift → tools/dayflow-cli/Sources/dayflow/Render.swift

## Import Cycles
- None detected.

## Communities (222 total, 15 thin omitted)

### Community 0 - "TimelineReviewSummaryCard"
Cohesion: 0.05
Nodes (55): DateFormatter, .reviewSection, Design, ReviewMetric, ReviewMetricStyle, Bool, CGFloat, Color (+47 more)

### Community 1 - "GeminiDirectProvider"
Cohesion: 0.12
Nodes (15): DashboardDateRange, DashboardFunctionCall, DashboardTurnResult, GeminiDirectProvider, .dashboardDateFormatter, .dashboardGenerateEndpoint, .dashboardRangeDateDisplayFormatter, .dashboardSingleDateDisplayFormatter (+7 more)

### Community 2 - "DailyRecapScheduler"
Cohesion: 0.11
Nodes (10): DailyRecapScheduler, PersistedDailyBulletItem, PersistedDailyStandupDraft, DispatchSourceTimer, Int, TimeInterval, UUID, DayflowBackendProvider (+2 more)

### Community 3 - "PauseManager"
Cohesion: 0.08
Nodes (24): PauseDuration, .analyticsValue, hour1, indefinite, minutes15, minutes30, .timeInterval, PauseManager (+16 more)

### Community 4 - "OllamaProvider"
Cohesion: 0.09
Nodes (26): Bool, ChatRequest, FrameData, ImageURL, MessageContent, OllamaProvider, .customAPIKey, .isCustomEngine (+18 more)

### Community 5 - "DaySummaryView"
Cohesion: 0.12
Nodes (20): CardWithDuration, DaySummaryView, .body, .categoryDurations, .daySoFarSection, .distractedRatio, .distractionsSection, .emptyChartPlaceholder (+12 more)

### Community 6 - "StatusMenuView"
Cohesion: 0.14
Nodes (19): CountdownBadge, .body, DurationOption, .body, DurationPicker, .body, MenuDivider, .body (+11 more)

### Community 7 - "ChatCLITool"
Cohesion: 0.16
Nodes (12): ChatCLITool, claude, codex, ConfiguredBackupProvider, LLMProviderID, .analyticsName, chatGPTClaude, gemini (+4 more)

### Community 8 - "ChatCLIProvider"
Cohesion: 0.10
Nodes (18): ChatCLIProvider, SegmentMergeResponse, AsyncThrowingStream, Bool, Double, Error, Int, Int64 (+10 more)

### Community 9 - "ProvidersSettingsViewModel"
Cohesion: 0.05
Nodes (35): CompactProviderInfo, .providerTableName, ProviderRoutingRole, primary, secondary, setupOnly, ProvidersSettingsViewModel, .backupProviderDisplayName (+27 more)

### Community 10 - "LLMProviderRoutingTests"
Cohesion: 0.11
Nodes (6): LLMProviderRoutingTests, RecordingUserDefaults, Any, Set, LegacyLLMProviderMigration, UserDefaults

### Community 11 - "ChatView"
Cohesion: 0.06
Nodes (35): DashboardChatProvider, .analyticsProvider, .chatCLITool, claude, codex, gemini, .runtimeLabel, ChatView (+27 more)

### Community 12 - "SwiftUI"
Cohesion: 0.06
Nodes (18): AppKit, AVFoundation, AVKit, Combine, CoreGraphics, Darwin, StoragePreferences, .recordingsLimitBytes (+10 more)

### Community 13 - "ChatService"
Cohesion: 0.10
Nodes (19): AssistantMetadata, ChatDebugEntry, .typeColor, ChatService, ChatWorkStatus, .hasDetails, .hasErrors, Bool (+11 more)

### Community 14 - "ToolCallBubble"
Cohesion: 0.06
Nodes (39): ButtonStyle, .helperContent, ShimmerOverlay, .body, CGFloat, Color, Double, ToolCallBubble (+31 more)

### Community 15 - "LLMCallContext"
Cohesion: 0.17
Nodes (13): LLMCallContext, LLMHTTPInfo, LLMLogger, LLMLogStatus, failure, success, Data, Int (+5 more)

### Community 16 - "Observation"
Cohesion: 0.11
Nodes (20): FrameData, FrameDescriptionEnvelope, GemmaBackupProvider, Item, MergeDecision, SegmentCoverageError, SegmentEnvelope, Any (+12 more)

### Community 17 - "Int"
Cohesion: 0.11
Nodes (32): allBatches(), DatabaseContentionSnapshot, read, fetchChunksInTimeRange(), fetchJournalDays(), fetchLatestDailyStandupDay(), fetchLLMCallsForBatches(), fetchMostRecentGoals() (+24 more)

### Community 18 - "CategorySelectionEditor"
Cohesion: 0.07
Nodes (37): CategorySelectionEditor, .backgroundView, .helperRow, CheckmarkShape, ConfettiBurstView, .body, ConfettiPiece, .body (+29 more)

### Community 19 - "AnalysisManager"
Cohesion: 0.07
Nodes (28): LLMServicing, AnalysisManager, AnalysisManaging, IdleBatchAssessment, IdleBatchRules, ScreenshotBatch, .count, .duration (+20 more)

### Community 20 - "VideoProcessingError"
Cohesion: 0.10
Nodes (20): AVAssetExportSession, VideoProcessingError, assetLoadFailed, assetReaderCreationFailed, assetWriterCreationFailed, assetWriterInputCreationFailed, assetWriterStartFailed, directoryCreationFailed (+12 more)

### Community 21 - "Sendable"
Cohesion: 0.14
Nodes (27): CryptoKit, computeDailyWorkflow(), DailyGridConfig, DailyStandupPlaceholder, DailyWorkflowComputationResult, DailyWorkflowGrid, .body, .renderRows (+19 more)

### Community 22 - "LocalEngine"
Cohesion: 0.06
Nodes (37): LocalEngine, custom, .defaultBaseURL, .displayName, .id, lmstudio, ollama, LocalModelInstructionSet (+29 more)

### Community 23 - "WorkStatusCard"
Cohesion: 0.07
Nodes (27): AnimatedEllipsis, .body, BetaButtonStyle, .betaLockScreen, PressScaleButtonStyle, ProviderTogglePill, .backgroundColor, .body (+19 more)

### Community 24 - "DailyView"
Cohesion: 0.11
Nodes (13): DailyStandupCopyState, copied, idle, DailyStandupDraft, DailyStandupSectionTitles, DailyView, .accessCodeCard, .body (+5 more)

### Community 25 - "StorageManager.swift"
Cohesion: 0.11
Nodes (39): applyReviewRating(), chunksForBatch(), write, deleteObservations(), deleteTimelineCard(), deleteTimelineCards(), fetchBatchLLMMetadata(), fetchJournalEntry() (+31 more)

### Community 26 - "Date"
Cohesion: 0.09
Nodes (27): Date, .timelineDayInfo, DateNavigationControls, .body, Bool, CGFloat, canNavigateForward(), normalizedTimelineDate() (+19 more)

### Community 27 - "TimelineReviewOverlay"
Cohesion: 0.11
Nodes (21): IndexedActivity, makeTimelineActivities(), CGSize, Double, TimelineReviewInput, button, drag, keyboard (+13 more)

### Community 28 - "TimelineCategory"
Cohesion: 0.13
Nodes (12): CategoryPersistence, .defaultCategories, CategoryStore, .editableCategories, .idleCategory, StoreKeys, Bool, Int (+4 more)

### Community 29 - "StorageSettingsViewModel"
Cohesion: 0.21
Nodes (8): ByteCountFormatter, StorageLimitOption, .resolvedBytes, .shortLabel, StorageSettingsViewModel, Bool, Int64, URL

### Community 30 - "OtherSettingsViewModel"
Cohesion: 0.08
Nodes (23): OtherSettingsViewModel, .showDockIcon, .showTimelineAppIcons, Bool, Int, SettingsCard, .body, Content (+15 more)

### Community 31 - "ProviderSetupState"
Cohesion: 0.08
Nodes (20): ChatCLIDetectionStepView, .body, .canContinue, LLMProviderSetupView, .activeProviderType, .body, .currentStepContent, .headerTitle (+12 more)

### Community 32 - ".generateActivityCards"
Cohesion: 0.15
Nodes (12): ModelRunState, .current, RetryStrategy, enhancedPrompt, immediate, longBackoff, noRetry, shortBackoff (+4 more)

### Community 33 - "ColorOrganizerRoot"
Cohesion: 0.11
Nodes (24): ColorAssignmentCard, .body, ColorOrganizerRoot, .backgroundView, .body, .canAddMoreCategories, .categories, .contentCard (+16 more)

### Community 34 - "DailyBulletCard"
Cohesion: 0.11
Nodes (22): DailyBulletCard, .addItemButton, .body, .itemListEditor, .listMinHeight, .listViewportHeight, DailyBulletItem, DailyListDropToEndDelegate (+14 more)

### Community 35 - "Support.swift"
Cohesion: 0.29
Nodes (7): AnyTransition, .blurReplace, BlurReplaceModifier, Bool, Content, Self, View

### Community 36 - "MainView"
Cohesion: 0.08
Nodes (23): Bool, .contentStack, .mainLayout, .mainPanelBackground, .overlayContent, .rightPanel, .timelineHeader, .timelineLeftColumn (+15 more)

### Community 37 - "ClaudeActivityCardBoundaryTests"
Cohesion: 0.17
Nodes (4): ClaudeActivityCardBoundaryTests, Bool, Int, Int64

### Community 38 - "Identifiable"
Cohesion: 0.17
Nodes (21): BasicChartSpec, ChartPoint, ChatChartBlockView, .body, .chartBody, DonutChartSpec, DonutSlice, GanttChartSpec (+13 more)

### Community 39 - "TimelineReviewImageLayerHostView"
Cohesion: 0.15
Nodes (12): CALayer, KeyCaptureView, .acceptsFirstResponder, Context, NSCoder, NSEvent, NSRect, TimelineReviewImageLayerHostView (+4 more)

### Community 40 - "TimelineReviewCard"
Cohesion: 0.11
Nodes (23): Design, NeutralFaceIcon, .body, ReviewLayout, SpeedChipDesign, CGFloat, Color, TimelineReviewCard (+15 more)

### Community 41 - "Breadcrumb"
Cohesion: 0.10
Nodes (29): DatabasePool, allocatedSizeOfDirectory(), checkpoint(), cleanupRecordingStragglers(), createBackup(), findMostRecentBackup(), init(), migrateDatabaseLocationIfNeeded() (+21 more)

### Community 42 - "JournalDayManager"
Cohesion: 0.12
Nodes (8): JournalDayManager, .canNavigateForward, .ctaTitle, .goalsList, .headline, .intentionsList, Bool, .toolbar

### Community 43 - "VideoExpansionOverlay"
Cohesion: 0.11
Nodes (19): ScaleButtonStyle, Bool, CGFloat, CGSize, Configuration, Namespace, VideoExpansionOverlay, .activeAspectRatio (+11 more)

### Community 44 - "ChatStreamEvent"
Cohesion: 0.21
Nodes (9): ChatStreamEvent, complete, error, sessionStarted, textDelta, thinking, toolEnd, toolStart (+1 more)

### Community 45 - "NSColor"
Cohesion: 0.06
Nodes (25): ClaudeFrameTextRecognizing, ClaudeRecognizedTextBlock, Color, NSColor, CGFloat, ComposerTextField, .composerCell, .stringValue (+17 more)

### Community 46 - "SilentUserDriver"
Cohesion: 0.10
Nodes (13): SilentUserDriver, Bool, Double, Error, UInt64, Void, SPUDownloadData, SPUUpdatePermissionRequest (+5 more)

### Community 47 - "CanvasTimelineDataView"
Cohesion: 0.11
Nodes (22): CanvasPositionedActivity, CanvasTimelineDataView, .body, .cardsLayer, .currentTimeIndicator, .hourLines, .mainTimelineRow, .pausedStatusGradient (+14 more)

### Community 48 - "VideoLaunchView"
Cohesion: 0.10
Nodes (18): AVPlayerView, AVPlayerControllerRepresented, NonInteractiveAVPlayerView, .acceptsFirstResponder, Any, AVPlayer, Bool, Context (+10 more)

### Community 49 - "CLITool"
Cohesion: 0.12
Nodes (19): .isProviderConfigured, ChatCLITestView, .body, CLIDetectionReport, CLIDetector, CLIResult, CLITool, claude (+11 more)

### Community 50 - "TimelineSpinnerModel"
Cohesion: 0.13
Nodes (18): CFTimeInterval, .generatingStatusText, CGFloat, Color, Double, Int, Timer, TimelineSpinnerConfig (+10 more)

### Community 51 - "ChatCLIProcessRunner"
Cohesion: 0.14
Nodes (6): ChatCLIProcessRunner, TokenUsage, .zero, ClaudeCLIExecutionProfileTests, ChatCLIProcessRunnerTests, URL

### Community 52 - "ReferralOption"
Cohesion: 0.10
Nodes (23): ReferralOption, .analyticsValue, .detailPlaceholder, .displayName, friend, hackerNews, .id, newsletterBlog (+15 more)

### Community 53 - "CaseIterable"
Cohesion: 0.12
Nodes (25): CaseIterable, JournalWeeklyCircleButton, .body, JournalWeeklyDay, .placeholder, JournalWeeklyEntry, JournalWeeklyEntryCard, .body (+17 more)

### Community 55 - "json"
Cohesion: 0.18
Nodes (26): failJSON(), json(), printJSON(), Any, Bool, Int32, Never, timelineEnvelope() (+18 more)

### Community 56 - "IntentionsEditForm"
Cohesion: 0.13
Nodes (23): IntentionsEditForm, .body, .sectionGoals, .sectionIntentions, .sectionNotes, .body, .body, JournalDayTokens (+15 more)

### Community 57 - "TimelineReviewPlayerModel"
Cohesion: 0.17
Nodes (6): Float, Never, Task, TimelineReviewPlayerModel, .frameCount, .playbackIntervalSeconds

### Community 58 - "AppRootView"
Cohesion: 0.16
Nodes (12): AppRootView, .body, .currentAppVersion, ReleaseNote, .semanticVersion, Int, WhatsNewConfiguration, .configuredRelease (+4 more)

### Community 59 - "ChatChartSpec"
Cohesion: 0.10
Nodes (27): ClaudeDelta, ClaudeEvent, ClaudeJSONLEvent, CodexItem, CodexJSONLEvent, Int, BasicPayload, ChatChartSpec (+19 more)

### Community 60 - "JournalBoardLayout"
Cohesion: 0.12
Nodes (20): .body, .badgeBackground, .backgroundView, AnyTransition, .bookFlipNext, .bookFlipPrev, BookFlipModifier, .editCard (+12 more)

### Community 61 - "ColorPickerView"
Cohesion: 0.14
Nodes (21): Color, .spectrumColors, ColorPickerView, .body, .colorHex, .hue, .light, .normalizedRadius (+13 more)

### Community 62 - "JournalDayView.swift"
Cohesion: 0.14
Nodes (27): IntroView, JournalDayBulletList, .body, JournalDayCircleButton, JournalDaySegmentedControl, .body, JournalDayView, .body (+19 more)

### Community 63 - "WhatsNewView"
Cohesion: 0.08
Nodes (26): ReleaseNoteCTA, Bool, Set, Void, ValueFrequencyOption, .analyticsValue, daily, notSureYet (+18 more)

### Community 64 - "MCPServer.swift"
Cohesion: 0.27
Nodes (23): callTool(), emit(), openDB(), reply(), replyError(), resolveWindow(), runActivityDetailTool(), runDailyTool() (+15 more)

### Community 65 - "XCTestCase"
Cohesion: 0.10
Nodes (7): parseTimeHMMA(), Int, AgentWriteHandlersTests, DaySummaryLoadTokenTests, TimelineProviderStartupSelectionTests, TimeParsingTests, XCTestCase

### Community 66 - "TimelineActivity"
Cohesion: 0.12
Nodes (15): ActivityCard, .body, ActivityCardTimelapseGenerator, Bool, CGSize, Color, Int64, Task (+7 more)

### Community 67 - "ScreenshotSlideshowPlaybackModel"
Cohesion: 0.15
Nodes (11): ScreenshotSlideshowFrameLoader, .body, ScreenshotSlideshowPlaybackModel, .playbackIntervalSeconds, .timelineDurationSeconds, Double, Int, Never (+3 more)

### Community 68 - "DayflowSurfaceButton"
Cohesion: 0.12
Nodes (18): DayflowSurfaceButton, .body, Bool, CGFloat, Color, Content, Void, TerminalCommandView (+10 more)

### Community 69 - "String"
Cohesion: 0.07
Nodes (23): VideoTranscriptChunk, LocalEndpointUtilities, URL, ChatMessage, .isRunning, Role, assistant, toolCall (+15 more)

### Community 70 - "TimelineRateSummaryView"
Cohesion: 0.11
Nodes (16): Any, Bool, Never, Task, Void, TimelineDeleteButtonState, confirming, deleting (+8 more)

### Community 71 - ".export"
Cohesion: 0.13
Nodes (16): AnchorMode, after, before, ObsidianExporter, ObsidianExportError, emptyContent, .errorDescription, invalidDirectory (+8 more)

### Community 72 - "ObsidianExportSettings"
Cohesion: 0.21
Nodes (8): ObsidianExportSettings, .directoryPaths, .directoryURL, ObsidianSettingsStore, .settings, Data, URL, UserDefaults

### Community 73 - "SentryHelper.swift"
Cohesion: 0.13
Nodes (12): Scope, SentryHelper, SentrySDK, SentrySpanStatus, cancelled, internalError, ok, unknown (+4 more)

### Community 74 - "OnboardingFlow"
Cohesion: 0.18
Nodes (13): OnboardingFlow, .body, Step, categories, howItWorks, llmSelection, llmSetup, screen (+5 more)

### Community 75 - "JournalRemindersView"
Cohesion: 0.21
Nodes (15): DayChipRow, JournalRemindersView, .body, JournalRemindersView_Previews, .previews, .repeatOnRow, JournalReminderTokens, PeriodDropdown (+7 more)

### Community 76 - "ScrubberView"
Cohesion: 0.19
Nodes (14): Comparable, FilmstripGenerator, ScrubberView, .body, .totalHeight, Bool, CGFloat, Double (+6 more)

### Community 77 - "TimelineReviewRating"
Cohesion: 0.07
Nodes (39): Angle, SummaryBarRow, .body, SummaryLabelRow, .body, LinearGradient, TimeInterval, TimelineReviewFooterIcon (+31 more)

### Community 78 - "ChatToolExecutor"
Cohesion: 0.18
Nodes (11): ChatTool, .displayName, fetchObservations, fetchTimeline, ChatToolExecutor, .toolDescription, ChatToolRequest, .toolType (+3 more)

### Community 79 - "ScreenRecorder"
Cohesion: 0.07
Nodes (31): ActiveDisplayTracker, Any, CGDirectDisplayID, CGFloat, DispatchSourceTimer, Double, TimeInterval, Config (+23 more)

### Community 80 - "VideoPlayerViewModel"
Cohesion: 0.18
Nodes (10): AVPlayer, Color, Double, Float, URL, .scrubberView, VideoPlayerViewModel, VideoSegment (+2 more)

### Community 81 - "FlexibleProviderCard"
Cohesion: 0.12
Nodes (20): FeatureRowView, .body, FlexibleProviderCard, .actionButton, .body, .buttonAction, .buttonBackgroundColor, .buttonForegroundColor (+12 more)

### Community 82 - "ScreenshotScrubberView"
Cohesion: 0.18
Nodes (9): Comparable, ScreenshotFilmstripGenerator, ScreenshotScrubberView, .body, .totalHeight, CGFloat, OperationQueue, Self (+1 more)

### Community 83 - "LLMService"
Cohesion: 0.11
Nodes (21): GemmaFallbackState, LLMProcessingStep, generatingCards, transcribing, LLMService, .batchingConfig, .providerType, ProcessedBatchResult (+13 more)

### Community 84 - "CategoryDonutChart"
Cohesion: 0.14
Nodes (17): Charts, CategoryDonutChart, .body, .centerContent, .donutChart, .formattedTotal, .legendGrid, .totalDuration (+9 more)

### Community 85 - "CodingKeys"
Cohesion: 0.10
Nodes (21): CodingKey, CodingKeys, cardsText, day, observationsText, preferencesText, priorDailyText, CodingKeys (+13 more)

### Community 86 - ".run"
Cohesion: 0.15
Nodes (13): LoginShellResult, LoginShellRunner, .userLoginShell, PseudoTerminal, AsyncThrowingStream, Bool, Error, Int32 (+5 more)

### Community 87 - "Render.swift"
Cohesion: 0.15
Nodes (18): DayWindow, formatDuration(), Int, WeekWindow, printCategoryTotals(), renderCard(), renderTimeline(), renderWeekly() (+10 more)

### Community 88 - "DayflowApp"
Cohesion: 0.10
Nodes (15): App, DayflowApp, .body, .hasPendingNotificationNavigation, Notification.Name, Bool, TimeInterval, MainWindowContent (+7 more)

### Community 89 - "Codable"
Cohesion: 0.10
Nodes (26): AppSitesResponse, Codable, ChatCLICardsEnvelope, ChatCLIObservationsEnvelope, Item, .normalizedEnd, .normalizedStart, Segment (+18 more)

### Community 90 - "SettingsView"
Cohesion: 0.12
Nodes (17): SettingsTab, data, .id, obsidian, other, providers, storage, .subtitle (+9 more)

### Community 91 - "AnalyticsService"
Cohesion: 0.17
Nodes (5): AnalyticsService, .isOptedIn, Any, Bool, .analyticsEnabled

### Community 92 - "ProviderPromptPreferencesTests"
Cohesion: 0.20
Nodes (4): IgnoringUserDefaults, ProviderPromptPreferencesTests, Any, Set

### Community 93 - "VideoProcessingService"
Cohesion: 0.24
Nodes (8): CVPixelBuffer, CVPixelBufferPool, Bool, CGImage, Int, URL, VideoEncodingOptions, VideoProcessingService

### Community 94 - "SidebarIcon"
Cohesion: 0.12
Nodes (19): .leftColumn, SidebarIcon, .assetName, bug, chat, daily, .displayName, journal (+11 more)

### Community 95 - "RetryCoordinator"
Cohesion: 0.14
Nodes (13): RetryCoordinator, .dots, Status, done, failed, queued, running, stopped (+5 more)

### Community 97 - "AppDelegate"
Cohesion: 0.14
Nodes (9): AppDelegate, AnyCancellable, Bool, Notification, NSObjectProtocol, Timer, URL, NSApplication (+1 more)

### Community 98 - "InactivityMonitor"
Cohesion: 0.19
Nodes (7): InactivityMonitor, .thresholdSeconds, Any, Bool, NSObjectProtocol, TimeInterval, Timer

### Community 99 - "NotificationService"
Cohesion: 0.18
Nodes (7): NotificationService, Bool, Int, UNAuthorizationStatus, UNNotificationSetting, UNNotificationSettings, UNUserNotificationCenterDelegate

### Community 100 - "LongestFocusCard"
Cohesion: 0.15
Nodes (14): Design, FocusBlock, .duration, LongestFocusCard, .anchoredRange, .body, .formattedDuration, .longestBlock (+6 more)

### Community 101 - "JournalWeeklyReferenceCurve"
Cohesion: 0.20
Nodes (10): ClosedRange, BezierSegment, Comparable, CurveSample, JournalWeeklyReferenceCurve, CGFloat, CGPoint, CGSize (+2 more)

### Community 102 - "TimelapseStorageManager"
Cohesion: 0.26
Nodes (5): Int64, URL, Void, TimelapseStorageManager, .rootURL

### Community 103 - ".timelineRightColumn"
Cohesion: 0.13
Nodes (11): ChatPanelView, .body, .contentForSelectedIcon, .copyTimelineButton, ShrinkButtonStyle, Configuration, GeometryProxy, View (+3 more)

### Community 104 - "Error"
Cohesion: 0.12
Nodes (16): ScreenRecorderError, imageConversionFailed, noDisplay, screenshotFailed, MockRecognizerError, recognitionFailed, StartupError, unavailable (+8 more)

### Community 105 - "Distraction"
Cohesion: 0.18
Nodes (15): buildOnboardingSummary(), createOnboardingCard(), Distraction, getBatchStartTimestamp(), hasIntentionsForDay(), hasMinimumTimelineActivity(), IdleCardMetadata, saveTimelineCardShell() (+7 more)

### Community 106 - "MacTextView"
Cohesion: 0.16
Nodes (11): Coordinator, JournalClickableTextView, MacTextView, Context, Coordinator, Notification, NSFont, NSPoint (+3 more)

### Community 107 - "Weekday"
Cohesion: 0.20
Nodes (10): Weekday, friday, .id, monday, saturday, .shortLabel, sunday, thursday (+2 more)

### Community 108 - "FaviconService"
Cohesion: 0.29
Nodes (5): FaviconService, Never, NSImage, Task, URL

### Community 109 - "CategoryPickerPill"
Cohesion: 0.17
Nodes (15): CategoryPickerOverlay, .backgroundView, .body, .orderedCategories, CategoryPickerPill, .background, .body, .borderColor (+7 more)

### Community 110 - "TestConnectionView"
Cohesion: 0.14
Nodes (14): Bool, Color, Void, TestConnectionView, .body, .buttonBackground, .buttonBorder, .buttonTitle (+6 more)

### Community 111 - "AppDeepLinkRouter"
Cohesion: 0.22
Nodes (8): AnyObject, Action, startRecording, stopRecording, AppDeepLinkRouter, AppDeepLinkRouterDelegate, Bool, URL

### Community 112 - "SetupSidebarItem"
Cohesion: 0.21
Nodes (11): SetupSidebarItem, .body, .overlayView, .textColor, SetupSidebarView, .body, Bool, Color (+3 more)

### Community 113 - "Int"
Cohesion: 0.33
Nodes (4): CoverageSegment, Int, NSImage, TimelineReviewFrameLoader

### Community 114 - "DayflowPillButton"
Cohesion: 0.24
Nodes (11): DayflowCircleButton, .body, DayflowPillButton, .body, CGFloat, CGSize, Color, Content (+3 more)

### Community 115 - "Bool"
Cohesion: 0.23
Nodes (8): Coordinator, Any, Bool, Coordinator, Void, TimelineReviewPlaybackTimeline, .body, TrackpadScrollHandler

### Community 116 - "VideoThumbnailView"
Cohesion: 0.05
Nodes (38): CGSize, NSImage, OperationQueue, Void, ThumbnailCache, ScrollObserverNSView, ScrollObserverView, ScrollTrackingModifier (+30 more)

### Community 117 - "PlayerLayerView"
Cohesion: 0.19
Nodes (10): AVLayerVideoGravity, AVPlayerLayer, PlayerLayerView, .player, .playerLayer, AVPlayer, Context, NSCoder (+2 more)

### Community 118 - "JournalFlowState"
Cohesion: 0.20
Nodes (10): .isEditableState, JournalFlowState, boardComplete, intentionsEdit, intro, .label, reflectionEdit, reflectionPrompt (+2 more)

### Community 119 - "NotificationPreferences"
Cohesion: 0.18
Nodes (10): NotificationPreferences, .intentionHour, .intentionMinute, .isEnabled, .reflectionHour, .reflectionMinute, .weekdays, Bool (+2 more)

### Community 120 - ".load"
Cohesion: 0.27
Nodes (3): DashboardChatMemoryStore, .body, .memoryPanel

### Community 121 - "Database"
Cohesion: 0.11
Nodes (26): OpaquePointer, SQLite3, Database, DatabaseError, cannotOpen, notFound, queryFailed, SQLRow (+18 more)

### Community 122 - "README.md"
Cohesion: 0.13
Nodes (14): Automatic Timeline, Build From Source, Chat With Your Work Journal, Contributing, Daily Standup, Download, Homebrew, Install (+6 more)

### Community 123 - "CLIDetectionState"
Cohesion: 0.14
Nodes (14): ChatCLIToolStatusRow, .body, .installLabel, .shouldShowInstallButton, .statusView, CLIDetectionState, checking, .detailMessage (+6 more)

### Community 124 - "ChatCLIPromptOverrides"
Cohesion: 0.22
Nodes (6): ChatCLIPromptDefaults, ChatCLIPromptOverrides, .isEmpty, ChatCLIPromptPreferences, ChatCLIPromptSections, Bool

### Community 125 - "LogoBadgeView"
Cohesion: 0.21
Nodes (10): GlossBand, .body, LogoBadgeView, .body, CGFloat, Double, Void, .overflowGradient (+2 more)

### Community 126 - "OnboardingLLMSelectionView"
Cohesion: 0.21
Nodes (10): OnboardingLLMSelectionView, .body, OnboardingLLMSelectionView_Previews, .previews, .providerCards, Bool, Double, Never (+2 more)

### Community 127 - "AppKitComposerTextField"
Cohesion: 0.20
Nodes (9): AppKitComposerTextField, Coordinator, Coordinator, Int, Notification, NSTextView, NSControl, NSTextFieldDelegate (+1 more)

### Community 128 - "TabFilterBar"
Cohesion: 0.20
Nodes (11): .timelineContent, CategoryChip, .body, ChipRowWidthPreferenceKey, Bool, CGFloat, Void, TabFilterBar (+3 more)

### Community 129 - "GeminiModel"
Cohesion: 0.17
Nodes (11): GeminiModel, .displayName, flash25, flash3Preview, flashLite31Preview, .shortLabel, GeminiAPIHelperTests, RequestRecorder (+3 more)

### Community 131 - "ObservableObject"
Cohesion: 0.16
Nodes (8): AppState, .isRecording, AppStateManaging, Bool, NotificationBadgeManager, Bool, UpdaterManager, ObservableObject

### Community 132 - "GeminiPromptOverrides"
Cohesion: 0.14
Nodes (7): GeminiPromptDefaults, GeminiPromptOverrides, .isEmpty, GeminiPromptPreferences, GeminiPromptSections, Bool, .currentProvider

### Community 133 - "GeminiModelPreference"
Cohesion: 0.22
Nodes (4): GeminiModelPreference, .fallbackSummary, .orderedModels, UserDefaults

### Community 135 - "NSObject"
Cohesion: 0.13
Nodes (10): MainWindowManager, Notification, NSWindow, View, StatusBarController, Any, AnyCancellable, Bool (+2 more)

### Community 136 - "AutoDailyReportSettingsStore"
Cohesion: 0.26
Nodes (7): AutoDailyReportSettings, .scheduledDate, AutoDailyReportSettingsStore, .settings, Bool, Int, UserDefaults

### Community 137 - "HoverScaleModifier"
Cohesion: 0.31
Nodes (7): HoverScaleModifier, Animation, Bool, CGFloat, Content, View, View

### Community 138 - "BadgeView"
Cohesion: 0.14
Nodes (14): BadgeType, blue, green, orange, BadgeView, .badgeOverlay, .gradientColors, .kerningValue (+6 more)

### Community 139 - "HowItWorksView"
Cohesion: 0.33
Nodes (5): HowItWorksView, .body, CGFloat, Double, Void

### Community 140 - ".write"
Cohesion: 0.23
Nodes (6): Calendar, ObsidianVaultExportDestination, FileManager, URL, ObsidianVaultExportDestinationTests, URL

### Community 141 - "StepContentType"
Cohesion: 0.18
Nodes (11): StepContentType, apiKeyInput, apiKeyInstructions, cliDetection, information, .informationTitle, .isApiKeyInput, localChoice (+3 more)

### Community 142 - "ActivityType"
Cohesion: 0.22
Nodes (9): ActivityType, brainstorming, breaks, browsing, coding, .color, email, meeting (+1 more)

### Community 143 - "TimelineFailureToastPayload"
Cohesion: 0.27
Nodes (8): AnyHashable, Any, Bool, Int, Int64, TimelineFailureToastCenter, TimelineFailureToastPayload, .notificationUserInfo

### Community 144 - ".makeLog"
Cohesion: 0.27
Nodes (5): AnalysisBatchDebugEntry, fetchRecentAnalysisBatchesForDebug(), fetchRecentTimelineCardsForDebug(), TimelineCardDebugEntry, DebugLogFormatter

### Community 146 - "CategoryPill"
Cohesion: 0.15
Nodes (14): CategoryPickerView, .body, CategoryPill, .categoryColor, .pillBackground, .pillBorder, Bool, Color (+6 more)

### Community 147 - "DistractionSummaryCard"
Cohesion: 0.20
Nodes (9): Design, DistractionSummaryCard, .body, .donut, .patternBlock, .statsBlock, CGFloat, Color (+1 more)

### Community 148 - "CGRect"
Cohesion: 0.31
Nodes (7): TimelineCardsLayerFramePreferenceKey, TimelineTimeLabelFramesPreferenceKey, CGRect, .curveRect, WeeklyHoursFramePreferenceKey, ThumbnailFrameKey, PreferenceKey

### Community 149 - "ViewModifier"
Cohesion: 0.29
Nodes (6): BadgeShadowModifier, .body, CardShadowModifier, Color, Content, ViewModifier

### Community 150 - "DatabaseContentionTracker"
Cohesion: 0.42
Nodes (6): CFAbsoluteTime, ActiveDatabaseOperation, DatabaseContentionTracker, DatabaseOperationKind, RecentDatabaseOperation, QualityOfService

### Community 151 - "Dayflow Analytics Event Dictionary (Telemetry Disabled)"
Cohesion: 0.18
Nodes (10): AI / LLM / Analysis, Conventions, Dashboard Chat, Dayflow Analytics Event Dictionary (Telemetry Disabled), Lifecycle, Navigation & Timeline, Onboarding, Recording (+2 more)

### Community 153 - "Screenshot"
Cohesion: 0.20
Nodes (12): RecordingChunk, .duration, Screenshot, .capturedDate, .fileURL, Bool, Int, Int64 (+4 more)

### Community 154 - "CardsToReviewBadge"
Cohesion: 0.29
Nodes (9): CardsToReviewBadge, .stackedCardsIcon, CardsToReviewBadgePreview, .body, CardsToReviewButton, .body, Int, Void (+1 more)

### Community 155 - ".logGeminiFailure"
Cohesion: 0.29
Nodes (5): GeminiFileInfo, GeminiFileMetadata, Data, URLResponse, URLSession

### Community 156 - "APIKeyInputView"
Cohesion: 0.20
Nodes (9): APIKeyInputView, .body, .borderColor, Bool, Color, ValidationState, invalid, none (+1 more)

### Community 157 - "LLMProviderSetupView.swift"
Cohesion: 0.36
Nodes (5): LocalLLMTestConstants, LocalLLMTestImageFactory, Data, Int, TimeInterval

### Community 158 - "FlowLayout"
Cohesion: 0.31
Nodes (6): FlowLayout, CGFloat, CGSize, ProposedViewSize, Subviews, Layout

### Community 159 - "StorageCategory"
Cohesion: 0.33
Nodes (7): PendingLimit, StorageCategory, .analyticsKey, .displayName, recordings, timelapses, Int

### Community 160 - "ChatView.swift"
Cohesion: 0.14
Nodes (15): ChatContentBlock, chart, .id, text, ChatContentParser, .followUpSuggestions, FlowLayout, SuggestionChip (+7 more)

### Community 161 - "TimelineFeedbackModal"
Cohesion: 0.20
Nodes (10): Bool, Void, TimelineFeedbackModal, .body, .categoryTipsIllustration, .formContent, .thanksContent, TimelineFeedbackMode (+2 more)

### Community 162 - "sendOrFail"
Cohesion: 0.45
Nodes (10): flagValue(), collectFlagValues(), confirmDestructive(), reportWrite(), requireEditsEnabled(), runCategoriesWrite(), runGoalSet(), runTimelineWrite() (+2 more)

### Community 163 - "OllamaPromptOverrides"
Cohesion: 0.27
Nodes (6): OllamaPromptDefaults, OllamaPromptOverrides, .isEmpty, OllamaPromptPreferences, OllamaPromptSections, Bool

### Community 164 - "TimelineCard"
Cohesion: 0.27
Nodes (5): fetchTimelineCards(), fetchTimelineCardsByTimeRange(), TimelineCard, TimelineClipboardFormatter, .distractionPattern

### Community 165 - "SunriseGlassPillToggleStyle"
Cohesion: 0.24
Nodes (7): SunriseGlassPillToggleStyle, Bool, CGFloat, Color, Configuration, View, ToggleStyle

### Community 166 - "ScreenRecordingPermissionView"
Cohesion: 0.22
Nodes (7): PermissionState, granted, needsAction, notRequested, ScreenRecordingPermissionView, .body, Void

### Community 167 - "CanvasActivityCard"
Cohesion: 0.12
Nodes (19): CanvasActivityCard, .backupIndicator, .body, .isCompactCard, .isFailedCard, .selectionStroke, CanvasActivityCardStyle, CanvasCardButtonStyle (+11 more)

### Community 168 - "HelpfulFeatureOption"
Cohesion: 0.20
Nodes (10): HelpfulFeatureOption, .analyticsValue, dayStartContext, distractionNudges, focusFragmentationTrends, historySearch, meetingSummaries, .title (+2 more)

### Community 169 - "Field"
Cohesion: 0.18
Nodes (11): Field, description, name, Field, intentionHour, intentionMinute, intentionPeriod, reflectionHour (+3 more)

### Community 170 - ".usageRow"
Cohesion: 0.25
Nodes (6): SettingsStorageTabView, .body, Color, Int, Int64, Void

### Community 171 - "Stage"
Cohesion: 0.40
Nodes (5): Stage, answering, error, runningTools, thinking

### Community 172 - "OpenAICompatibleConfigurationTests"
Cohesion: 0.22
Nodes (4): IgnoringUserDefaults, OpenAICompatibleConfigurationTests, Any, Set

### Community 173 - ".userNotificationCenter"
Cohesion: 0.22
Nodes (5): Void, UNNotification, UNNotificationPresentationOptions, UNNotificationResponse, UNUserNotificationCenter

### Community 174 - ".retrieve"
Cohesion: 0.31
Nodes (3): KeychainManager, Bool, Security

### Community 175 - "ObsidianWritePosition"
Cohesion: 0.22
Nodes (9): ObsidianWritePosition, afterLine, beforeLine, beginFile, endFile, .id, .label, .requiresAnchor (+1 more)

### Community 176 - "TimelineCanvas"
Cohesion: 0.62
Nodes (4): TimelineCanvas, .body, .points, TimelinePoint

### Community 177 - ".migrateIfNeeded"
Cohesion: 0.33
Nodes (3): FileManager, UserDefaults, UserDefaultsMigrator

### Community 178 - "ProviderCardComponents.swift"
Cohesion: 0.22
Nodes (7): Color, .cardBackground, .cardOverlay, SelectedCardBackground, .body, SelectedCardOverlay, .body

### Community 179 - "ReminderField"
Cohesion: 0.19
Nodes (13): DayChip, .body, .body, HoverInteractionModifier, ReminderField, .body, Alignment, Binding (+5 more)

### Community 180 - "WeeklyDashboardBuilderTests"
Cohesion: 0.36
Nodes (3): Int, T, WeeklyDashboardBuilderTests

### Community 181 - "Repository Guidelines"
Cohesion: 0.25
Nodes (7): Build, Test, and Development Commands, Coding Style & Naming Conventions, Commit & Pull Request Guidelines, Project Structure & Module Organization, Release & Configuration Tips, Repository Guidelines, Testing Guidelines

### Community 182 - "EntryType"
Cohesion: 0.25
Nodes (8): EntryType, error, info, prompt, response, toolDetected, toolResult, user

### Community 183 - ".body"
Cohesion: 0.19
Nodes (8): Double, TimeInterval, Void, Any, Timer, VideoPlayerModal, .body, .scrubberURL

### Community 184 - "SplashView"
Cohesion: 0.31
Nodes (6): SplashView, .body, SplashWindow, Double, Void, NSWindow

### Community 185 - ".activity"
Cohesion: 0.46
Nodes (3): Int, Int64, TimelineActivityLoaderTests

### Community 186 - "View"
Cohesion: 0.06
Nodes (42): DayflowButton, .body, DayflowButton_Previews, .previews, Bool, CGFloat, Void, HowItWorksCard (+34 more)

### Community 187 - "ProviderIconView"
Cohesion: 0.33
Nodes (6): .iconSection, ProviderIconView, .body, .containerWidth, .iconContent, CGFloat

### Community 188 - "LaunchAtLoginManager"
Cohesion: 0.31
Nodes (3): LaunchAtLoginManager, Bool, .contentWithLifecycle

### Community 189 - "DayflowUITestsLaunchTests"
Cohesion: 0.33
Nodes (3): DayflowUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool

### Community 190 - "VideoCodec"
Cohesion: 0.40
Nodes (5): AVVideoCodecType, VideoCodec, .avCodecType, h264, hevc

### Community 192 - "LLMProviderType"
Cohesion: 0.50
Nodes (4): LLMProviderType, chatGPTClaude, geminiDirect, ollamaLocal

### Community 193 - "TimelineCopyState"
Cohesion: 0.50
Nodes (4): TimelineCopyState, copied, copying, idle

### Community 194 - ".relocateDirectoryContents"
Cohesion: 0.40
Nodes (3): StoragePathMigrator, FileManager, URL

### Community 195 - "CompletionView"
Cohesion: 0.28
Nodes (7): CompletionView, .body, .canProceed, OnboardingCategorySetupView, .body, Bool, Void

### Community 196 - "SetupContinueButton"
Cohesion: 0.47
Nodes (4): SetupContinueButton, .body, Bool, Void

### Community 197 - "DashboardToolName"
Cohesion: 0.67
Nodes (3): DashboardToolName, fetchObservations, fetchTimeline

### Community 198 - "AnimationPhase"
Cohesion: 0.33
Nodes (6): AnimationPhase, collapsed, collapsing, expanded, flying, lifting

### Community 199 - "Period"
Cohesion: 0.29
Nodes (6): Period, am, .display, .id, pm, Int

### Community 200 - "release.sh"
Cohesion: 0.60
Nodes (4): err(), require(), set_plist(), release.sh script

### Community 203 - "Direction"
Cohesion: 0.67
Nodes (3): Direction, left, right

### Community 204 - "Position"
Cohesion: 0.67
Nodes (3): Position, above, below

### Community 205 - ".migrateIfNeeded"
Cohesion: 0.60
Nodes (3): OnboardingStepMigration, UserDefaults, Int

### Community 206 - "JournalReminderPillButtonStyle"
Cohesion: 0.50
Nodes (3): JournalReminderPillButtonStyle, Color, Configuration

### Community 207 - "APIError"
Cohesion: 0.11
Nodes (17): DashboardToolArgError, .errorDescription, invalidCombination, invalidDate, invalidRange, APIError, apiError, .errorDescription (+9 more)

### Community 209 - "GatePhase"
Cohesion: 0.40
Nodes (5): GatePhase, granted, hidden, locked, requesting

### Community 211 - "DailyStandupRegenerateState"
Cohesion: 0.50
Nodes (4): DailyStandupRegenerateState, idle, regenerated, regenerating

### Community 213 - "Dayflow Assets"
Cohesion: 0.50
Nodes (3): Dayflow Assets, Files:, Usage in README:

### Community 214 - "supervisor.md"
Cohesion: 0.50
Nodes (3): model:, standalone: true, tools: read,write,edit,bash,grep,find,ls

### Community 215 - "Category"
Cohesion: 0.67
Nodes (3): Category, loadCategories(), Bool

### Community 216 - "LLMOutputLanguagePreferences"
Cohesion: 0.50
Nodes (3): LLMOutputLanguagePreferences, .normalizedOverride, .override

### Community 223 - "ReviewRatingKey"
Cohesion: 0.50
Nodes (4): ReviewRatingKey, distracted, focused, neutral

## Knowledge Gaps
- **761 isolated node(s):** `startRecording`, `stopRecording`, `.isRecording`, `.currentAppVersion`, `.hasPendingNotificationNavigation` (+756 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **15 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `TimelineReviewSummaryCard`, `GeminiDirectProvider`, `DailyRecapScheduler`, `PauseManager`, `OllamaProvider`, `DaySummaryView`, `StatusMenuView`, `ChatCLITool`, `ChatCLIProvider`, `ProvidersSettingsViewModel`, `LLMProviderRoutingTests`, `ChatView`, `ChatService`, `ToolCallBubble`, `LLMCallContext`, `Observation`, `Int`, `CategorySelectionEditor`, `AnalysisManager`, `Sendable`, `LocalEngine`, `WorkStatusCard`, `DailyView`, `StorageManager.swift`, `Date`, `TimelineReviewOverlay`, `TimelineCategory`, `StorageSettingsViewModel`, `OtherSettingsViewModel`, `ProviderSetupState`, `.generateActivityCards`, `ColorOrganizerRoot`, `DailyBulletCard`, `MainView`, `ClaudeActivityCardBoundaryTests`, `Identifiable`, `TimelineReviewCard`, `Breadcrumb`, `JournalDayManager`, `VideoExpansionOverlay`, `ChatStreamEvent`, `NSColor`, `CanvasTimelineDataView`, `CLITool`, `TimelineSpinnerModel`, `ChatCLIProcessRunner`, `ReferralOption`, `CaseIterable`, `CodexClaudeProviderTests`, `json`, `IntentionsEditForm`, `TimelineReviewPlayerModel`, `AppRootView`, `ChatChartSpec`, `JournalBoardLayout`, `ColorPickerView`, `JournalDayView.swift`, `WhatsNewView`, `MCPServer.swift`, `XCTestCase`, `TimelineActivity`, `ScreenshotSlideshowPlaybackModel`, `DayflowSurfaceButton`, `TimelineRateSummaryView`, `.export`, `ObsidianExportSettings`, `SentryHelper.swift`, `OnboardingFlow`, `JournalRemindersView`, `ScrubberView`, `TimelineReviewRating`, `ChatToolExecutor`, `ScreenRecorder`, `VideoPlayerViewModel`, `FlexibleProviderCard`, `ScreenshotScrubberView`, `LLMService`, `CategoryDonutChart`, `CodingKeys`, `.run`, `Render.swift`, `Codable`, `SettingsView`, `AnalyticsService`, `ProviderPromptPreferencesTests`, `VideoProcessingService`, `SidebarIcon`, `RetryCoordinator`, `AppDelegate`, `NotificationService`, `LongestFocusCard`, `.timelineRightColumn`, `Error`, `Distraction`, `MacTextView`, `Weekday`, `FaviconService`, `CategoryPickerPill`, `TestConnectionView`, `AppDeepLinkRouter`, `SetupSidebarItem`, `DayflowPillButton`, `Bool`, `VideoThumbnailView`, `JournalFlowState`, `.load`, `Database`, `CLIDetectionState`, `ChatCLIPromptOverrides`, `LogoBadgeView`, `OnboardingLLMSelectionView`, `AppKitComposerTextField`, `GeminiModel`, `ObservableObject`, `GeminiPromptOverrides`, `GeminiModelPreference`, `DailyRecapGeneratorTests`, `BadgeView`, `HowItWorksView`, `.write`, `StepContentType`, `ActivityType`, `TimelineFailureToastPayload`, `.makeLog`, `AutoDailyReportService`, `CategoryPill`, `DistractionSummaryCard`, `DatabaseContentionTracker`, `.capture`, `Screenshot`, `.logGeminiFailure`, `APIKeyInputView`, `LLMProviderSetupView.swift`, `StorageCategory`, `ChatView.swift`, `TimelineFeedbackModal`, `sendOrFail`, `OllamaPromptOverrides`, `TimelineCard`, `CanvasActivityCard`, `HelpfulFeatureOption`, `.usageRow`, `OpenAICompatibleConfigurationTests`, `.retrieve`, `ObsidianWritePosition`, `ProviderCardComponents.swift`, `ReminderField`, `WeeklyDashboardBuilderTests`, `EntryType`, `.body`, `.activity`, `View`, `ProviderIconView`, `VideoCodec`, `LLMProviderType`, `CompletionView`, `SetupContinueButton`, `DashboardToolName`, `Period`, `DebugLogEntry`, `APIError`, `.validateTimeCoverage`, `Category`, `LLMOutputLanguagePreferences`, `ReviewRatingKey`?**
  _High betweenness centrality (0.704) - this node is a cross-community bridge._
- **Why does `MainView` connect `MainView` to `TabFilterBar`, `ObservableObject`, `SwiftUI`, `TimelineFailureToastPayload`, `CGRect`, `Date`, `CardsToReviewBadge`, `TimelineCategory`, `ColorOrganizerRoot`, `TimelineFeedbackModal`, `Support.swift`, `TimelineCard`, `VideoExpansionOverlay`, `AppRootView`, `View`, `TimelineCopyState`, `TimelineActivity`, `String`, `TimelineRateSummaryView`, `SidebarIcon`, `RetryCoordinator`, `.timelineRightColumn`?**
  _High betweenness centrality (0.034) - this node is a cross-community bridge._
- **Why does `TimelineReviewCard` connect `TimelineReviewCard` to `TimelineReviewSummaryCard`, `TimelineActivity`, `String`, `TimelineReviewRating`, `Int`, `Bool`, `TimelineReviewPlayerModel`, `View`, `TimelineReviewOverlay`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._
- **Are the 7 inferred relationships involving `ProvidersSettingsViewModel` (e.g. with `SettingsView` and `.testEditingClaudePromptDoesNotMutateCodexPrompt()`) actually correct?**
  _`ProvidersSettingsViewModel` has 7 INFERRED edges - model-reasoned connections that need verification._
- **What connects `startRecording`, `stopRecording`, `.isRecording` to the rest of the system?**
  _761 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `TimelineReviewSummaryCard` be split into smaller, more focused modules?**
  _Cohesion score 0.051577152600170505 - nodes in this community are weakly interconnected._
- **Should `GeminiDirectProvider` be split into smaller, more focused modules?**
  _Cohesion score 0.11819727891156463 - nodes in this community are weakly interconnected._