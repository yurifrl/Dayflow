//
//  JournalCoordinator.swift
//  Dayflow
//
//  Stub: coordinates journal onboarding state.
//

import Foundation

@MainActor
final class JournalCoordinator: ObservableObject {
    @Published var showOnboardingVideo = false
    @Published var showRemindersAfterOnboarding = false
}
