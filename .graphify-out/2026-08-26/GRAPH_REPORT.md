# Graph Report - Dayflow  (2026-08-26)

## Corpus Check
- 299 files · ~2,067,814 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 4570 nodes · 11512 edges · 226 communities (211 shown, 15 thin omitted)
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
- ComposerTextField
- ChatCLITool
- ChatCLIProvider
- ProvidersSettingsViewModel
- LLMProviderRoutingTests
- ChatView
- SwiftUI
- ChatService
- ButtonStyle
- LLMCallContext
- Observation
- Int
- DaySummaryView.swift
- AnalysisManager
- VideoProcessingError
- Sendable
- DayflowSurfaceButton
- ChatView.swift
- DailyView
- StorageManager.swift
- View
- TimelineReviewOverlay
- TimelineCategory
- StorageSettingsViewModel
- SettingsDataTabView
- ProviderSetupState
- .generateActivityCards
- ColorOrganizerRoot
- DailyBulletCard
- Support.swift
- MainView
- ClaudeActivityCardBoundaryTests
- Identifiable
- Bool
- TimelineReviewCard
- Breadcrumb
- JournalDayManager
- VideoExpansionOverlay
- ChatStreamEvent
- ClaudeTranscriptionInputBuilderTests
- SilentUserDriver
- CanvasTimelineDataView
- NonInteractiveAVPlayerView
- CLITool
- TimelineSpinnerModel
- ChatCLIProcessRunner
- ReferralOption
- CaseIterable
- CodexClaudeProviderTests
- json
- JournalPillButtonStyle
- TimelineReviewPlayerModel
- AppRootView
- ChatChartSpec
- Bool
- ColorPickerView
- JournalDayView.swift
- WhatsNewView
- MCPServer.swift
- XCTestCase
- TimelineActivity
- ScreenshotSlideshowPlaybackModel
- SettingsProvidersTabView
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
- LLMProcessingStep
- SidebarIcon
- RetryCoordinator
- XCTest
- AppDelegate
- InactivityMonitor
- NotificationService
- Date
- VideoLaunchView
- TimelapseStorageManager
- .jpegData
- Error
- Distraction
- MacTextView
- Weekday
- FaviconService
- CategoryPickerPill
- TestConnectionView
- AppDeepLinkRouter
- StepContentType
- ObsidianSettingsStore
- DayflowPillButton
- OtherSettingsViewModel
- ObservingView
- PlayerLayerView
- JournalFlowState
- NotificationPreferences
- VideoThumbnailView
- Database
- README.md
- ScrollObserverNSView
- ToolCallBubble
- NSViewRepresentable
- OnboardingLLMSelectionView
- AppKitComposerTextField
- TabFilterBar
- GeminiModel
- ChatCLIRunner.swift
- ObservableObject
- GeminiPromptOverrides
- ActiveDisplayTracker
- DailyRecapGeneratorTests
- NSObject
- AutoDailyReportSettingsStore
- HoverScaleModifier
- BadgeView
- HowItWorksView
- .write
- TimelineReviewOverlay.swift
- ActivityType
- TimelineFailureToastPayload
- MessageBubble
- AutoDailyReportService
- CategoryPill
- DistractionSummaryCard
- CGRect
- FeatureRowView
- DatabaseContentionTracker
- Dayflow Analytics Event Dictionary (Telemetry Disabled)
- .capture
- Screenshot
- CardsToReviewBadge
- .readAllData
- APIKeyInputView
- .blankImageDataURL
- UnitPoint
- ScreenshotSlideshowModal
- FlowLayout
- TimelineFeedbackModal
- sendOrFail
- OllamaPromptOverrides
- TimelineCard
- ComposerTextFieldCell
- ScreenRecordingPermissionView
- CanvasActivityCard
- DailyModeToggle
- Field
- .usageRow
- Stage
- OpenAICompatibleConfigurationTests
- .userNotificationCenter
- .fetchThumbnail
- .fetchThumbnail
- MainWindowManager
- BadgeType
- ProviderCardComponents.swift
- ReminderField
- WeeklyDashboardBuilderTests
- Repository Guidelines
- EntryType
- .body
- SplashView
- .activity
- PreviewProvider
- ProviderIconView
- LaunchAtLoginManager
- IntentionsEditForm
- CategorySelectionEditor
- CodexExecutableResolverTests
- NSColor
- .chatCompletionsURL
- .relocateDirectoryContents
- CompletionView
- SetupContinueButton
- Status
- VideoExpansionState
- Period
- release.sh
- DayflowUITests
- .screenshots
- StoragePreferences
- DashboardChatTurnRole
- .migrateIfNeeded
- JournalReminderPillButtonStyle
- DashboardToolArgError
- .validateTimeCoverage
- GatePhase
- RetryStrategy
- DailyStandupRegenerateState
- SettingsCard
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
- TerminalCommandView
- DatePickerSheet

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

## Communities (226 total, 15 thin omitted)

### Community 0 - "TimelineReviewSummaryCard"
Cohesion: 0.05
Nodes (55): DateFormatter, .reviewSection, Design, ReviewMetric, ReviewMetricStyle, Bool, CGFloat, Color (+47 more)

### Community 1 - "GeminiDirectProvider"
Cohesion: 0.11
Nodes (18): DashboardDateRange, DashboardFunctionCall, DashboardToolName, fetchObservations, fetchTimeline, DashboardTurnResult, GeminiDirectProvider, .dashboardDateFormatter (+10 more)

### Community 2 - "DailyRecapScheduler"
Cohesion: 0.11
Nodes (10): DailyRecapScheduler, PersistedDailyBulletItem, PersistedDailyStandupDraft, DispatchSourceTimer, Int, TimeInterval, UUID, DayflowBackendProvider (+2 more)

### Community 3 - "PauseManager"
Cohesion: 0.05
Nodes (43): PauseDuration, .analyticsValue, hour1, indefinite, minutes15, minutes30, .timeInterval, PauseManager (+35 more)

### Community 4 - "OllamaProvider"
Cohesion: 0.08
Nodes (31): Bool, ActivityCardData, ActivityGenerationContext, Distraction, ChatRequest, FrameData, ImageURL, MessageContent (+23 more)

### Community 5 - "DaySummaryView"
Cohesion: 0.11
Nodes (21): CardWithDuration, DaySummaryView, .body, .categoryDurations, .daySoFarSection, .distractedRatio, .distractionsSection, .emptyChartPlaceholder (+13 more)

### Community 6 - "ComposerTextField"
Cohesion: 0.20
Nodes (7): ComposerTextField, .composerCell, .stringValue, Context, NSCoder, NSFont, NSTextField

### Community 7 - "ChatCLITool"
Cohesion: 0.10
Nodes (20): ChatCLITool, claude, codex, ConfiguredBackupProvider, Result, Void, BatchingConfig, LLMProviderID (+12 more)

