import SwiftUI

/// Root container for the onboarding flow.
///
/// Manages step-based navigation with smooth directional transitions.
/// Each onboarding step is rendered by its corresponding view, and
/// transitions animate based on whether the user is moving forward or backward.
struct OnboardingContainerView: View {

    @State private var viewModel = OnboardingViewModel()

    /// Called when onboarding is complete.
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            // Step content with animated transitions
            Group {
                stepView(for: viewModel.currentStep)
            }
            .id(viewModel.currentStep)
            .transition(transition(for: viewModel.navigationDirection))
            .animation(.easeInOut(duration: 0.35), value: viewModel.currentStep)

            // Back button overlay (appears on all steps except the first)
            if viewModel.currentStep.previous != nil {
                VStack {
                    HStack {
                        BackButton {
                            viewModel.goBack()
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    Spacer()
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: viewModel.currentStep)
            }
        }
        .onChange(of: viewModel.isOnboardingComplete) { _, isComplete in
            if isComplete {
                onComplete()
            }
        }
    }

    // MARK: - Step View Router

    @ViewBuilder
    private func stepView(for step: OnboardingStep) -> some View {
        switch step {
        case .welcome:
            WelcomeView(viewModel: viewModel)
        case .tailorRecommendations:
            TailorRecommendationsView(viewModel: viewModel)
        case .nameInput:
            NameInputView(viewModel: viewModel)
        case .ageSelection:
            AgeSelectionView(viewModel: viewModel)
        case .genderSelection:
            GenderSelectionView(viewModel: viewModel)
        case .wordsPerWeek:
            WordsPerWeekView(viewModel: viewModel)
        case .curiosityDriver:
            CuriosityDriverView(viewModel: viewModel)
        case .vocabularyLevel:
            VocabularyLevelView(viewModel: viewModel)
        case .topicSelection:
            TopicSelectionView(viewModel: viewModel)
        case .voiceSelection:
            VoiceSelectionView(viewModel: viewModel)
        case .themeSelection:
            ThemeSelectionView(viewModel: viewModel)
        }
    }

    // MARK: - Transitions

    private func transition(for direction: OnboardingViewModel.NavigationDirection) -> AnyTransition {
        switch direction {
        case .forward:
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        case .backward:
            return .asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingContainerView { }
}
