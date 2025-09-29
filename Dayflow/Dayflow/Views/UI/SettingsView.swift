//
//  SettingsView.swift
//  Dayflow
//
//  Settings page with provider selection cards using shared components
//

import SwiftUI
import AppKit

struct SettingsView: View {
    @EnvironmentObject private var updater: UpdaterManager
    @EnvironmentObject private var obsidianSettingsStore: ObsidianSettingsStore
    // State for current provider
    @State private var currentProvider: String = "gemini"
    @State private var setupModalProvider: String? = nil
    @State private var hasLoadedProvider: Bool = false
    @State private var analyticsEnabled: Bool = AnalyticsService.shared.isOptedIn
    
    // Local LLM saved settings for test UI
    @State private var localBaseURL: String = UserDefaults.standard.string(forKey: "llmLocalBaseURL") ?? "http://localhost:11434"
    @State private var localModelId: String = UserDefaults.standard.string(forKey: "llmLocalModelId") ?? "qwen2.5vl:3b"
    @State private var localEngine: LocalEngine = {
        let raw = UserDefaults.standard.string(forKey: "llmLocalEngine") ?? "ollama"
        return LocalEngine(rawValue: raw) ?? .ollama
    }()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                // Header - left aligned
                VStack(alignment: .leading, spacing: 12) {
                    Text("Settings")
                        .font(.custom("InstrumentSerif-Regular", size: 42))
                        .foregroundColor(.black.opacity(0.9))
                        .padding(.leading, 10)
                    
                    Text("Manage how Dayflow is run")
                        .font(.custom("Nunito", size: 14))
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.leading, 10)