### Community 8 - "ChatCLIProvider"
Cohesion: 0.10
Nodes (14): ChatCLIProvider, AsyncThrowingStream, Bool, Double, Error, Int, Int64, TimeInterval (+6 more)

### Community 9 - "ProvidersSettingsViewModel"
Cohesion: 0.06
Nodes (30): ProvidersSettingsViewModel, .backupProviderDisplayName, .chatCLIDetailedPromptText, .chatCLISummaryPromptText, .chatCLITitlePromptText, .connectionHealthLabel, .geminiDetailedPromptText, .geminiSummaryPromptText (+22 more)

### Community 10 - "LLMProviderRoutingTests"
Cohesion: 0.11
Nodes (6): LLMProviderRoutingTests, RecordingUserDefaults, Any, Set, LegacyLLMProviderMigration, UserDefaults

### Community 11 - "ChatView"
Cohesion: 0.06
Nodes (31): DashboardChatMemoryStore, DashboardChatProvider, .analyticsProvider, .chatCLITool, claude, codex, gemini, .runtimeLabel (+23 more)

### Community 12 - "SwiftUI"
Cohesion: 0.10
Nodes (12): AppKit, AVFoundation, Combine, CoreGraphics, ProviderSetupWrapper, Foundation, ImageIO, ScreenCaptureKit (+4 more)

### Community 13 - "ChatService"
Cohesion: 0.09
Nodes (19): AssistantMetadata, ChatDebugEntry, .typeColor, ChatService, ChatWorkStatus, .hasDetails, .hasErrors, Bool (+11 more)

### Community 14 - "ButtonStyle"
Cohesion: 0.14
Nodes (17): ButtonStyle, JournalHeroPillButtonStyle, JournalHeroSummary, .preview, JournalHeroTokens, JournalHeroView, .backgroundLayer, .badgeHeader (+9 more)

### Community 15 - "LLMCallContext"
Cohesion: 0.12
Nodes (19): LLMCallContext, LLMHTTPInfo, LLMLogger, LLMLogStatus, failure, success, Data, Int (+11 more)

### Community 16 - "Observation"
Cohesion: 0.14
Nodes (21): FrameData, FrameDescriptionEnvelope, GemmaBackupProvider, Item, MergeDecision, SegmentCoverageError, SegmentEnvelope, SummaryResponse (+13 more)

### Community 17 - "Int"
Cohesion: 0.09
Nodes (39): allBatches(), AnalysisBatchDebugEntry, chunksForBatch(), DatabaseContentionSnapshot, read, fetchBatchLLMMetadata(), fetchChunksInTimeRange(), fetchJournalDays() (+31 more)

### Community 18 - "DaySummaryView.swift"
Cohesion: 0.08
Nodes (30): CheckmarkShape, ConfettiBurstView, .body, ConfettiPiece, .body, .earlyAccessGateOverlay, .gateActionArea, Design (+22 more)

### Community 19 - "AnalysisManager"
Cohesion: 0.12
Nodes (19): AnalysisManager, AnalysisManaging, IdleBatchAssessment, IdleBatchRules, ScreenshotBatch, .count, .duration, Bool (+11 more)

### Community 20 - "VideoProcessingError"
Cohesion: 0.07
Nodes (33): AVAssetExportSession, AVVideoCodecType, CVPixelBuffer, CVPixelBufferPool, Bool, CGImage, Int, URL (+25 more)

### Community 21 - "Sendable"
Cohesion: 0.11
Nodes (35): CryptoKit, computeDailyWorkflow(), DailyBlockersSection, .body, DailyDragHandleIcon, .body, DailyGridConfig, DailyStandupPlaceholder (+27 more)

### Community 22 - "DayflowSurfaceButton"
Cohesion: 0.07
Nodes (35): LocalEngine, custom, .defaultBaseURL, .displayName, .id, lmstudio, ollama, LocalModelInstructionSet (+27 more)

### Community 23 - "ChatView.swift"
Cohesion: 0.06
Nodes (37): AnimatedEllipsis, .body, BetaButtonStyle, .betaLockScreen, .welcomePrompts, .welcomeView, DebugLogEntry, .body (+29 more)

### Community 24 - "DailyView"
Cohesion: 0.10
Nodes (12): DailyStandupDraft, DailyStandupSectionTitles, DailyView, .accessCodeCard, .body, .regenerateButtonLabel, .unlockedContent, Bool (+4 more)

### Community 25 - "StorageManager.swift"
Cohesion: 0.11
Nodes (41): allocatedSizeOfDirectory(), applyReviewRating(), cleanupRecordingStragglers(), write, deleteObservations(), deleteTimelineCard(), deleteTimelineCards(), fetchJournalEntry() (+33 more)

### Community 26 - "View"
Cohesion: 0.11
Nodes (20): DailyCopyPressButtonStyle, Configuration, ExportDatePicker, end, start, ExportResult, SettingsObsidianTabView, .autoExportCard (+12 more)

### Community 27 - "TimelineReviewOverlay"
Cohesion: 0.10
Nodes (21): CoverageSegment, IndexedActivity, ReviewLayout, CGSize, TimelineReviewInput, button, drag, keyboard (+13 more)

### Community 28 - "TimelineCategory"
Cohesion: 0.15
Nodes (11): CategoryPersistence, .defaultCategories, CategoryStore, .editableCategories, .idleCategory, StoreKeys, Bool, Int (+3 more)

### Community 29 - "StorageSettingsViewModel"
Cohesion: 0.16
Nodes (15): ByteCountFormatter, PendingLimit, StorageCategory, .analyticsKey, .displayName, recordings, timelapses, StorageLimitOption (+7 more)

### Community 30 - "SettingsDataTabView"
Cohesion: 0.19
Nodes (11): ExportDatePicker, end, start, SettingsDataTabView, .body, .exportDataCard, .reprocessDayCard, Binding (+3 more)

### Community 31 - "ProviderSetupState"
Cohesion: 0.07
Nodes (17): GeminiModelPreference, .fallbackSummary, .orderedModels, UserDefaults, .savedModelId, LLMProviderSetupView, .activeProviderType, .body (+9 more)

### Community 32 - ".generateActivityCards"
Cohesion: 0.16
Nodes (10): ModelRunState, .current, Data, Int, Int64, TimeInterval, URL, VideoTranscriptChunk (+2 more)

### Community 33 - "ColorOrganizerRoot"
Cohesion: 0.10
Nodes (25): ColorAssignmentCard, .body, ColorOrganizerRoot, .addCategoryButton, .backgroundView, .body, .canAddMoreCategories, .categories (+17 more)

### Community 34 - "DailyBulletCard"
Cohesion: 0.10
Nodes (24): DailyBulletCard, .addItemButton, .body, .cardShape, .itemListEditor, .listMinHeight, .listViewportHeight, DailyBulletItem (+16 more)

