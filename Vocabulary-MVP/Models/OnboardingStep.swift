import Foundation

/// Defines the ordered sequence of onboarding screens.
enum OnboardingStep: Int, CaseIterable, Identifiable, Comparable {
    case welcome = 0
    case tailorRecommendations
    case nameInput
    case ageSelection
    case genderSelection
    case wordsPerWeek
    case curiosityDriver
    case vocabularyLevel
    case topicSelection
    case voiceSelection
    case themeSelection

    var id: Int { rawValue }

    /// Whether this step can be skipped by the user.
    var isSkippable: Bool {
        switch self {
        case .welcome, .tailorRecommendations, .voiceSelection, .themeSelection:
            return false
        default:
            return true
        }
    }

    /// The next step in the sequence, or nil if this is the last step.
    var next: OnboardingStep? {
        OnboardingStep(rawValue: rawValue + 1)
    }

    /// The previous step in the sequence, or nil if this is the first step.
    var previous: OnboardingStep? {
        OnboardingStep(rawValue: rawValue - 1)
    }

    /// Total number of onboarding steps.
    static var totalSteps: Int {
        OnboardingStep.allCases.count
    }

    static func < (lhs: OnboardingStep, rhs: OnboardingStep) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
