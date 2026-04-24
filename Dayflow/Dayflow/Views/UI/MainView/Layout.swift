import SwiftUI
import AppKit

private struct TimelineHeaderTrailingWidthPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}

private struct TimelineCalendarButtonFramePreferenceKey: PreferenceKey {
  static var defaultValue: CGRect = .zero

  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}

extension View {
  fileprivate func trackTimelineHeaderTrailingWidth() -> some View {
    background(
      GeometryReader { proxy in
        Color.clear.preference(
          key: TimelineHeaderTrailingWidthPreferenceKey.self,
          value: proxy.size.width
        )
      }
    )
  }

  fileprivate func trackTimelineCalendarButtonFrame() -> some View {
    background(
      GeometryReader { proxy in
        Color.clear.preference(
          key: TimelineCalendarButtonFramePreferenceKey.self,
          value: proxy.frame(in: .named("TimelinePanel"))
        )
      }
    )
  }
}

// Priority-based visibility gates for the timeline header's leading controls.
// Computed once per render from available width + trailing reservation; every
// conditional in `timelineLeadingControls` reads this, so the full header
// renders as a single variant (no `ViewThatFits` shuffle).
private struct TimelineHeaderVisibility {
  var showTodayButton: Bool
  var showDayWeekToggle: Bool
  var showInlineDate: Bool
}