### Community 35 - "Support.swift"
Cohesion: 0.12
Nodes (15): DateNavigationControls, .body, Bool, CGFloat, AnyTransition, .blurReplace, BlurReplaceModifier, canNavigateForward() (+7 more)

### Community 36 - "MainView"
Cohesion: 0.06
Nodes (34): ChatPanelView, .body, Bool, .contentForSelectedIcon, .contentStack, .copyTimelineButton, .mainLayout, .mainPanelBackground (+26 more)

### Community 37 - "ClaudeActivityCardBoundaryTests"
Cohesion: 0.17
Nodes (4): ClaudeActivityCardBoundaryTests, Bool, Int, Int64

### Community 38 - "Identifiable"
Cohesion: 0.18
Nodes (20): BasicChartSpec, ChartPoint, ChatChartBlockView, .body, .chartBody, DonutChartSpec, DonutSlice, GanttChartSpec (+12 more)

### Community 39 - "Bool"
Cohesion: 0.10
Nodes (19): Coordinator, KeyCaptureView, .acceptsFirstResponder, Any, Bool, Context, Coordinator, NSCoder (+11 more)

### Community 40 - "TimelineReviewCard"
Cohesion: 0.11
Nodes (18): Design, SpeedChipDesign, CGFloat, Color, TimelineReviewCard, .activeCurrentTime, .activeDuration, .body (+10 more)

### Community 41 - "Breadcrumb"
Cohesion: 0.13
Nodes (21): DatabasePool, checkpoint(), createBackup(), findMostRecentBackup(), init(), openDatabaseSafely(), performIntegrityCheck(), pruneOldBackups() (+13 more)

### Community 42 - "JournalDayManager"
Cohesion: 0.12
Nodes (9): JournalDayManager, .canNavigateForward, .ctaTitle, .goalsList, .headline, .intentionsList, Bool, .contentForFlowState (+1 more)

### Community 43 - "VideoExpansionOverlay"
Cohesion: 0.12
Nodes (14): ScaleButtonStyle, Configuration, Namespace, VideoExpansionOverlay, .activeAspectRatio, .body, .headerOffset, .headerOpacity (+6 more)

### Community 44 - "ChatStreamEvent"
Cohesion: 0.21
Nodes (9): ChatStreamEvent, complete, error, sessionStarted, textDelta, thinking, toolEnd, toolStart (+1 more)

### Community 45 - "ClaudeTranscriptionInputBuilderTests"
Cohesion: 0.17
Nodes (8): ClaudeFrameTextRecognizing, ClaudeRecognizedTextBlock, ClaudeTranscriptionInputBuilderTests, MockRecognizer, Double, Float, Int, URL

### Community 46 - "SilentUserDriver"
Cohesion: 0.10
Nodes (13): SilentUserDriver, Bool, Double, Error, UInt64, Void, SPUDownloadData, SPUUpdatePermissionRequest (+5 more)

### Community 47 - "CanvasTimelineDataView"
Cohesion: 0.14
Nodes (19): CanvasPositionedActivity, CanvasTimelineDataView, .body, .currentTimeIndicator, .hourLines, .mainTimelineRow, .pausedStatusGradient, .pausedStatusText (+11 more)

### Community 48 - "NonInteractiveAVPlayerView"
Cohesion: 0.17
Nodes (9): AVPlayerView, AVPlayerControllerRepresented, NonInteractiveAVPlayerView, .acceptsFirstResponder, Bool, Context, NSEvent, NSPoint (+1 more)

### Community 49 - "CLITool"
Cohesion: 0.06
Nodes (46): .isProviderConfigured, ChatCLIDetectionStepView, .body, .canContinue, ChatCLITestView, .body, ChatCLIToolStatusRow, .body (+38 more)

### Community 50 - "TimelineSpinnerModel"
Cohesion: 0.13
Nodes (18): CFTimeInterval, .generatingStatusText, CGFloat, Color, Double, Int, Timer, TimelineSpinnerConfig (+10 more)

### Community 51 - "ChatCLIProcessRunner"
Cohesion: 0.16
Nodes (4): ChatCLIProcessRunner, ClaudeCLIExecutionProfileTests, ChatCLIProcessRunnerTests, URL

### Community 52 - "ReferralOption"
Cohesion: 0.10
Nodes (23): ReferralOption, .analyticsValue, .detailPlaceholder, .displayName, friend, hackerNews, .id, newsletterBlog (+15 more)

### Community 53 - "CaseIterable"
Cohesion: 0.07
Nodes (42): CaseIterable, ClosedRange, BezierSegment, Comparable, CurveSample, JournalWeeklyCircleButton, .body, JournalWeeklyDay (+34 more)

### Community 55 - "json"
Cohesion: 0.18
Nodes (26): failJSON(), json(), printJSON(), Any, Bool, Int32, Never, timelineEnvelope() (+18 more)

### Community 56 - "JournalPillButtonStyle"
Cohesion: 0.16
Nodes (16): .body, .body, .body, JournalDayTokens, JournalPillButtonStyle, ReflectionEditorCard, .body, .isSaveDisabled (+8 more)

### Community 57 - "TimelineReviewPlayerModel"
Cohesion: 0.14
Nodes (12): Double, Float, Int, Never, NSImage, Task, .speedChip, TimelineReviewFrameLoader (+4 more)

### Community 58 - "AppRootView"
Cohesion: 0.19
Nodes (10): AppRootView, .body, .currentAppVersion, ReleaseNote, .semanticVersion, Int, WhatsNewConfiguration, .configuredRelease (+2 more)

### Community 59 - "ChatChartSpec"
Cohesion: 0.10
Nodes (28): ClaudeDelta, ClaudeEvent, ClaudeJSONLEvent, BasicPayload, ChatChartSpec, bar, donut, gantt (+20 more)

### Community 60 - "Bool"
Cohesion: 0.20
Nodes (13): JournalBoardLayout, .body, JournalLeftCardView, .body, JournalRightCard, .body, PaperHoverEffect, Bool (+5 more)

### Community 61 - "ColorPickerView"
Cohesion: 0.15
Nodes (20): Color, .spectrumColors, ColorPickerView, .body, .colorHex, .hue, .light, .normalizedRadius (+12 more)

### Community 62 - "JournalDayView.swift"
Cohesion: 0.13
Nodes (25): Direction, left, right, IntroView, JournalDayBulletList, .body, JournalDayCircleButton, JournalDaySegmentedControl (+17 more)

### Community 63 - "WhatsNewView"
Cohesion: 0.06
Nodes (38): HelpfulFeatureOption, .analyticsValue, dayStartContext, distractionNudges, focusFragmentationTrends, historySearch, meetingSummaries, .title (+30 more)