                    // Analytics toggle (default ON)
                    Toggle(isOn: $analyticsEnabled) {
                        Text("Share crash reports and anonymous usage data")
                            .font(.custom("Nunito", size: 13))
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .toggleStyle(.switch)
                    .frame(maxWidth: 340, alignment: .leading)
                    .padding(.leading, 10)

                    // App version (update UI hidden per design feedback)
                    Text("Dayflow v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                        .font(.custom("Nunito", size: 13))
                        .foregroundColor(.black.opacity(0.65))
                        .padding(.top, 4)
                        .padding(.leading, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Test connection section adapts to selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Test LLM Connection")
                        .font(.custom("Nunito", size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.9))

                    Group {
                        if currentProvider == "gemini" {
                            TestConnectionView(onTestComplete: { _ in })
                        } else if currentProvider == "ollama" {
                            LocalLLMTestView(
                                baseURL: $localBaseURL,
                                modelId: $localModelId,
                                engine: localEngine,
                                showInputs: false,
                                onTestComplete: { _ in
                                    // Persist any updated values back (defensive)
                                    UserDefaults.standard.set(localBaseURL, forKey: "llmLocalBaseURL")
                                    UserDefaults.standard.set(localModelId, forKey: "llmLocalModelId")
                                }
                            )
                        } else {
                            // Unknown provider fallback
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "E91515"))
                                Text("Unknown provider – please reselect above.")
                                    .font(.custom("Nunito", size: 13))
                                    .foregroundColor(Color(hex: "E91515"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .frame(maxWidth: 520, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)

                obsidianSettingsSection

                Spacer(minLength: 30)

                // Provider cards row
                HStack(spacing: 20) {
                    ForEach(providerCards, id: \.id) { card in
                        card
                            .frame(maxWidth: 350)
                            .frame(height: 420)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)

                Spacer(minLength: 30)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            loadCurrentProvider()
            AnalyticsService.shared.capture("settings_opened")
            analyticsEnabled = AnalyticsService.shared.isOptedIn
            // Refresh cached local settings for test section
            localBaseURL = UserDefaults.standard.string(forKey: "llmLocalBaseURL") ?? localBaseURL
            localModelId = UserDefaults.standard.string(forKey: "llmLocalModelId") ?? localModelId
            let raw = UserDefaults.standard.string(forKey: "llmLocalEngine") ?? localEngine.rawValue
            localEngine = LocalEngine(rawValue: raw) ?? localEngine
        }
        .onChange(of: analyticsEnabled) { enabled in
            AnalyticsService.shared.setOptIn(enabled)
            AnalyticsService.shared.capture("analytics_opt_in_changed", ["enabled": enabled])
        }
        .onChange(of: currentProvider) { _ in
            // Keep local tester in sync when switching providers
            localBaseURL = UserDefaults.standard.string(forKey: "llmLocalBaseURL") ?? localBaseURL
            localModelId = UserDefaults.standard.string(forKey: "llmLocalModelId") ?? localModelId
            let raw = UserDefaults.standard.string(forKey: "llmLocalEngine") ?? localEngine.rawValue
            localEngine = LocalEngine(rawValue: raw) ?? localEngine
        }
        .sheet(item: Binding(
            get: { setupModalProvider.map { ProviderSetupWrapper(id: $0) } },
            set: { setupModalProvider = $0?.id }
        )) { wrapper in
            LLMProviderSetupView(
                providerType: wrapper.id,
                onBack: { setupModalProvider = nil },
                onComplete: {
                    completeProviderSwitch(wrapper.id)
                    setupModalProvider = nil
                }
            )
            .frame(minWidth: 900, minHeight: 650)
        }
    }
    
    
    private var providerCards: [FlexibleProviderCard] {
        [
            FlexibleProviderCard(
                id: "ollama",
                title: "Use local AI",
                badgeText: "MOST PRIVATE",
                badgeType: .green,
                icon: "desktopcomputer",
                features: [
                    ("100% private - everything's processed on your computer", true),
                    ("Works completely offline", true),
                    ("Significantly less intelligence", true),
                    ("Requires the most setup", false),
                    ("16GB+ of RAM recommended", false),
                    ("Can be battery-intensive", false)
                ],
                isSelected: currentProvider == "ollama",
                buttonMode: .settings(onSwitch: { switchToProvider("ollama") }),
                showCurrentlySelected: true
            ),
            
            FlexibleProviderCard(
                id: "gemini",
                title: "Bring your own API keys",
                badgeText: "RECOMMENDED",
                badgeType: .orange,
                icon: "key.fill",
                features: [
                    ("Utilizes more intelligent AI via Google's Gemini models", true),
                    ("Uses Gemini's generous free tier (no credit card needed)", true),
                    ("Faster, more accurate than local models", true),
                    ("Requires getting an API key (takes 2 clicks)", false)
                ],
                isSelected: currentProvider == "gemini",
                buttonMode: .settings(onSwitch: { switchToProvider("gemini") }),
                showCurrentlySelected: true
            )
        ]
    }

    private var obsidianSettingsSection: some View {
        let settings = obsidianSettingsStore.settings
        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Obsidian Export")
                    .font(.custom("Nunito", size: 16).weight(.semibold))
                    .foregroundColor(.black.opacity(0.9))

                Spacer()

                Text(settings.isEnabled ? "Enabled" : "Disabled")
                    .font(.custom("Nunito", size: 12).weight(.semibold))
                    .foregroundColor(settings.isEnabled ? Color(hex: "0F9154") : Color.black.opacity(0.4))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(settings.isEnabled ? Color(hex: "E5F7ED") : Color.black.opacity(0.05))
                    )
            }

            Text("Automatically send your daily journal to an Obsidian vault.")
                .font(.custom("Nunito", size: 13))
                .foregroundColor(.black.opacity(0.6))

            Toggle(isOn: Binding(
                get: { obsidianSettingsStore.settings.isEnabled },
                set: { obsidianSettingsStore.settings.isEnabled = $0 }
            )) {
                Text("Enable Obsidian export")
                    .font(.custom("Nunito", size: 13))
                    .foregroundColor(.black.opacity(0.75))
            }
            .toggleStyle(.switch)
            .tint(Color(hex: "FF7506"))

            VStack(alignment: .leading, spacing: 10) {
                Text("Destination directory")
                    .font(.custom("Nunito", size: 12).weight(.semibold))
                    .foregroundColor(.black.opacity(0.7))

                HStack(spacing: 10) {
                    settingsTextField(
                        placeholder: "~/Documents/Notes",
                        text: Binding(
                            get: { obsidianSettingsStore.settings.directoryPath },
                            set: { obsidianSettingsStore.settings.directoryPath = $0 }
                        )
                    )
                    .frame(minWidth: 280)

                    Button(action: chooseDirectory) {
                        Label("Choose…", systemImage: "folder")
                            .labelStyle(.titleAndIcon)
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }

                Text("Dayflow writes or appends to `YYYY-MM-DD.md` inside this folder.")
                    .font(.custom("Nunito", size: 11))
                    .foregroundColor(.black.opacity(0.45))
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Write position")
                    .font(.custom("Nunito", size: 12).weight(.semibold))
                    .foregroundColor(.black.opacity(0.7))

                Picker("Write position", selection: Binding(
                    get: { obsidianSettingsStore.settings.writePosition },
                    set: { obsidianSettingsStore.settings.writePosition = $0 }
                )) {
                    ForEach(ObsidianWritePosition.allCases) { position in
                        Text(position.label).tag(position)
                    }
                }
                .pickerStyle(.segmented)

                if settings.writePosition.requiresAnchor {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(settings.writePosition == .afterLine ? "Insert after first line containing" : "Insert before first line containing")
                            .font(.custom("Nunito", size: 12).weight(.semibold))
                            .foregroundColor(.black.opacity(0.7))

                        settingsTextField(
                            placeholder: "e.g. ## Daily Notes",
                            text: Binding(
                                get: { obsidianSettingsStore.settings.anchorText },
                                set: { obsidianSettingsStore.settings.anchorText = $0 }
                            )
                        )

                        Text("If the anchor isn’t found, Dayflow appends the journal to the end of the file.")
                            .font(.custom("Nunito", size: 11))
                            .foregroundColor(.black.opacity(0.45))
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Section title")
                    .font(.custom("Nunito", size: 12).weight(.semibold))
                    .foregroundColor(.black.opacity(0.7))

                settingsTextField(
                    placeholder: "☀️ Dailyflow",
                    text: Binding(
                        get: { obsidianSettingsStore.settings.title },
                        set: { obsidianSettingsStore.settings.title = $0 }
                    )
                )

                Text("This heading is added above the exported journal content.")
                    .font(.custom("Nunito", size: 11))
                    .foregroundColor(.black.opacity(0.45))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.95))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(hex: "E5E5E5"), lineWidth: 1)
        )
        .padding(.horizontal, 10)
    }

    private func chooseDirectory() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.prompt = "Choose"

        if panel.runModal() == .OK, let url = panel.url {
            obsidianSettingsStore.settings.directoryPath = url.path
            // Store security-scoped bookmark for later access
            do {
                let bookmark = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                obsidianSettingsStore.settings.directoryBookmark = bookmark
            } catch {
                print("Failed to create bookmark: \(error)")
                obsidianSettingsStore.settings.directoryBookmark = nil
            }
        }
    }