extension MainView {
    var mainLayout: some View {
        contentStack
            .padding([.top, .trailing, .bottom], 15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
            .ignoresSafeArea()
            // Hero animation overlay for video expansion (Emil Kowalski: shared element transitions)
            .overlay { overlayContent }
            .overlay(alignment: .bottomTrailing) {
                if let payload = timelineFailureToastPayload {
                    TimelineFailureToastView(
                        message: payload.message,
                        onOpenSettings: { handleTimelineFailureToastOpenSettings(payload) },
                        onDismiss: { handleTimelineFailureToastDismiss(payload) }
                    )
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerSheet(
                    selectedDate: Binding(
                        get: { selectedDate },
                        set: {
                            lastDateNavMethod = "picker"
                            setSelectedDate($0)
                        }
                    ),
                    isPresented: $showDatePicker
                )
            }
            .onAppear {
                // screen viewed and initial timeline view
                AnalyticsService.shared.screen("timeline")
                AnalyticsService.shared.withSampling(probability: 0.01) {
                    AnalyticsService.shared.capture("timeline_viewed", ["date_bucket": dayString(selectedDate)])
                }
                // Orchestrated entrance animations following Emil Kowalski principles
                // Fast, under 300ms, natural spring motion

                // Logo appears first with scale and fade
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                    logoScale = 1.0
                    logoOpacity = 1
                }

                // Timeline text slides in from left
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0).delay(0.1)) {
                    timelineOffset = 0
                    timelineOpacity = 1
                }

                // Sidebar slides up
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0).delay(0.15)) {
                    sidebarOffset = 0
                    sidebarOpacity = 1
                }

                // Main content fades in last
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0).delay(0.2)) {
                    contentOpacity = 1
                }

                // Perform initial scroll to current time on cold start
                if !didInitialScroll {
                    performInitialScrollIfNeeded()
                }

                // Start minute-level tick to detect timeline-day rollover (4am boundary)
                startDayChangeTimer()

                // Load weekly activity hours
                loadWeeklyTrackedMinutes()
                updateCardsToReviewCount()
            }
            // Trigger reset when idle fired and timeline is visible
            .onChange(of: inactivity.pendingReset) { _, fired in
                if fired, selectedIcon != .settings {
                    performIdleResetAndScroll()
                    InactivityMonitor.shared.markHandledIfPending()
                }
            }
            .onChange(of: selectedIcon) { _, newIcon in
                // Clear journal notification badge when navigating to journal
                if newIcon == .journal {
                    NotificationBadgeManager.shared.clearBadge()
                }

                // tab selected + screen viewed
                let tabName: String
                switch newIcon {
                case .timeline: tabName = "timeline"
                case .chat: tabName = "chat"
                case .daily: tabName = "daily"
                case .journal: tabName = "journal"
                case .bug: tabName = "bug_report"
                case .settings: tabName = "settings"
                }


                AnalyticsService.shared.capture("tab_selected", ["tab": tabName])
                AnalyticsService.shared.screen(tabName)
                if newIcon == .timeline {
                    AnalyticsService.shared.withSampling(probability: 0.01) {
                        AnalyticsService.shared.capture("timeline_viewed", ["date_bucket": dayString(selectedDate)])
                    }
                    updateCardsToReviewCount()
                } else {
                    showTimelineReview = false
                }
            }
            // Handle navigation from journal reminder notification tap
            .onReceive(NotificationCenter.default.publisher(for: .navigateToJournal)) { _ in
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                    selectedIcon = .journal
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .showTimelineFailureToast)) { notification in
                guard let userInfo = notification.userInfo,
                      let payload = TimelineFailureToastPayload(userInfo: userInfo) else {
                    return
                }
                withAnimation(.spring(response: 0.28, dampingFraction: 0.9)) {
                    timelineFailureToastPayload = payload
                }
            }
            .onChange(of: selectedDate) { _, newDate in
                // If changed via picker, emit navigation now
                if let method = lastDateNavMethod, method == "picker" {
                    AnalyticsService.shared.capture("date_navigation", [
                        "method": method,
                        "from_day": dayString(previousDate),
                        "to_day": dayString(newDate)
                    ])
                }
                previousDate = newDate
                AnalyticsService.shared.withSampling(probability: 0.01) {
                    AnalyticsService.shared.capture("timeline_viewed", ["date_bucket": dayString(newDate)])
                }
                updateCardsToReviewCount()
            }
            .onChange(of: refreshActivitiesTrigger) {
                updateCardsToReviewCount()
            }
            .onChange(of: selectedActivity?.id) {
                dismissFeedbackModal(animated: false)
                guard let a = selectedActivity else { return }
                let dur = a.endTime.timeIntervalSince(a.startTime)
                AnalyticsService.shared.capture("activity_card_opened", [
                    "activity_type": a.category,
                    "duration_bucket": AnalyticsService.shared.secondsBucket(dur),
                    "has_video": a.videoSummaryURL != nil
                ])
            }
            // If user returns from Settings and a reset was pending, perform it once
            .onChange(of: selectedIcon) { _, newIcon in
                if newIcon != .settings, inactivity.pendingReset {
                    performIdleResetAndScroll()
                    InactivityMonitor.shared.markHandledIfPending()
                }
            }
            .onDisappear {
                // Safety: stop timer if view disappears
                stopDayChangeTimer()
                copyTimelineTask?.cancel()
            }
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
                // Check if day changed while app was backgrounded
                handleMinuteTickForDayChange()
                // Ensure timer is running
                if dayChangeTimer == nil {
                    startDayChangeTimer()
                }
                // Refresh weekly hours in case activities were added
                loadWeeklyTrackedMinutes()
            }
            .overlay { categoryEditorOverlay }
            .environmentObject(retryCoordinator)
    }

    private func handleTimelineFailureToastOpenSettings(_ payload: TimelineFailureToastPayload) {
        AnalyticsService.shared.capture("llm_timeline_failure_toast_clicked_settings", payload.analyticsProps)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
            selectedIcon = .settings
            timelineFailureToastPayload = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NotificationCenter.default.post(name: .openProvidersSettings, object: nil)
        }
    }

    private func handleTimelineFailureToastDismiss(_ payload: TimelineFailureToastPayload) {
        AnalyticsService.shared.capture("llm_timeline_failure_toast_dismissed", payload.analyticsProps)
        withAnimation(.spring(response: 0.25, dampingFraction: 0.92)) {
            timelineFailureToastPayload = nil
        }
    }

    private var contentStack: some View {
        // Two-column layout: left logo + sidebar; right white panel with header, filters, timeline
        HStack(alignment: .top, spacing: 0) {
            leftColumn
            rightPanel
        }
        .padding(0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var leftColumn: some View {
        // Left column: Logo on top, sidebar centered
        VStack(spacing: 0) {
            // Logo area (keeps same animation)
            LogoBadgeView(imageName: "DayflowLogoMainApp", size: 36)
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

            Spacer(minLength: 0)

            // Sidebar in fixed-width gutter
            VStack {
                Spacer()
                SidebarView(selectedIcon: $selectedIcon)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(y: sidebarOffset)
                    .opacity(sidebarOpacity)
                Spacer()
            }
            Spacer(minLength: 0)
        }
        .frame(width: 100)
        .fixedSize(horizontal: true, vertical: false)
        .frame(maxHeight: .infinity)
        .layoutPriority(1)
    }

    @ViewBuilder
    private var rightPanel: some View {
        // Right column: Main white panel including header + content
        ZStack {
            contentForSelectedIcon
        }
        .padding(0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(mainPanelBackground)
    }

    @ViewBuilder
    private var contentForSelectedIcon: some View {
        switch selectedIcon {
        case .settings:
            SettingsView()
                .padding(15)
        case .chat:
            ChatPanelView()
        case .daily:
            DailyView(selectedDate: $selectedDate)
        case .journal:
            JournalView(
                selectedDate: $selectedDate,
                showDatePicker: $showDatePicker,
                lastDateNavMethod: $lastDateNavMethod,
                previousDate: $previousDate
            )
                .padding(15)
        case .bug:
            BugReportView()
                .padding(15)
        case .timeline:
            GeometryReader { geo in
                timelinePanel(geo: geo)
            }
        }
    }

    private var mainPanelBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 0)
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.white)
                .blendMode(.destinationOut)
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.white.opacity(0.22))
        }
        .compositingGroup()
    }

    private func timelinePanel(geo: GeometryProxy) -> some View {
        HStack(alignment: .top, spacing: 0) {
            timelineLeftColumn
            Rectangle()
                .fill(Color(hex: "ECECEC"))
                .frame(width: 1)
                .frame(maxHeight: .infinity)
            timelineRightColumn(geo: geo)
        }
        .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
    }

    private var timelineLeftColumn: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 18) {
                timelineHeader
                timelineContent
            }
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.top, 15)
            .padding(.bottom, 15)
            .padding(.leading, 15)
            .padding(.trailing, 5)

            timelineFooter
        }
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .coordinateSpace(name: "TimelinePane")
        .onPreferenceChange(TimelineTimeLabelFramesPreferenceKey.self) { frames in
            timelineTimeLabelFrames = frames
        }
        .onPreferenceChange(WeeklyHoursFramePreferenceKey.self) { frame in
            weeklyHoursFrame = frame
        }
    }

    private var timelineHeader: some View {
        HStack(alignment: .center) {
            HStack(spacing: 16) {
                Text(formatDateForDisplay(selectedDate))
                    .font(.custom("InstrumentSerif-Regular", size: 36))
                    .foregroundColor(Color.black)
                    .frame(width: Self.maxDateTitleWidth, alignment: .leading)

                HStack(spacing: 3) {
                    Button(action: {
                        let from = selectedDate
                        let to = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                        previousDate = selectedDate
                        setSelectedDate(to)
                        lastDateNavMethod = "prev"
                        AnalyticsService.shared.capture("date_navigation", [
                            "method": "prev",
                            "from_day": dayString(from),
                            "to_day": dayString(to)
                        ])
                    }) {
                        Image("CalendarLeftButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        guard canNavigateForward(from: selectedDate) else { return }
                        let from = selectedDate
                        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                        previousDate = selectedDate
                        setSelectedDate(tomorrow)
                        lastDateNavMethod = "next"
                        AnalyticsService.shared.capture("date_navigation", [
                            "method": "next",
                            "from_day": dayString(from),
                            "to_day": dayString(tomorrow)
                        ])
                    }) {
                        Image("CalendarRightButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(!canNavigateForward(from: selectedDate))
                }
            }
            .offset(x: timelineOffset)
            .opacity(timelineOpacity)

            Spacer()

            // Recording toggle (now inline with header)
            HStack(spacing: 4) {
                Text("Record")
                    .font(
                        Font.custom("Nunito", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.62, green: 0.44, blue: 0.36))

                Toggle("Record", isOn: $appState.isRecording)
                    .labelsHidden()
                    .toggleStyle(SunriseGlassPillToggleStyle())
                    .scaleEffect(0.7)
                    .accessibilityLabel(Text("Recording"))
            }
        }
        .padding(.horizontal, 10)
    }

    private var timelineContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            TabFilterBar(
                categories: categoryStore.editableCategories,
                idleCategory: categoryStore.idleCategory,
                onManageCategories: { showCategoryEditor = true }
            )
            .padding(.leading, 10)
            .opacity(contentOpacity)

            CanvasTimelineDataView(
                selectedDate: $selectedDate,
                selectedActivity: $selectedActivity,
                scrollToNowTick: $scrollToNowTick,
                hasAnyActivities: $hasAnyActivities,
                refreshTrigger: $refreshActivitiesTrigger,
                weeklyHoursFrame: weeklyHoursFrame,
                weeklyHoursIntersectsCard: $weeklyHoursIntersectsCard
            )
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
            .environmentObject(categoryStore)
            .opacity(contentOpacity)
        }
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var timelineFooter: some View {
        VStack(spacing: 0) {
            Spacer()

            // Bottom footer bar - all items bottom-aligned
            ZStack(alignment: .bottom) {
                // Left & right items
                HStack(alignment: .bottom) {
                    weeklyHoursText
                        .opacity(contentOpacity * weeklyHoursFadeOpacity)

                    Spacer()

                    copyTimelineButton
                        .opacity(contentOpacity)
                }
                .padding(.horizontal, 24)

                // Centered badge (bottom-aligned with text)
                if cardsToReviewCount > 0 {
                    CardsToReviewButton(count: cardsToReviewCount) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            showTimelineReview = true
                        }
                    }
                    .opacity(contentOpacity)
                }
            }
            .padding(.bottom, 17)
        }
        .allowsHitTesting(true)
    }

    private func timelineRightColumn(geo: GeometryProxy) -> some View {
        // Right column: activity detail card OR day summary — spans full height
        ZStack(alignment: .topLeading) {
            Color.white.opacity(0.7)

            if let activity = selectedActivity {
                // Show activity details when a card is selected
                ZStack(alignment: .bottom) {
                    ActivityCard(
                        activity: activity,
                        maxHeight: geo.size.height,
                        scrollSummary: true,
                        hasAnyActivities: hasAnyActivities,
                        onCategoryChange: { category, activity in
                            handleCategoryChange(to: category, for: activity)
                        },
                        onNavigateToCategoryEditor: {
                            showCategoryEditor = true
                        },
                        onRetryBatchCompleted: { batchId in
                            refreshActivitiesTrigger &+= 1
                            if selectedActivity?.batchId == batchId {
                                selectedActivity = nil
                            }
                        }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .allowsHitTesting(!feedbackModalVisible)
                    .padding(.bottom, rateSummaryFooterHeight)

                    if !feedbackModalVisible {
                        TimelineRateSummaryView(
                            activityID: activity.id,
                            onRate: handleTimelineRating
                        )
                        .frame(maxWidth: .infinity)
                        .allowsHitTesting(!feedbackModalVisible)
                        .transition(
                            .move(edge: .bottom)
                                .combined(with: .opacity)
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                DaySummaryView(
                    selectedDate: selectedDate,
                    categories: categoryStore.categories,
                    storageManager: StorageManager.shared,
                    cardsToReviewCount: cardsToReviewCount,
                    reviewRefreshToken: reviewSummaryRefreshToken,
                    onReviewTap: {
                        guard cardsToReviewCount > 0 else { return }
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            showTimelineReview = true
                        }
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
            if let direction = feedbackDirection, feedbackModalVisible {
                TimelineFeedbackModal(
                    message: $feedbackMessage,
                    shareLogs: $feedbackShareLogs,
                    direction: direction,
                    mode: feedbackMode,
                    onSubmit: handleFeedbackSubmit,
                    onClose: { dismissFeedbackModal() }
                )
                .padding(.leading, 24)
                .padding(.bottom, 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .opacity(contentOpacity)
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: selectedActivity?.id)
        .clipShape(
            UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: 0,
                    bottomLeading: 0, bottomTrailing: 8, topTrailing: 8
                )
            )
        )
        .contentShape(
            UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: 0,
                    bottomLeading: 0, bottomTrailing: 8, topTrailing: 8
                )
            )
        )
        .frame(minWidth: 240, idealWidth: 358, maxWidth: 358, maxHeight: .infinity)
    }

    private var overlayContent: some View {
        ZStack {
            VideoExpansionOverlay(
                expansionState: videoExpansionState,
                namespace: videoHeroNamespace
            )

            if selectedIcon == .timeline, showTimelineReview {
                TimelineReviewOverlay(
                    isPresented: $showTimelineReview,
                    selectedDate: selectedDate
                ) {
                    updateCardsToReviewCount()
                    reviewSummaryRefreshToken &+= 1
                }
                .environmentObject(categoryStore)
                .transition(.opacity)
                .zIndex(2)
            }
        }
    }

    @ViewBuilder
    private var categoryEditorOverlay: some View {
        if showCategoryEditor {
            ColorOrganizerRoot(
                presentationStyle: .sheet,
                onDismiss: { showCategoryEditor = false }, completionButtonTitle: "Save", showsTitles: true
            )
            .environmentObject(categoryStore)
            // Removed .contentShape(Rectangle()) and .onTapGesture to allow keyboard input
        }
    }

    private var weeklyHoursFadeOpacity: Double {
        guard weeklyHoursFrame != .zero, !timelineTimeLabelFrames.isEmpty else { return 1 }
        var maxOverlap: CGFloat = 0
        for frame in timelineTimeLabelFrames {
            let intersection = weeklyHoursFrame.intersection(frame)
            if !intersection.isNull {
                maxOverlap = max(maxOverlap, intersection.height)
            }
        }
        guard maxOverlap > 0 else { return 1 }
        let clamped = min(maxOverlap, weeklyHoursFadeDistance)
        return Double(1 - (clamped / weeklyHoursFadeDistance))
    }

    private var weeklyHoursText: some View {
        let hours = Int(weeklyTrackedMinutes / 60)
        let textColor = Color(red: 0.84, green: 0.65, blue: 0.52)

        return HStack(spacing: 4) {
            Text("\(hours) hours")
                .font(Font.custom("Nunito", size: 10).weight(.bold))
                .foregroundColor(textColor)
            Text("tracked this week")
                .font(Font.custom("Nunito", size: 10).weight(.regular))
                .foregroundColor(textColor)
        }
        .background(
            GeometryReader { proxy in
                Color.clear.preference(
                    key: WeeklyHoursFramePreferenceKey.self,
                    value: proxy.frame(in: .named("TimelinePane"))
                )
            }
        )
    }

    private var copyTimelineButton: some View {
        let background = Color(red: 0.99, green: 0.93, blue: 0.88)
        let stroke = Color(red: 0.97, green: 0.89, blue: 0.81)
        let textColor = Color(red: 0.84, green: 0.65, blue: 0.52)

        let transition = AnyTransition.opacity.combined(with: .scale(scale: 0.5))

        return Button(action: copyTimelineToClipboard) {
            ZStack {
                if copyTimelineState == .copying {
                    ProgressView()
                        .scaleEffect(0.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .transition(transition)
                } else if copyTimelineState == .copied {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .medium))
                        Text("Copied")
                            .font(Font.custom("Nunito", size: 10).weight(.medium))
                    }
                    .transition(transition)
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 10, weight: .medium))
                        Text("Copy timeline")
                            .font(Font.custom("Nunito", size: 10).weight(.medium))
                    }
                    .transition(transition)
                }
            }
            .frame(width: 90, height: 20)
            .foregroundColor(textColor)
            .background(background)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .inset(by: 0.38)
                    .stroke(stroke, lineWidth: 0.75)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(ShrinkButtonStyle())
        .disabled(copyTimelineState == .copying)
        .accessibilityLabel(Text("Copy timeline to clipboard"))
    }
}