### Community 64 - "MCPServer.swift"
Cohesion: 0.27
Nodes (23): callTool(), emit(), openDB(), reply(), replyError(), resolveWindow(), runActivityDetailTool(), runDailyTool() (+15 more)

### Community 65 - "XCTestCase"
Cohesion: 0.07
Nodes (10): parseTimeHMMA(), Int, AgentWriteHandlersTests, DaySummaryLoadTokenTests, TimelineProviderStartupSelectionTests, TimeParsingTests, DayflowUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration (+2 more)

### Community 66 - "TimelineActivity"
Cohesion: 0.16
Nodes (12): ActivityCard, .body, Bool, CGSize, Color, Text, AppSites, Distraction (+4 more)

### Community 67 - "ScreenshotSlideshowPlaybackModel"
Cohesion: 0.20
Nodes (10): ScreenshotSlideshowFrameLoader, ScreenshotSlideshowPlaybackModel, .playbackIntervalSeconds, .timelineDurationSeconds, Double, Int, Never, Task (+2 more)

### Community 68 - "SettingsProvidersTabView"
Cohesion: 0.09
Nodes (17): CompactProviderInfo, .providerTableName, ProviderRoutingRole, primary, secondary, setupOnly, .providerCatalog, Bool (+9 more)

### Community 69 - "String"
Cohesion: 0.10
Nodes (17): ChatCLIPromptSections, ChatMessage, .isRunning, Role, assistant, toolCall, user, Bool (+9 more)

### Community 70 - "TimelineRateSummaryView"
Cohesion: 0.12
Nodes (16): Any, Bool, Never, Task, Void, TimelineDeleteButtonState, confirming, deleting (+8 more)

### Community 71 - ".export"
Cohesion: 0.13
Nodes (16): AnchorMode, after, before, ObsidianExporter, ObsidianExportError, emptyContent, .errorDescription, invalidDirectory (+8 more)

### Community 72 - "ObsidianExportSettings"
Cohesion: 0.15
Nodes (14): ObsidianExportSettings, .directoryPaths, .directoryURL, ObsidianWritePosition, afterLine, beforeLine, beginFile, endFile (+6 more)

### Community 73 - "SentryHelper.swift"
Cohesion: 0.13
Nodes (12): Scope, SentryHelper, SentrySDK, SentrySpanStatus, cancelled, internalError, ok, unknown (+4 more)

### Community 74 - "OnboardingFlow"
Cohesion: 0.14
Nodes (18): OnboardingCategorySetupView, .body, OnboardingFlow, .body, OnboardingFlow_Previews, .previews, Step, categories (+10 more)

### Community 75 - "JournalRemindersView"
Cohesion: 0.17
Nodes (20): DayChip, .body, DayChipRow, .body, JournalRemindersView, .body, JournalRemindersView_Previews, .previews (+12 more)

### Community 76 - "ScrubberView"
Cohesion: 0.18
Nodes (14): Comparable, FilmstripGenerator, ScrubberView, .body, .totalHeight, Bool, CGFloat, Double (+6 more)

### Community 77 - "TimelineReviewRating"
Cohesion: 0.09
Nodes (25): Angle, LinearGradient, .body, TimelineReviewFooterIcon, .body, .rotation, TimelineReviewRating, .barGradient (+17 more)

### Community 78 - "ChatToolExecutor"
Cohesion: 0.18
Nodes (11): ChatTool, .displayName, fetchObservations, fetchTimeline, ChatToolExecutor, .toolDescription, ChatToolRequest, .toolType (+3 more)

### Community 79 - "ScreenRecorder"
Cohesion: 0.15
Nodes (16): dbg(), RecorderState, .canStart, capturing, .description, idle, paused, starting (+8 more)

### Community 80 - "VideoPlayerViewModel"
Cohesion: 0.24
Nodes (8): Any, AVPlayer, CGFloat, Double, Float, URL, .scrubberView, VideoPlayerViewModel

### Community 81 - "FlexibleProviderCard"
Cohesion: 0.17
Nodes (12): FlexibleProviderCard, .actionButton, .body, .buttonAction, .buttonBackgroundColor, .buttonForegroundColor, .buttonTitle, .isButtonDisabled (+4 more)

### Community 82 - "ScreenshotScrubberView"
Cohesion: 0.19
Nodes (10): Comparable, ScreenshotFilmstripGenerator, ScreenshotScrubberView, .body, .totalHeight, CGFloat, NSImage, OperationQueue (+2 more)

### Community 83 - "LLMService"
Cohesion: 0.20
Nodes (10): BatchProviderActions, GemmaFallbackState, LLMService, .batchingConfig, .providerType, AsyncThrowingStream, Error, TextProviderActions (+2 more)

### Community 84 - "CategoryDonutChart"
Cohesion: 0.14
Nodes (17): Charts, CategoryDonutChart, .body, .centerContent, .donutChart, .formattedTotal, .legendGrid, .totalDuration (+9 more)

### Community 85 - "CodingKeys"
Cohesion: 0.29
Nodes (7): CodingKeys, endTime, id, startTime, summary, title, videoSummaryURL

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
Cohesion: 0.07
Nodes (36): AppSitesResponse, Codable, CodingKey, ChatCLICardsEnvelope, ChatCLIObservationsEnvelope, Item, .normalizedEnd, .normalizedStart (+28 more)

### Community 90 - "SettingsView"
Cohesion: 0.12
Nodes (17): SettingsTab, data, .id, obsidian, other, providers, storage, .subtitle (+9 more)

### Community 91 - "AnalyticsService"
Cohesion: 0.13
Nodes (7): AnalyticsService, .isOptedIn, Any, Bool, TimeInterval, Void, .analyticsEnabled

### Community 92 - "ProviderPromptPreferencesTests"
Cohesion: 0.20
Nodes (4): IgnoringUserDefaults, ProviderPromptPreferencesTests, Any, Set

### Community 93 - "LLMProcessingStep"
Cohesion: 0.19
Nodes (9): LLMProcessingStep, generatingCards, transcribing, LLMServicing, ProcessedBatchResult, Any, Bool, Int64 (+1 more)

### Community 94 - "SidebarIcon"
Cohesion: 0.06
Nodes (36): GlossBand, .body, LogoBadgeView, .body, CGFloat, Double, Void, .leftColumn (+28 more)

### Community 95 - "RetryCoordinator"
Cohesion: 0.21
Nodes (7): RetryCoordinator, .dots, Bool, Int, Int64, Timer, Void

### Community 97 - "AppDelegate"
Cohesion: 0.10
Nodes (12): AppDelegate, AnyCancellable, Bool, Notification, NSObjectProtocol, Timer, URL, FileManager (+4 more)

### Community 98 - "InactivityMonitor"
Cohesion: 0.19
Nodes (7): InactivityMonitor, .thresholdSeconds, Any, Bool, NSObjectProtocol, TimeInterval, Timer

