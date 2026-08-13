//
//  JournalOnboardingVideoView.swift
//  Dayflow
//
//  Stub: placeholder for journal onboarding video.
//

import SwiftUI

struct JournalOnboardingVideoView: View {
    var onComplete: () -> Void

    var body: some View {
        // Placeholder - auto-complete onboarding
        Color.clear
            .onAppear { onComplete() }
    }
}
