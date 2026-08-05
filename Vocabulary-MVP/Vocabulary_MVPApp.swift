//
//  Vocabulary_MVPApp.swift
//  Vocabulary-MVP
//
//  Created by Mohamed Abd ElNasser on 05/08/2026.
//

import SwiftUI

@main
struct Vocabulary_MVPApp: App {

    @State private var hasCompletedOnboarding = PreferencesService.shared.hasCompletedOnboarding

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    HomeView()
                        .transition(.opacity)
                } else {
                    OnboardingContainerView {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            hasCompletedOnboarding = true
                        }
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: hasCompletedOnboarding)
            .preferredColorScheme(.light)
        }
    }
}