### Community 99 - "NotificationService"
Cohesion: 0.19
Nodes (7): NotificationService, Bool, Int, UNAuthorizationStatus, UNNotificationSetting, UNNotificationSettings, UNUserNotificationCenterDelegate

### Community 100 - "Date"
Cohesion: 0.15
Nodes (16): DailyStandupEntry, Date, fetchRecentDailyStandups(), fetchTimelineCardsByTimeRange(), Design, FocusBlock, .duration, LongestFocusCard (+8 more)

### Community 101 - "VideoLaunchView"
Cohesion: 0.20
Nodes (10): Any, AVPlayer, NSObjectProtocol, Timer, Void, VideoLaunchView, .body, VideoLaunchView_Previews (+2 more)

### Community 102 - "TimelapseStorageManager"
Cohesion: 0.24
Nodes (5): Int64, URL, Void, TimelapseStorageManager, .rootURL

### Community 103 - ".jpegData"
Cohesion: 0.22
Nodes (8): Config, .screenshotInterval, ScreenshotConfig, .interval, CGFloat, CGImage, Data, TimeInterval

### Community 104 - "Error"
Cohesion: 0.12
Nodes (16): ScreenRecorderError, imageConversionFailed, noDisplay, screenshotFailed, MockRecognizerError, recognitionFailed, StartupError, unavailable (+8 more)

### Community 105 - "Distraction"
Cohesion: 0.18
Nodes (16): buildOnboardingSummary(), createOnboardingCard(), Distraction, getBatchStartTimestamp(), hasIntentionsForDay(), hasMinimumTimelineActivity(), IdleCardMetadata, replaceTimelineCardsInRange() (+8 more)

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
Cohesion: 0.11
Nodes (21): CategoryPickerOverlay, .backgroundView, .body, .orderedCategories, CategoryPickerPill, .background, .body, .borderColor (+13 more)

### Community 110 - "TestConnectionView"
Cohesion: 0.11
Nodes (16): KeychainManager, Bool, Bool, Color, Void, TestConnectionView, .body, .buttonBackground (+8 more)

### Community 111 - "AppDeepLinkRouter"
Cohesion: 0.22
Nodes (8): AnyObject, Action, startRecording, stopRecording, AppDeepLinkRouter, AppDeepLinkRouterDelegate, Bool, URL

### Community 112 - "StepContentType"
Cohesion: 0.10
Nodes (24): .currentStep, SetupStep, StepContentType, apiKeyInput, apiKeyInstructions, cliDetection, information, .informationTitle (+16 more)

### Community 113 - "ObsidianSettingsStore"
Cohesion: 0.23
Nodes (4): ObsidianSettingsStore, .settings, UserDefaults, URL

### Community 114 - "DayflowPillButton"
Cohesion: 0.24
Nodes (11): DayflowCircleButton, .body, DayflowPillButton, .body, CGFloat, CGSize, Color, Content (+3 more)

### Community 115 - "OtherSettingsViewModel"
Cohesion: 0.16
Nodes (9): OtherSettingsViewModel, .showDockIcon, .showTimelineAppIcons, Bool, Int, SettingsOtherTabView, .body, Bool (+1 more)

### Community 116 - "ObservingView"
Cohesion: 0.23
Nodes (8): ObservingView, Any, CGSize, Context, NSView, NSWindow, Void, WindowSizeReader

### Community 117 - "PlayerLayerView"
Cohesion: 0.17
Nodes (11): AVLayerVideoGravity, AVPlayerLayer, CALayer, PlayerLayerView, .player, .playerLayer, AVPlayer, Context (+3 more)

### Community 118 - "JournalFlowState"
Cohesion: 0.20
Nodes (10): .isEditableState, JournalFlowState, boardComplete, intentionsEdit, intro, .label, reflectionEdit, reflectionPrompt (+2 more)

### Community 119 - "NotificationPreferences"
Cohesion: 0.16
Nodes (10): NotificationPreferences, .intentionHour, .intentionMinute, .isEnabled, .reflectionHour, .reflectionMinute, .weekdays, Bool (+2 more)

### Community 120 - "VideoThumbnailView"
Cohesion: 0.21
Nodes (11): HeroGeometryModifier, Bool, CGSize, Content, GeometryProxy, Int, Namespace, NSImage (+3 more)

### Community 121 - "Database"
Cohesion: 0.11
Nodes (26): OpaquePointer, SQLite3, Database, DatabaseError, cannotOpen, notFound, queryFailed, SQLRow (+18 more)

### Community 122 - "README.md"
Cohesion: 0.13
Nodes (14): Automatic Timeline, Build From Source, Chat With Your Work Journal, Contributing, Daily Standup, Download, Homebrew, Install (+6 more)

### Community 123 - "ScrollObserverNSView"
Cohesion: 0.26
Nodes (5): ScrollObserverNSView, Context, NSObjectProtocol, NSView, NSScrollView

### Community 124 - "ToolCallBubble"
Cohesion: 0.16
Nodes (13): ShimmerOverlay, .body, CGFloat, Color, Double, ToolCallBubble, .backgroundView, .body (+5 more)

### Community 125 - "NSViewRepresentable"
Cohesion: 0.26
Nodes (9): ScrollObserverView, ScrollTrackingModifier, CGFloat, Content, DispatchWorkItem, View, Void, View (+1 more)

### Community 126 - "OnboardingLLMSelectionView"
Cohesion: 0.20
Nodes (10): OnboardingLLMSelectionView, .body, OnboardingLLMSelectionView_Previews, .previews, .providerCards, Bool, Double, Never (+2 more)

### Community 127 - "AppKitComposerTextField"
Cohesion: 0.17
Nodes (10): AppKitComposerTextField, Coordinator, Animation, Coordinator, Int, Notification, NSTextView, NSControl (+2 more)

### Community 128 - "TabFilterBar"
Cohesion: 0.20
Nodes (11): .timelineContent, CategoryChip, .body, ChipRowWidthPreferenceKey, Bool, CGFloat, Void, TabFilterBar (+3 more)

### Community 129 - "GeminiModel"
Cohesion: 0.17
Nodes (11): GeminiModel, .displayName, flash25, flash3Preview, flashLite31Preview, .shortLabel, GeminiAPIHelperTests, RequestRecorder (+3 more)

### Community 130 - "ChatCLIRunner.swift"
Cohesion: 0.18
Nodes (7): Darwin, ChatCLIConfigManager, CodexItem, CodexJSONLEvent, Int, TokenUsage, .zero

### Community 131 - "ObservableObject"
Cohesion: 0.20
Nodes (7): AppState, .isRecording, AppStateManaging, Bool, NotificationBadgeManager, Bool, ObservableObject

