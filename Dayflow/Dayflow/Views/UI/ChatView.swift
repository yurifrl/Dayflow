//
//  ChatView.swift
//  Dayflow
//
//  Chat interface for asking questions about activity data.
//

import AppKit
import Charts
import SwiftUI

let chatViewDebugTimestampFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "HH:mm:ss.SSS"
  return formatter
}()

let chatViewMemoryUpdatedFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "MMM d, h:mm a"
  return formatter
}()

struct ChatView: View {
  @ObservedObject private var chatService = ChatService.shared
  @State private var inputText = ""
  @State private var showWorkDetails = false
  @State private var isInputFocused = false
  @State private var composerFocusToken = 0
  @Namespace private var bottomID
  @AppStorage("dashboardChatProvider") private var selectedProviderRaw: String = "gemini"
  @AppStorage("chatCLIPreferredTool") private var chatCLIPreferredTool: String = "codex"
  @AppStorage("hasChatBetaAccepted") private var hasBetaAccepted: Bool = true
  @State private var geminiConfigured = false
  @State private var codexDetected = false
  @State private var claudeDetected = false
  @State private var cliDetectionTask: Task<Void, Never>?
  @State private var didCheckCLI = false
  @State private var showToolSwitchConfirm = false
  @State private var pendingProviderSelection: DashboardChatProvider?
  @State private var conversationId: UUID?
  @State private var didAnimateWelcome = false
  @State private var showMemoryPanel = false
  @State private var memoryDraft = ""
  @State private var storedMemoryBlob = ""
  @State private var memoryUpdatedAt: Date?
  @State private var chatVoteSelections: [UUID: TimelineRatingDirection] = [:]
  @State private var thankedMessageIDs: Set<UUID> = []
  @State private var thankResetTasks: [UUID: Task<Void, Never>] = [:]
  @State private var chatFeedbackTarget: ChatFeedbackTarget?
  @State private var chatFeedbackMessage = ""
  @State private var chatFeedbackShareLogs = true
  @State private var chatFeedbackMode: TimelineFeedbackMode = .form
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  private var selectedProvider: DashboardChatProvider {
    DashboardChatProvider.fromStoredValue(selectedProviderRaw)
  }

  private var isUnlocked: Bool {
    hasBetaAccepted
  }

  private var anyRuntimeAvailable: Bool {
    geminiConfigured || codexDetected || claudeDetected
  }

  private var selectedProviderAvailable: Bool {
    isProviderAvailable(selectedProvider)
  }

  private var welcomePrompts: [WelcomePrompt] {
    [
      WelcomePrompt(icon: "doc.text", text: "Generate standup notes for yesterday"),
      WelcomePrompt(icon: "checkmark.seal", text: "What did I get done last week?"),
      WelcomePrompt(
        icon: "exclamationmark.bubble", text: "When was I most focused this week"),
      WelcomePrompt(
        icon: "sparkles", text: "Compare this week to last week"),
    ]
  }

  private var welcomeHeroAnimation: Animation {
    if reduceMotion {
      return .easeOut(duration: 0.01)
    }
    return .timingCurve(0.16, 1, 0.3, 1, duration: 0.42)
  }

  private func welcomeSuggestionAnimation(at index: Int) -> Animation {
    if reduceMotion {
      return .easeOut(duration: 0.01)
    }
    return .timingCurve(0.16, 1, 0.3, 1, duration: 0.34)
      .delay(Double(index) * 0.045)
  }

  private var trimmedInputText: String {
    inputText.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private var canSubmitCurrentInput: Bool {
    !chatService.isProcessing && !trimmedInputText.isEmpty && selectedProviderAvailable
  }

  private var composerBorderColor: Color {
    if isInputFocused {
      return Color(hex: "F4A867")
    }
    return Color(hex: "E5D8CA")
  }

  private var memoryCharacterCount: Int {
    memoryDraft.count
  }

  private var isMemoryDirty: Bool {
    memoryDraft != storedMemoryBlob
  }

  private var memoryUpdatedLabel: String {
    guard let memoryUpdatedAt else { return "Not saved yet" }
    return chatViewMemoryUpdatedFormatter.string(from: memoryUpdatedAt)
  }

  var body: some View {
    ZStack {
      if isUnlocked {
        HStack(spacing: 0) {
          chatContent
          if showMemoryPanel {
            memoryPanel
          }
          if chatService.showDebugPanel {
            debugPanel
          }
        }
        .allowsHitTesting(chatFeedbackTarget == nil)
        .transition(.opacity)

        if let chatFeedbackTarget {
          TimelineFeedbackModal(
            message: $chatFeedbackMessage,
            shareLogs: $chatFeedbackShareLogs,
            direction: chatFeedbackTarget.direction,
            mode: chatFeedbackMode,
            content: .chat,
            onSubmit: submitChatFeedback,
            onClose: { dismissChatFeedback() }
          )
          .padding(.leading, 20)
          .padding(.bottom, 16)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
          .transition(.move(edge: .bottom).combined(with: .opacity))
          .zIndex(2)
        }
      } else {
        betaLockScreen
          .transition(.opacity.combined(with: .move(edge: .bottom)))
      }
    }
    .task {
      guard !didCheckCLI else { return }
      didCheckCLI = true
      await refreshRuntimeAvailability()
    }
    .onAppear {
      loadMemoryFromStore(resetDraft: true)
      Task { await refreshRuntimeAvailability() }
    }
    .onDisappear {
      cliDetectionTask?.cancel()
      cliDetectionTask = nil
      for task in thankResetTasks.values {
        task.cancel()
      }
      thankResetTasks.removeAll()
    }
    .onChange(of: chatService.messages.count) { _, _ in
      syncMemoryFromStoreIfNeeded()
    }
    .alert("Switch provider?", isPresented: $showToolSwitchConfirm) {
      Button("Switch and Reset", role: .destructive) {
        confirmProviderSwitch()
      }
      Button("Cancel", role: .cancel) {
        pendingProviderSelection = nil
      }
    } message: {
      Text("Switching to \(pendingProviderLabel) will clear this chat's context.")
    }
    .environment(\.colorScheme, .light)
  }
}