private struct ShrinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .opacity(1)
    }
}

private struct TimelineFailureToastView: View {
    let message: String
    let onOpenSettings: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "C04A00"))
                    .padding(.top, 2)

                Text(message)
                    .font(.custom("Nunito", size: 13))
                    .foregroundColor(.black.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)

                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.black.opacity(0.45))
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(.plain)
            }

            DayflowSurfaceButton(
                action: onOpenSettings,
                content: {
                    HStack(spacing: 6) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 12))
                        Text("Open Provider Settings")
                            .font(.custom("Nunito", size: 12))
                            .fontWeight(.semibold)
                    }
                },
                background: Color(red: 0.25, green: 0.17, blue: 0),
                foreground: .white,
                borderColor: .clear,
                cornerRadius: 8,
                horizontalPadding: 14,
                verticalPadding: 8,
                showOverlayStroke: true
            )
        }
        .padding(14)
        .frame(width: 360, alignment: .leading)
        .background(Color(hex: "FFF8F2"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "F3D9C2"), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}

private struct ScreenRecordingPermissionNoticeView: View {
  let onOpenSettings: () -> Void
  let onDismiss: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(alignment: .top, spacing: 10) {
        Image(systemName: "record.circle.fill")
          .font(.system(size: 15))
          .foregroundColor(Color(hex: "C7352D"))
          .padding(.top, 2)

        VStack(alignment: .leading, spacing: 3) {
          Text("Screen recording access needed")
            .font(.custom("Nunito", size: 13))
            .fontWeight(.semibold)
            .foregroundColor(.black.opacity(0.86))

          Text("Dayflow cannot update your timeline until access is restored.")
            .font(.custom("Nunito", size: 12))
            .foregroundColor(.black.opacity(0.62))
            .fixedSize(horizontal: false, vertical: true)
        }

        Button(action: onDismiss) {
          Image(systemName: "xmark")
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.black.opacity(0.45))
            .frame(width: 18, height: 18)
        }
        .buttonStyle(.plain)
        .hoverScaleEffect(scale: 1.02)
        .pointingHandCursorOnHover(reassertOnPressEnd: true)
      }

      DayflowSurfaceButton(
        action: onOpenSettings,
        content: {
          HStack(spacing: 6) {
            Image(systemName: "gearshape")
              .font(.system(size: 12))
            Text("Open System Settings")
              .font(.custom("Nunito", size: 12))
              .fontWeight(.semibold)
          }
        },
        background: Color(red: 0.25, green: 0.17, blue: 0),
        foreground: .white,
        borderColor: .clear,
        cornerRadius: 8,
        horizontalPadding: 14,
        verticalPadding: 8,
        showOverlayStroke: true
      )
    }
    .padding(14)
    .frame(width: 360, alignment: .leading)
    .background(Color(hex: "FFF8F2"))
    .cornerRadius(12)
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color(hex: "F3D9C2"), lineWidth: 1)
    )
    .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)
  }
}