### Community 132 - "GeminiPromptOverrides"
Cohesion: 0.10
Nodes (12): ChatCLIPromptDefaults, ChatCLIPromptOverrides, .isEmpty, ChatCLIPromptPreferences, Bool, GeminiPromptDefaults, GeminiPromptOverrides, .isEmpty (+4 more)

### Community 133 - "ActiveDisplayTracker"
Cohesion: 0.24
Nodes (7): ActiveDisplayTracker, Any, CGDirectDisplayID, CGFloat, DispatchSourceTimer, Double, TimeInterval

### Community 135 - "NSObject"
Cohesion: 0.14
Nodes (9): StatusBarController, Any, AnyCancellable, Bool, UpdaterManager, NSObject, OSLog, ServiceManagement (+1 more)

### Community 136 - "AutoDailyReportSettingsStore"
Cohesion: 0.27
Nodes (7): AutoDailyReportSettings, .scheduledDate, AutoDailyReportSettingsStore, .settings, Bool, Int, UserDefaults

### Community 137 - "HoverScaleModifier"
Cohesion: 0.31
Nodes (7): HoverScaleModifier, Animation, Bool, CGFloat, Content, View, View

### Community 138 - "BadgeView"
Cohesion: 0.17
Nodes (13): BadgeShadowModifier, BadgeView, .badgeOverlay, .body, .gradientColors, .kerningValue, .shadowColor, .strokeColor (+5 more)

### Community 139 - "HowItWorksView"
Cohesion: 0.33
Nodes (5): HowItWorksView, .body, CGFloat, Double, Void

### Community 140 - ".write"
Cohesion: 0.21
Nodes (6): Calendar, ObsidianVaultExportDestination, FileManager, URL, ObsidianVaultExportDestinationTests, URL

### Community 141 - "TimelineReviewOverlay.swift"
Cohesion: 0.15
Nodes (17): NeutralFaceIcon, .body, SummaryBarRow, .body, SummaryLabelRow, .body, TimeInterval, TimelineReviewOverlayBadge (+9 more)

### Community 142 - "ActivityType"
Cohesion: 0.13
Nodes (14): AVKit, ActivityType, brainstorming, breaks, browsing, coding, .color, email (+6 more)

### Community 143 - "TimelineFailureToastPayload"
Cohesion: 0.22
Nodes (9): AnyHashable, Any, Bool, Int, Int64, TimelineFailureToastCenter, TimelineFailureToastPayload, .analyticsProps (+1 more)

### Community 144 - "MessageBubble"
Cohesion: 0.20
Nodes (10): .helperContent, ChatContentParser, MessageBubble, .assistantBubble, .body, .userBubble, URL, AttributedString (+2 more)

### Community 146 - "CategoryPill"
Cohesion: 0.15
Nodes (14): CategoryPickerView, .body, CategoryPill, .categoryColor, .pillBackground, .pillBorder, Bool, Color (+6 more)

### Community 147 - "DistractionSummaryCard"
Cohesion: 0.20
Nodes (9): Design, DistractionSummaryCard, .body, .donut, .patternBlock, .statsBlock, CGFloat, Color (+1 more)

### Community 148 - "CGRect"
Cohesion: 0.27
Nodes (7): TimelineCardsLayerFramePreferenceKey, TimelineTimeLabelFramesPreferenceKey, CGRect, .curveRect, WeeklyHoursFramePreferenceKey, ThumbnailFrameKey, PreferenceKey

### Community 149 - "FeatureRowView"
Cohesion: 0.25
Nodes (6): CardShadowModifier, FeatureRowView, .body, .featuresScroll, Bool, Content

### Community 150 - "DatabaseContentionTracker"
Cohesion: 0.32
Nodes (8): CFAbsoluteTime, ActiveDatabaseOperation, DatabaseContentionTracker, DatabaseOperationKind, fetchTotalMinutesTrackedForWeek(), RecentDatabaseOperation, Double, QualityOfService

### Community 151 - "Dayflow Analytics Event Dictionary (Telemetry Disabled)"
Cohesion: 0.18
Nodes (10): AI / LLM / Analysis, Conventions, Dashboard Chat, Dayflow Analytics Event Dictionary (Telemetry Disabled), Lifecycle, Navigation & Timeline, Onboarding, Recording (+2 more)

### Community 153 - "Screenshot"
Cohesion: 0.25
Nodes (10): RecordingChunk, .duration, Screenshot, .capturedDate, .fileURL, Bool, Int, Int64 (+2 more)

### Community 154 - "CardsToReviewBadge"
Cohesion: 0.29
Nodes (9): CardsToReviewBadge, .stackedCardsIcon, CardsToReviewBadgePreview, .body, CardsToReviewButton, .body, Int, Void (+1 more)

### Community 156 - "APIKeyInputView"
Cohesion: 0.20
Nodes (9): APIKeyInputView, .body, .borderColor, Bool, Color, ValidationState, invalid, none (+1 more)

### Community 157 - ".blankImageDataURL"
Cohesion: 0.38
Nodes (5): LocalLLMTestConstants, LocalLLMTestImageFactory, Data, Int, TimeInterval

### Community 158 - "UnitPoint"
Cohesion: 0.21
Nodes (10): .body, .badgeBackground, .backgroundView, AnyTransition, .bookFlipNext, .bookFlipPrev, BookFlipModifier, .editCard (+2 more)

### Community 159 - "ScreenshotSlideshowModal"
Cohesion: 0.25
Nodes (3): ScreenshotSlideshowModal, .body, Any

### Community 160 - "FlowLayout"
Cohesion: 0.25
Nodes (8): .followUpSuggestions, FlowLayout, CGFloat, CGSize, ProposedViewSize, Subviews, ThinkingIndicator, .body

### Community 161 - "TimelineFeedbackModal"
Cohesion: 0.20
Nodes (10): Bool, Void, TimelineFeedbackModal, .body, .categoryTipsIllustration, .formContent, .thanksContent, TimelineFeedbackMode (+2 more)

### Community 162 - "sendOrFail"
Cohesion: 0.45
Nodes (10): flagValue(), collectFlagValues(), confirmDestructive(), reportWrite(), requireEditsEnabled(), runCategoriesWrite(), runGoalSet(), runTimelineWrite() (+2 more)

### Community 163 - "OllamaPromptOverrides"
Cohesion: 0.25
Nodes (6): OllamaPromptDefaults, OllamaPromptOverrides, .isEmpty, OllamaPromptPreferences, OllamaPromptSections, Bool

### Community 164 - "TimelineCard"
Cohesion: 0.35
Nodes (3): TimelineCard, TimelineClipboardFormatter, .distractionPattern

### Community 165 - "ComposerTextFieldCell"
Cohesion: 0.33
Nodes (7): ComposerTextFieldCell, Any, NSEvent, NSRect, NSView, NSText, NSTextFieldCell

### Community 166 - "ScreenRecordingPermissionView"
Cohesion: 0.22
Nodes (7): PermissionState, granted, needsAction, notRequested, ScreenRecordingPermissionView, .body, Void

