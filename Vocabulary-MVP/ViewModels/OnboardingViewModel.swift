import SwiftUI

/// Drives the entire onboarding flow, managing navigation between steps
/// and collecting user preferences.
///
/// Uses `@Observable` for efficient SwiftUI updates and persists
/// preferences via `PreferencesService` upon completion.
@Observable
final class OnboardingViewModel {

    // MARK: - Navigation State

    /// The current onboarding step being displayed.
    var currentStep: OnboardingStep = .welcome

    /// Direction of the last navigation (for transition animations).
    var navigationDirection: NavigationDirection = .forward

    /// Whether onboarding is complete and the app should show the home screen.
    var isOnboardingComplete = false

    // MARK: - User Preferences

    var name: String = ""
    var selectedAge: AgeRange?
    var selectedGender: Gender?
    var selectedWordsPerWeek: WordsPerWeek?
    var selectedCuriosityDriver: CuriosityDriver?
    var selectedVocabularyLevel: VocabularyLevel?
    var selectedTopics: Set<Topic> = []
    var selectedVoice: VoiceOption = .brian
    var selectedTheme: AppTheme = .classic

    // MARK: - Navigation Direction

    enum NavigationDirection {
        case forward
        case backward
    }

    // MARK: - Navigation Actions

    /// Advances to the next onboarding step.
    func advance() {
        guard let next = currentStep.next else {
            completeOnboarding()
            return
        }
        HapticService.shared.success()
        navigationDirection = .forward
        currentStep = next
    }

    /// Skips the current step and advances.
    func skip() {
        HapticService.shared.lightTap()
        guard let next = currentStep.next else {
            completeOnboarding()
            return
        }
        navigationDirection = .forward
        currentStep = next
    }

    /// Goes back to the previous step (if available).
    func goBack() {
        guard let previous = currentStep.previous else { return }
        navigationDirection = .backward
        currentStep = previous
    }

    /// Finalizes onboarding: saves preferences and transitions to home.
    func completeOnboarding() {
        let preferences = UserPreferences(
            name: name.isEmpty ? nil : name,
            ageRange: selectedAge,
            gender: selectedGender,
            wordsPerWeek: selectedWordsPerWeek,
            curiosityDriver: selectedCuriosityDriver,
            vocabularyLevel: selectedVocabularyLevel,
            selectedTopics: Array(selectedTopics),
            selectedVoice: selectedVoice,
            selectedTheme: selectedTheme,
            hasCompletedOnboarding: true
        )
        PreferencesService.shared.save(preferences)
        HapticService.shared.success()
        isOnboardingComplete = true
    }

    // MARK: - Computed Properties

    /// Progress through onboarding (0.0 to 1.0).
    var progress: Double {
        Double(currentStep.rawValue) / Double(OnboardingStep.totalSteps - 1)
    }

    /// Whether the current step allows skipping.
    var canSkip: Bool {
        currentStep.isSkippable
    }

    /// Whether the current step has a valid selection to proceed.
    var canProceed: Bool {
        switch currentStep {
        case .welcome, .tailorRecommendations:
            return true
        case .nameInput:
            return true // Name is optional
        case .ageSelection:
            return selectedAge != nil
        case .genderSelection:
            return selectedGender != nil
        case .wordsPerWeek:
            return selectedWordsPerWeek != nil
        case .curiosityDriver:
            return selectedCuriosityDriver != nil
        case .vocabularyLevel:
            return selectedVocabularyLevel != nil
        case .topicSelection:
            return !selectedTopics.isEmpty
        case .voiceSelection:
            return true // Default voice is pre-selected
        case .themeSelection:
            return true // Default theme is pre-selected
        }
    }

    // MARK: - Topic Selection Helpers

    func toggleTopic(_ topic: Topic) {
        if selectedTopics.contains(topic) {
            selectedTopics.remove(topic)
        } else {
            selectedTopics.insert(topic)
        }
    }

    func isTopicSelected(_ topic: Topic) -> Bool {
        selectedTopics.contains(topic)
    }
}