    @ViewBuilder
    private func settingsTextField(placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .textFieldStyle(.plain)
            .font(.custom("Nunito", size: 13))
            .foregroundColor(.black)
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.white.opacity(0.98))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.black.opacity(0.12), lineWidth: 1)
            )
    }

    private func loadCurrentProvider() {
        guard !hasLoadedProvider else { return }
        
        if let data = UserDefaults.standard.data(forKey: "llmProviderType"),
           let providerType = try? JSONDecoder().decode(LLMProviderType.self, from: data) {
            switch providerType {
            case .geminiDirect:
                currentProvider = "gemini"
            case .ollamaLocal:
                currentProvider = "ollama"
            }
        }
        hasLoadedProvider = true
    }
    
    private func switchToProvider(_ providerId: String) {
        guard providerId != currentProvider else { return }
        // Open setup flow for the selected provider
        AnalyticsService.shared.capture("provider_switch_initiated", ["from": currentProvider, "to": providerId])
        setupModalProvider = providerId
    }
    
    private func completeProviderSwitch(_ providerId: String) {
        // Save the provider type
        let providerType: LLMProviderType
        switch providerId {
        case "ollama":
            let endpoint = UserDefaults.standard.string(forKey: "llmLocalBaseURL") ?? "http://localhost:11434"
            providerType = .ollamaLocal(endpoint: endpoint)
        case "gemini":
            providerType = .geminiDirect
        default:
            return
        }
        if let encoded = try? JSONEncoder().encode(providerType) {
            UserDefaults.standard.set(encoded, forKey: "llmProviderType")
        }
        
        // Update current selection
        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
            currentProvider = providerId
        }
        AnalyticsService.shared.capture("provider_setup_completed", ["provider": providerId])
        AnalyticsService.shared.setPersonProperties(["current_llm_provider": providerId])
    }
}


struct ProviderSetupWrapper: Identifiable {
    let id: String
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .frame(width: 1400, height: 800)
            .background(Color.gray.opacity(0.1))
    }
}