### Community 167 - "CanvasActivityCard"
Cohesion: 0.10
Nodes (21): CanvasActivityCard, .backupIndicator, .body, .isCompactCard, .isFailedCard, .selectionStroke, CanvasActivityCardStyle, CanvasCardButtonStyle (+13 more)

### Community 168 - "DailyModeToggle"
Cohesion: 0.22
Nodes (9): ActiveMode, details, highlights, DailyModeToggle, .body, .borderColor, .borderWidth, .cornerRadius (+1 more)

### Community 169 - "Field"
Cohesion: 0.18
Nodes (11): Field, description, name, Field, intentionHour, intentionMinute, intentionPeriod, reflectionHour (+3 more)

### Community 170 - ".usageRow"
Cohesion: 0.25
Nodes (6): SettingsStorageTabView, .body, Color, Int, Int64, Void

### Community 171 - "Stage"
Cohesion: 0.19
Nodes (9): Stage, answering, error, runningTools, thinking, TimelineCopyState, copied, copying (+1 more)

### Community 172 - "OpenAICompatibleConfigurationTests"
Cohesion: 0.22
Nodes (4): IgnoringUserDefaults, OpenAICompatibleConfigurationTests, Any, Set

### Community 173 - ".userNotificationCenter"
Cohesion: 0.22
Nodes (5): Void, UNNotification, UNNotificationPresentationOptions, UNNotificationResponse, UNUserNotificationCenter

### Community 174 - ".fetchThumbnail"
Cohesion: 0.33
Nodes (6): ScreenshotThumbnailCache, CGSize, NSImage, OperationQueue, URL, Void

### Community 175 - ".fetchThumbnail"
Cohesion: 0.33
Nodes (5): CGSize, NSImage, OperationQueue, Void, ThumbnailCache

### Community 176 - "MainWindowManager"
Cohesion: 0.31
Nodes (5): MainWindowManager, Notification, NSWindow, View, NSWindowDelegate

### Community 177 - "BadgeType"
Cohesion: 0.25
Nodes (8): BadgeType, blue, green, orange, ProviderCardButtonMode, onboarding, settings, Void

### Community 178 - "ProviderCardComponents.swift"
Cohesion: 0.22
Nodes (7): Color, .cardBackground, .cardOverlay, SelectedCardBackground, .body, SelectedCardOverlay, .body

### Community 179 - "ReminderField"
Cohesion: 0.36
Nodes (7): HoverInteractionModifier, ReminderField, .body, Alignment, Bool, CGFloat, Content

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
Cohesion: 0.31
Nodes (5): Double, Timer, VideoPlayerModal, .body, .scrubberURL

### Community 184 - "SplashView"
Cohesion: 0.32
Nodes (6): SplashView, .body, SplashWindow, Double, Void, NSWindow

### Community 185 - ".activity"
Cohesion: 0.46
Nodes (3): Int, Int64, TimelineActivityLoaderTests

### Community 186 - "PreviewProvider"
Cohesion: 0.12
Nodes (16): DayflowButton, .body, DayflowButton_Previews, .previews, Bool, CGFloat, Void, HowItWorksCard (+8 more)

### Community 187 - "ProviderIconView"
Cohesion: 0.33
Nodes (6): .iconSection, ProviderIconView, .body, .containerWidth, .iconContent, CGFloat

### Community 188 - "LaunchAtLoginManager"
Cohesion: 0.31
Nodes (3): LaunchAtLoginManager, Bool, .contentWithLifecycle

### Community 189 - "IntentionsEditForm"
Cohesion: 0.36
Nodes (8): IntentionsEditForm, .sectionGoals, .sectionIntentions, .sectionNotes, JournalTextEditor, .body, CGFloat, Int

### Community 190 - "CategorySelectionEditor"
Cohesion: 0.25
Nodes (7): CategorySelectionEditor, .backgroundView, .helperRow, .focusSection, Void, TotalFocusCard, .body

### Community 192 - "NSColor"
Cohesion: 0.43
Nodes (3): Color, NSColor, CGFloat

### Community 193 - ".chatCompletionsURL"
Cohesion: 0.40
Nodes (3): LocalEndpointUtilities, URL, .localCurlCommand

### Community 194 - ".relocateDirectoryContents"
Cohesion: 0.40
Nodes (3): StoragePathMigrator, FileManager, URL

### Community 195 - "CompletionView"
Cohesion: 0.47
Nodes (4): CompletionView, .body, .canProceed, Bool

### Community 196 - "SetupContinueButton"
Cohesion: 0.47
Nodes (4): SetupContinueButton, .body, Bool, Void

### Community 197 - "Status"
Cohesion: 0.33
Nodes (6): Status, done, failed, queued, running, stopped

### Community 198 - "VideoExpansionState"
Cohesion: 0.20
Nodes (10): AnimationPhase, collapsed, collapsing, expanded, flying, lifting, Bool, CGSize (+2 more)

### Community 199 - "Period"
Cohesion: 0.29
Nodes (6): Period, am, .display, .id, pm, Int

### Community 200 - "release.sh"
Cohesion: 0.60
Nodes (4): err(), require(), set_plist(), release.sh script

### Community 202 - ".screenshots"
Cohesion: 0.43
Nodes (3): ActivityCardTimelapseGenerator, Int64, URL

### Community 203 - "StoragePreferences"
Cohesion: 0.40
Nodes (4): StoragePreferences, .recordingsLimitBytes, .timelapsesLimitBytes, Int64

### Community 204 - "DashboardChatTurnRole"
Cohesion: 0.40
Nodes (5): DashboardChatTurnRole, assistant, .geminiRole, .promptLabel, user

### Community 205 - ".migrateIfNeeded"
Cohesion: 0.60
Nodes (3): OnboardingStepMigration, UserDefaults, Int

### Community 206 - "JournalReminderPillButtonStyle"
Cohesion: 0.50
Nodes (3): JournalReminderPillButtonStyle, Color, Configuration

### Community 207 - "DashboardToolArgError"
Cohesion: 0.20
Nodes (10): DashboardToolArgError, .errorDescription, invalidCombination, invalidDate, invalidRange, ActivityCardTimelapseError, .errorDescription, noScreenshots (+2 more)

### Community 209 - "GatePhase"
Cohesion: 0.40
Nodes (5): GatePhase, granted, hidden, locked, requesting

### Community 210 - "RetryStrategy"
Cohesion: 0.29
Nodes (6): RetryStrategy, enhancedPrompt, immediate, longBackoff, noRetry, shortBackoff

### Community 211 - "DailyStandupRegenerateState"
Cohesion: 0.24
Nodes (7): DailyStandupCopyState, copied, idle, DailyStandupRegenerateState, idle, regenerated, regenerating