// Compact month calendar popover (Figma 4291:4828).
// Single-variant rendering: every day is a cell in a flat grid, with the
// selected date shown as an 18pt orange circle. No week-pill; week-mode
// indication is conveyed elsewhere in the UI (the Day/Week toggle + the
// header title). Self-contained: tracks its own displayed month, reports
// picks via `onSelect`.
private struct TimelineCalendarPopover: View {
  static let horizontalPadding: CGFloat = 28
  static let topPadding: CGFloat = 20
  static let bottomPadding: CGFloat = 20
  static let contentSpacing: CGFloat = 16
  static let columnWidth: CGFloat = 30
  static let columnSpacing: CGFloat = 12
  static let weekdayHeight: CGFloat = 20
  static let dayCellHeight: CGFloat = 24
  static let rowSpacing: CGFloat = 12
  static let selectedCircleSize: CGFloat = 24
  static let selectedWeekHighlightHeight: CGFloat = 30
  static let contentWidth: CGFloat = (columnWidth * 7) + (columnSpacing * 6)
  static let preferredWidth: CGFloat = contentWidth + (horizontalPadding * 2)

  @Binding var isPresented: Bool
  let selectedDate: Date
  let canSelectFutureDates: Bool
  let highlightsSelectedWeek: Bool
  let onSelect: (Date) -> Void

