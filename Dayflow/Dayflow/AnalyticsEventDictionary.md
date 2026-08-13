# Dayflow Analytics Event Dictionary (Telemetry Disabled)

This reference is retained for historical context; the enterprise build ships with analytics disabled and the instrumentation stubs are no-ops. If the event pipeline is re-enabled in a future fork, these notes describe the intended payloads.

## Conventions
- Event names: snake_case
- Screens: `screen_viewed` with `screen`
- Common super properties (registered on boot): `app_version`, `build_number`, `os_version`, `device_model`, `locale`, `time_zone`
- Person properties (identify): `analytics_opt_in`, `onboarding_status`, `current_llm_provider`, `recording_enabled`, `install_ts` (set once)

## Lifecycle
- app_opened
  - props: `cold_start: bool`
  - file: App/AppDelegate.swift
- app_updated
  - props: `from_version: string`, `to_version: string`
  - file: App/AppDelegate.swift
- app_terminated
  - file: App/AppDelegate.swift
- screen_viewed
  - props: `screen: string`
  - files: Views/* (various)

## Onboarding
- onboarding_started
  - file: Views/Onboarding/OnboardingFlow.swift (welcome appear)
- onboarding_step_completed
  - props: `step: welcome|how_it_works|llm_selection|llm_setup|categories|screen_recording|completion`
  - file: Views/Onboarding/OnboardingFlow.swift
- llm_provider_selected
  - props: `provider: gemini|ollama`
  - file: Views/Onboarding/OnboardingFlow.swift
- screen_permission_granted / screen_permission_denied
  - file: Views/Onboarding/ScreenRecordingPermissionView.swift
- connection_test_started / connection_test_succeeded / connection_test_failed
  - props: `provider: gemini`, `error_code?: enum|string`
  - files: Views/Onboarding/TestConnectionView.swift
- onboarding_completed
  - file: Views/Onboarding/OnboardingFlow.swift
- onboarding_abandoned
  - props: `last_step: string`
  - file: App/AppDelegate.swift (willTerminate)
- terminal_command_copied
  - props: `title?: string`, `source?: settings`
  - files: Views/Onboarding/TerminalCommandView.swift, Views/UI/Settings/SettingsAgentAccessTabView.swift

## Agent Access
- agent_client_connected
  - props: `client: codex|claudeCode|claudeDesktop`
  - file: Views/UI/Settings/SettingsAgentAccessTabView.swift
- agent_client_deeplink
  - props: `client: cursor|vsCode`
  - file: Views/UI/Settings/SettingsAgentAccessTabView.swift
- agent_edits_toggled
  - props: `enabled: bool`
  - file: Views/UI/Settings/SettingsAgentAccessTabView.swift
- agent_command_executed
  - props: `schema_version: int`, `interface: cli|mcp`, allowlisted `operation: string`, `outcome: success|failure|cancelled`, `failure_category?: invalid_input|not_found|edits_disabled|unavailable|execution_error|tool_error`, `duration_bucket: under_100ms|100_to_499ms|500_to_1999ms|2_to_9s|10s_plus`, `cli_version: string`
  - privacy: locally queued and uploaded only through the opted-in app; never includes arguments, dates, search text, record IDs, paths, command lines, error text, or returned content
  - files: tools/dayflow-cli/Sources/dayflow/AgentUsageTelemetry.swift, Core/AgentAccess/AgentUsageTelemetryQueue.swift

## AgentPlayback
- Launch and failure events include `attempt_id`, `requested_version`, `attempt_elapsed_seconds`, and `fallback_from_attempt_id` when recovering from another attempt.
- Failure context includes `process_running`, `app_active`, `page_url`, `webview_loading`, and `system_uptime_seconds`. Native errors also include `error_domain`, `error_code`, `error_details`, and `error_user_info`. Process output includes Node version/executable, CLI path, and child exit code/signal. WebKit process termination callbacks do not provide a crash reason.
- agentplayback_opened
  - props: `already_loaded: bool`
  - once per tab visit, including visits that fail to load; not emitted on every foreground transition
- agentplayback_launch_started
  - props: `mode: latest|cached_fallback`
- agentplayback_launch_completed
  - props: `mode: latest|cached_fallback`, `outcome: success|failure`, `duration_seconds: number`, `agentplayback_version?: string`, `failure_category?: preparation|process_launch|process_exit|missing_runtime|timeout|navigation|web_content_terminated`, `will_try_fallback?: bool`, failure diagnostics: `startup_stage`, `output_character_count`, `login_shell`, `termination_status?`, `termination_reason?`
  - one result per launch attempt; success means WebKit finished loading the dashboard, not that every historical scan finished; a recovered failure and fallback success remain separate attempts
- agentplayback_runtime_failed
  - props: `mode: latest|cached_fallback`, `agentplayback_version?: string`, `failure_category: preparation|process_launch|process_exit|missing_runtime|timeout|navigation|web_content_terminated`, `will_try_fallback: bool`, `startup_stage`, `output_character_count`, `login_shell`, `termination_status?`, `termination_reason?`
  - failures after the initial page load, separate from startup failures
- agentplayback_retry_clicked
  - explicit click on Try again
- agentplayback_session_ended
  - props: `duration_seconds: number`, `reason: tab_closed|background|unavailable|app_exit`
  - one foreground viewing interval with the Agents tab selected and dashboard loaded; excludes downloads, hidden-tab time, and time in other apps; sum durations for total viewing time, not session counts for unique visits; crashes may lose the final interval
  - privacy: all events use AnalyticsService and its analytics opt-in; opting out discards the current viewing interval. Launch and runtime failure events additionally include unsanitized `error_message` and `process_output` (the captured output buffer, capped at 16,000 characters), which may contain paths, URLs, and other process-emitted content. Successful launches and viewing events do not include these fields.
  - files: Views/UI/Agents/AgentPlaybackView.swift, Views/UI/Agents/AgentPlaybackUsage.swift

## Settings & Privacy
- settings_opened
  - file: Views/UI/SettingsView.swift
- analytics_opt_in_changed
  - props: `enabled: bool`
  - file: Views/UI/SettingsView.swift
- provider_switch_initiated
  - props: `from: string`, `to: string`
  - file: Views/UI/SettingsView.swift
- provider_setup_completed
  - props: `provider: gemini|ollama`
  - file: Views/UI/SettingsView.swift

## Navigation & Timeline
- tab_selected
  - props: `tab: timeline|dashboard|journal|settings`
  - file: Views/UI/MainView.swift
- timeline_viewed
  - props: `date_bucket: yyyy-MM-dd`
  - file: Views/UI/MainView.swift
- date_navigation
  - props: `method: prev|next|picker`, `from_day: yyyy-MM-dd`, `to_day: yyyy-MM-dd`
  - file: Views/UI/MainView.swift
- activity_card_opened
  - props: `activity_type: string`, `duration_bucket: string`, `has_video: bool`
  - file: Views/UI/MainView.swift
- timeline_copied
  - props: `timeline_day: yyyy-MM-dd`, `activity_count: int`
  - file: Views/UI/MainView.swift

## Flow
- screen_viewed (`screen: flow_waitlist`)
  - file: Views/UI/Flow/FlowWaitlistView.swift
- flow_waitlist_joined
  - props: `outcome: success|failure`, `signed_in: bool`
  - file: Views/UI/Flow/FlowWaitlistView.swift
- flow_waitlist_message_sent
  - props: `has_debug_log: false`, `new_ticket: bool`
  - file: Views/UI/SupportChatWebView.swift
- flow_waitlist_chat_unavailable
  - props: `reason: string`
  - file: Views/UI/SupportChatWebView.swift
- flow_access_code_redeemed
  - props: `outcome: success|failure`
  - file: Views/UI/Flow/FlowWaitlistView.swift

## Dashboard Chat
- chat_question_asked
  - props: `question: string`, `conversation_id: uuid`, `is_new_conversation: bool`, `message_index: int`, `provider: gemini|codex|claude`, `chat_runtime: gemini_function_calling|chat_cli`
  - file: Views/UI/ChatView.swift

## Video
- video_modal_opened
  - props: `source: activity_card|unknown`, `duration_bucket: string`
  - file: Views/UI/VideoPlayerModal.swift
- video_play_started
  - props: `speed: string`
  - file: Views/UI/VideoPlayerModal.swift
- video_paused, video_resumed
  - file: Views/UI/VideoPlayerModal.swift
- seek_performed (throttled)
  - props: `from_s_bucket: string`, `to_s_bucket: string`
  - file: Views/UI/VideoPlayerModal.swift
- video_completed
  - props: `watch_time_bucket: string`, `completion_pct_bucket: string`
  - file: Views/UI/VideoPlayerModal.swift (onDisappear)

## Recording
- recording_toggled
  - props: `enabled: bool`, `reason: user|auto`
  - file: App/AppDelegate.swift (observation) and AppDelegate auto-start
- recording_started
  - file: Core/Recording/ScreenRecorder.swift (startStream)
- recording_stopped
  - props: `stop_reason: user|system_sleep|lock|screensaver`
  - file: Core/Recording/ScreenRecorder.swift
- recording_error
  - props: `code: int`, `retryable: bool`
  - file: Core/Recording/ScreenRecorder.swift
- recording_auto_recovery
  - props: `outcome: restarted|gave_up`
  - file: Core/Recording/ScreenRecorder.swift
- chunk_created (sampled ~1%)
  - props: `duration_bucket: string`, `resolution_bucket: string`
  - file: Core/Recording/ScreenRecorder.swift

## AI / LLM / Analysis
- analysis_job_started
  - props: `provider: gemini|ollama|unknown`
  - file: App/AppDelegate.swift
- llm_api_call (sampled ~10%)
  - props: `provider: string`, `model: string`, `latency_ms_bucket: <500ms|0.5-1.5s|>=1.5s`, `outcome: success|error`, `error_code?: int`
  - file: Core/AI/LLMLogger.swift

<!-- Storage-related events intentionally removed -->