### Community 212 - "SettingsCard"
Cohesion: 0.50
Nodes (3): SettingsCard, .body, Content

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

### Community 231 - "DatePickerSheet"
Cohesion: 0.67
Nodes (3): DatePickerSheet, .body, Bool

## Knowledge Gaps
- **761 isolated node(s):** `startRecording`, `stopRecording`, `.isRecording`, `.currentAppVersion`, `.hasPendingNotificationNavigation` (+756 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **15 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `TimelineReviewSummaryCard`, `GeminiDirectProvider`, `DailyRecapScheduler`, `PauseManager`, `OllamaProvider`, `DaySummaryView`, `ComposerTextField`, `ChatCLITool`, `ChatCLIProvider`, `ProvidersSettingsViewModel`, `LLMProviderRoutingTests`, `ChatView`, `SwiftUI`, `ChatService`, `ButtonStyle`, `LLMCallContext`, `Observation`, `Int`, `DaySummaryView.swift`, `AnalysisManager`, `VideoProcessingError`, `Sendable`, `DayflowSurfaceButton`, `ChatView.swift`, `DailyView`, `StorageManager.swift`, `View`, `TimelineReviewOverlay`, `TimelineCategory`, `StorageSettingsViewModel`, `SettingsDataTabView`, `ProviderSetupState`, `.generateActivityCards`, `ColorOrganizerRoot`, `DailyBulletCard`, `Support.swift`, `MainView`, `ClaudeActivityCardBoundaryTests`, `Identifiable`, `Bool`, `TimelineReviewCard`, `Breadcrumb`, `JournalDayManager`, `ChatStreamEvent`, `ClaudeTranscriptionInputBuilderTests`, `CanvasTimelineDataView`, `CLITool`, `TimelineSpinnerModel`, `ChatCLIProcessRunner`, `ReferralOption`, `CaseIterable`, `CodexClaudeProviderTests`, `json`, `JournalPillButtonStyle`, `TimelineReviewPlayerModel`, `AppRootView`, `ChatChartSpec`, `Bool`, `ColorPickerView`, `JournalDayView.swift`, `WhatsNewView`, `MCPServer.swift`, `XCTestCase`, `TimelineActivity`, `ScreenshotSlideshowPlaybackModel`, `SettingsProvidersTabView`, `TimelineRateSummaryView`, `.export`, `ObsidianExportSettings`, `SentryHelper.swift`, `OnboardingFlow`, `JournalRemindersView`, `ScrubberView`, `TimelineReviewRating`, `ChatToolExecutor`, `ScreenRecorder`, `FlexibleProviderCard`, `ScreenshotScrubberView`, `LLMService`, `CategoryDonutChart`, `CodingKeys`, `.run`, `Render.swift`, `Codable`, `SettingsView`, `AnalyticsService`, `ProviderPromptPreferencesTests`, `LLMProcessingStep`, `SidebarIcon`, `RetryCoordinator`, `AppDelegate`, `NotificationService`, `Date`, `Error`, `Distraction`, `MacTextView`, `Weekday`, `FaviconService`, `CategoryPickerPill`, `TestConnectionView`, `AppDeepLinkRouter`, `StepContentType`, `ObsidianSettingsStore`, `DayflowPillButton`, `OtherSettingsViewModel`, `JournalFlowState`, `VideoThumbnailView`, `Database`, `NSViewRepresentable`, `OnboardingLLMSelectionView`, `AppKitComposerTextField`, `GeminiModel`, `ChatCLIRunner.swift`, `GeminiPromptOverrides`, `DailyRecapGeneratorTests`, `NSObject`, `BadgeView`, `HowItWorksView`, `.write`, `TimelineReviewOverlay.swift`, `ActivityType`, `TimelineFailureToastPayload`, `MessageBubble`, `AutoDailyReportService`, `CategoryPill`, `DistractionSummaryCard`, `FeatureRowView`, `DatabaseContentionTracker`, `.capture`, `Screenshot`, `APIKeyInputView`, `.blankImageDataURL`, `ScreenshotSlideshowModal`, `TimelineFeedbackModal`, `sendOrFail`, `OllamaPromptOverrides`, `TimelineCard`, `CanvasActivityCard`, `DailyModeToggle`, `.usageRow`, `OpenAICompatibleConfigurationTests`, `.fetchThumbnail`, `BadgeType`, `ProviderCardComponents.swift`, `WeeklyDashboardBuilderTests`, `EntryType`, `.body`, `.activity`, `PreviewProvider`, `ProviderIconView`, `IntentionsEditForm`, `CategorySelectionEditor`, `NSColor`, `.chatCompletionsURL`, `CompletionView`, `SetupContinueButton`, `VideoExpansionState`, `Period`, `DashboardChatTurnRole`, `DashboardToolArgError`, `.validateTimeCoverage`, `SettingsCard`, `Category`, `LLMOutputLanguagePreferences`, `ReviewRatingKey`, `TerminalCommandView`?**
  _High betweenness centrality (0.699) - this node is a cross-community bridge._
- **Why does `MainView` connect `MainView` to `TabFilterBar`, `ObservableObject`, `SwiftUI`, `TimelineFailureToastPayload`, `CGRect`, `.capture`, `DailyView`, `CardsToReviewBadge`, `View`, `TimelineCategory`, `ColorOrganizerRoot`, `TimelineFeedbackModal`, `Support.swift`, `TimelineCard`, `Stage`, `AppRootView`, `TimelineActivity`, `String`, `TimelineRateSummaryView`, `VideoExpansionState`, `SidebarIcon`, `RetryCoordinator`?**
  _High betweenness centrality (0.033) - this node is a cross-community bridge._
- **Why does `DaySummaryView` connect `DaySummaryView` to `TimelineReviewSummaryCard`, `TimelineCard`, `Date`, `String`, `MainView`, `GatePhase`, `DaySummaryView.swift`, `AnalysisManager`, `CategoryDonutChart`, `.capture`, `View`, `TimelineCategory`, `CategorySelectionEditor`, `ReviewRatingKey`?**
  _High betweenness centrality (0.026) - this node is a cross-community bridge._
- **Are the 7 inferred relationships involving `ProvidersSettingsViewModel` (e.g. with `SettingsView` and `.testEditingClaudePromptDoesNotMutateCodexPrompt()`) actually correct?**
  _`ProvidersSettingsViewModel` has 7 INFERRED edges - model-reasoned connections that need verification._
- **What connects `startRecording`, `stopRecording`, `.isRecording` to the rest of the system?**
  _761 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `TimelineReviewSummaryCard` be split into smaller, more focused modules?**
  _Cohesion score 0.0505175983436853 - nodes in this community are weakly interconnected._
- **Should `GeminiDirectProvider` be split into smaller, more focused modules?**
  _Cohesion score 0.11215686274509803 - nodes in this community are weakly interconnected._