  @State private var displayMonth: Date

  // Monday-first ordering matches the timeline's week model, so each row in the
  // popover corresponds to a real Monday-Sunday week.
  private static let mondayCalendar: Calendar = {
    var c = Calendar(identifier: .gregorian)
    c.timeZone = .autoupdatingCurrent
    c.firstWeekday = 2
    return c
  }()

  private static let monthYearFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "MMMM yyyy"
    return f
  }()

  init(
    isPresented: Binding<Bool>,
    selectedDate: Date,
    canSelectFutureDates: Bool,
    highlightsSelectedWeek: Bool,
    onSelect: @escaping (Date) -> Void
  ) {
    self._isPresented = isPresented
    self.selectedDate = selectedDate
    self.canSelectFutureDates = canSelectFutureDates
    self.highlightsSelectedWeek = highlightsSelectedWeek
    self.onSelect = onSelect

    // Seed display month to the month containing the current selection.
    let calendar = Self.mondayCalendar
    let comps = calendar.dateComponents([.year, .month], from: selectedDate)
    let monthStart = calendar.date(from: comps) ?? selectedDate
    self._displayMonth = State(initialValue: monthStart)
  }

  var body: some View {
    let weeks = weeksToDisplay()

    VStack(alignment: .leading, spacing: Self.contentSpacing) {
      monthHeader
      weekdayRow
      dateGrid(weeks: weeks)
    }
    .frame(width: Self.contentWidth, alignment: .leading)
    .padding(.horizontal, Self.horizontalPadding)
    .padding(.top, Self.topPadding)
    .padding(.bottom, Self.bottomPadding)
    .frame(width: Self.preferredWidth, alignment: .topLeading)
    // Figma node 4291:4828: backdrop-blur 10pt + rgba(255,255,255,0.5) tint.
    .background {
      ZStack {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
          .fill(.ultraThinMaterial)
        RoundedRectangle(cornerRadius: 8, style: .continuous)
          .fill(Color.white.opacity(0.5))
      }
    }
    .overlay {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .strokeBorder(Color(hex: "E9DAD1"), lineWidth: 1)
    }
    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    .shadow(color: .black.opacity(0.16), radius: 4, x: 0, y: 1)
    // Force the light variant of `.ultraThinMaterial` regardless of the
    // system appearance. Without this, macOS dark mode causes the material
    // to render as a dark blur — the popover looks like a gray slab even
    // though the rest of the app is light. Dayflow's palette is tuned for
    // light mode; the Figma explicitly specifies a light translucent card.
    .environment(\.colorScheme, .light)
  }

  private var monthHeader: some View {
    HStack(spacing: 0) {
      Text(Self.monthYearFormatter.string(from: displayMonth))
        .font(.custom("Nunito", size: 14))
        .foregroundColor(.black)
        .lineLimit(1)

      Spacer(minLength: 0)

      HStack(spacing: 2) {
        monthNavButton(systemName: "chevron.left") { shiftMonth(by: -1) }
        monthNavButton(systemName: "chevron.right") { shiftMonth(by: 1) }
      }
    }
    .frame(height: 20)
  }

  // Figma nav chevrons are plain gray glyphs, not the app's orange header
  // arrows. Using SF Symbols here keeps the size and tint exact while
  // avoiding extra asset work for a tiny 16pt icon.
  private func monthNavButton(
    systemName: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: systemName)
        .font(.system(size: 16, weight: .medium))
        .foregroundColor(Color(hex: "A8A09A"))
        .frame(width: 20, height: 20)
        .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .pointingHandCursor()
  }

  // Weekday header uses Instrument Serif 12pt per Figma (not Nunito).
  private var weekdayRow: some View {
    // `id: \.self` on ["S","M","T","W","T","F","S"] duplicates the "T" and
    // "S" IDs — SwiftUI logs "the ID T occurs multiple times" and the diff
    // becomes undefined. Keying by index is correct here: labels are
    // position-bound, not identity-bound.
    let labels = weekdayLabels()
    return HStack(spacing: Self.columnSpacing) {
      ForEach(labels.indices, id: \.self) { i in
        Text(labels[i])
          .font(.custom("InstrumentSerif-Regular", size: 12))
          .foregroundColor(.black)
          .frame(width: Self.columnWidth, height: Self.weekdayHeight)
      }
    }
  }

  // Fixed column widths keep weekday labels and dates perfectly aligned.
  private func dateGrid(weeks: [[CalendarDay]]) -> some View {
    return VStack(alignment: .leading, spacing: Self.rowSpacing) {
      ForEach(weeks.indices, id: \.self) { rowIndex in
        let week = weeks[rowIndex]
        let isSelectedWeek = highlightsSelectedWeek && isWeekSelected(week)

        ZStack {
          if isSelectedWeek {
            Capsule(style: .continuous)
              .fill(Color(hex: "FC7103"))
              .frame(
                width: Self.contentWidth,
                height: Self.selectedWeekHighlightHeight
              )
          }

          HStack(spacing: Self.columnSpacing) {
            ForEach(week) { day in
              dateCell(day: day, isInSelectedWeek: isSelectedWeek)
            }
          }
        }
        .frame(
          width: Self.contentWidth,
          height: Self.selectedWeekHighlightHeight
        )
      }
    }
  }

  private func dateCell(day: CalendarDay, isInSelectedWeek: Bool) -> some View {
    let calendar = Self.mondayCalendar
    let isSelected = calendar.isDate(day.date, inSameDayAs: selectedDate)
    let showsSelectedDayCircle = isSelected && !highlightsSelectedWeek
    let isDisabled: Bool = {
      guard !canSelectFutureDates else { return false }
      let todayStart = calendar.startOfDay(for: Date())
      let cellStart = calendar.startOfDay(for: day.date)
      return cellStart > todayStart
    }()
    let foregroundColor: Color = {
      if isInSelectedWeek {
        return (!day.isCurrentMonth || isDisabled) ? .white.opacity(0.55) : .white
      }
      if !day.isCurrentMonth || isDisabled {
        return Color(hex: "C1B5AC")
      }
      return showsSelectedDayCircle ? .white : .black
    }()

    return Button {
      guard !isDisabled else { return }
      onSelect(day.date)
    } label: {
      ZStack {
        if showsSelectedDayCircle {
          Circle()
            .fill(Color(hex: "FC7103"))
            .frame(width: Self.selectedCircleSize, height: Self.selectedCircleSize)
        }
        Text(day.label)
          .font(.custom("Nunito", size: 12))
          .foregroundColor(foregroundColor)
      }
      .frame(width: Self.columnWidth, height: Self.dayCellHeight)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .disabled(isDisabled)
    .pointingHandCursor(enabled: !isDisabled)
  }

  // MARK: - Data & navigation

  private struct CalendarDay: Identifiable {
    let date: Date
    let label: String
    let isCurrentMonth: Bool

    var id: Date { date }
  }

  private func shiftMonth(by months: Int) {
    let calendar = Self.mondayCalendar
    if let newMonth = calendar.date(byAdding: .month, value: months, to: displayMonth) {
      displayMonth = newMonth
    }
  }

  // Locale weekday symbols, rotated so Monday appears first.
  private func weekdayLabels() -> [String] {
    let calendar = Self.mondayCalendar
    let symbols = calendar.veryShortWeekdaySymbols
    let offset = calendar.firstWeekday - 1
    guard offset >= 0, offset < symbols.count else { return symbols }
    return Array(symbols[offset...]) + Array(symbols[..<offset])
  }

  // Build the visible month grid with leading/trailing days as needed to fill
  // complete Monday-Sunday weeks.
  private func daysToDisplay() -> [CalendarDay] {
    let calendar = Self.mondayCalendar
    let monthStart = displayMonth
    guard let monthRange = calendar.range(of: .day, in: .month, for: monthStart) else {
      return []
    }

    let firstWeekday = calendar.component(.weekday, from: monthStart)
    let leadingCount = (firstWeekday - calendar.firstWeekday + 7) % 7

    var days: [CalendarDay] = []

    // Leading days from the previous month.
    if leadingCount > 0,
      let prevMonthStart = calendar.date(byAdding: .month, value: -1, to: monthStart),
      let prevMonthRange = calendar.range(of: .day, in: .month, for: prevMonthStart)
    {
      let prevLast = prevMonthRange.count
      let startDay = prevLast - leadingCount + 1
      for offset in 0..<leadingCount {
        if let date = calendar.date(
          byAdding: .day, value: startDay - 1 + offset, to: prevMonthStart)
        {
          days.append(
            CalendarDay(
              date: date,
              label: "\(calendar.component(.day, from: date))",
              isCurrentMonth: false
            )
          )
        }
      }
    }

    // Current month.
    for offset in 0..<monthRange.count {
      if let date = calendar.date(byAdding: .day, value: offset, to: monthStart) {
        days.append(
          CalendarDay(
            date: date,
            label: "\(calendar.component(.day, from: date))",
            isCurrentMonth: true
          )
        )
      }
    }

    // Trailing days from next month to complete the last visible week.
    let trailingNeeded = (7 - (days.count % 7)) % 7
    if trailingNeeded > 0,
      let nextMonthStart = calendar.date(byAdding: .month, value: 1, to: monthStart)
    {
      for offset in 0..<trailingNeeded {
        if let date = calendar.date(byAdding: .day, value: offset, to: nextMonthStart) {
          days.append(
            CalendarDay(
              date: date,
              label: "\(calendar.component(.day, from: date))",
              isCurrentMonth: false
            )
          )
        }
      }
    }

    return days
  }

  private func weeksToDisplay() -> [[CalendarDay]] {
    let days = daysToDisplay()
    return stride(from: 0, to: days.count, by: 7).map { start in
      Array(days[start..<min(start + 7, days.count)])
    }
  }

  private func isWeekSelected(_ week: [CalendarDay]) -> Bool {
    guard let firstDay = week.first else { return false }
    return isDateInSelectedWeek(firstDay.date)
  }

  private func isDateInSelectedWeek(_ date: Date) -> Bool {
    let calendar = Self.mondayCalendar
    return calendar.isDate(date, equalTo: selectedDate, toGranularity: .weekOfYear)
  }
}
