import Foundation

// MARK: - User Preferences

/// Persisted user preferences collected during onboarding.
struct UserPreferences: Codable {
    var name: String?
    var ageRange: AgeRange?
    var gender: Gender?
    var wordsPerWeek: WordsPerWeek?
    var curiosityDriver: CuriosityDriver?
    var vocabularyLevel: VocabularyLevel?
    var selectedTopics: [Topic]
    var selectedVoice: VoiceOption
    var selectedTheme: AppTheme
    var hasCompletedOnboarding: Bool

    static let `default` = UserPreferences(
        name: nil,
        ageRange: nil,
        gender: nil,
        wordsPerWeek: nil,
        curiosityDriver: nil,
        vocabularyLevel: nil,
        selectedTopics: [],
        selectedVoice: .brian,
        selectedTheme: .classic,
        hasCompletedOnboarding: false
    )
}

// MARK: - Age Range

enum AgeRange: String, Codable, CaseIterable, Identifiable {
    case thirteenToSeventeen = "13 to 17"
    case eighteenToTwentyFour = "18 to 24"
    case twentyFiveToThirtyFour = "25 to 34"
    case thirtyFiveToFortyFour = "35 to 44"
    case fortyFiveToFiftyFour = "45 to 54"
    case fiftyFivePlus = "55+"

    var id: String { rawValue }
    var displayText: String { rawValue }
}

// MARK: - Gender

enum Gender: String, Codable, CaseIterable, Identifiable {
    case female = "Female"
    case male = "Male"
    case other = "Other"
    case preferNotToSay = "Prefer not to say"

    var id: String { rawValue }
    var displayText: String { rawValue }
}

// MARK: - Words Per Week

enum WordsPerWeek: String, Codable, CaseIterable, Identifiable {
    case ten = "10 words a week"
    case thirty = "30 words a week"
    case fifty = "50 words a week"

    var id: String { rawValue }
    var displayText: String { rawValue }

    var count: Int {
        switch self {
        case .ten: return 10
        case .thirty: return 30
        case .fifty: return 50
        }
    }
}

// MARK: - Curiosity Driver

enum CuriosityDriver: String, Codable, CaseIterable, Identifiable {
    case lifelongLearner = "I'm a lifelong learner"
    case breakingBubble = "Breaking out of my bubble"
    case knowingMore = "Knowing more than others"

    var id: String { rawValue }
    var displayText: String { rawValue }
}

// MARK: - Vocabulary Level

enum VocabularyLevel: String, Codable, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var id: String { rawValue }
    var displayText: String { rawValue }
}

// MARK: - Topic

enum Topic: String, Codable, CaseIterable, Identifiable {
    case society = "Society"
    case humanBody = "Human body"
    case emotions = "Emotions"
    case business = "Business"
    case other = "Other"

    var id: String { rawValue }
    var displayText: String { rawValue }
}

// MARK: - Voice Option

enum VoiceOption: String, Codable, CaseIterable, Identifiable {
    case brian = "Brian"
    case mia = "Mia"
    case amelia = "Amelia"
    case frederick = "Frederick"
    case paul = "Paul"
    case matilda = "Matilda"

    var id: String { rawValue }
    var displayText: String { rawValue }

    var accent: String {
        switch self {
        case .brian, .mia: return "American"
        case .amelia, .frederick: return "British"
        case .paul, .matilda: return "Australian"
        }
    }

    /// Maps to the best available AVSpeechSynthesis voice identifier.
    var voiceIdentifierPrefix: String {
        switch self {
        case .brian: return "com.apple.speech.synthesis.voice.Alex"
        case .mia: return "com.apple.speech.synthesis.voice.Samantha"
        case .amelia: return "com.apple.voice.compact.en-GB.Daniel"
        case .frederick: return "com.apple.voice.compact.en-GB.Daniel"
        case .paul: return "com.apple.voice.compact.en-AU.Karen"
        case .matilda: return "com.apple.voice.compact.en-AU.Karen"
        }
    }

    /// The BCP-47 language code for this voice.
    var languageCode: String {
        switch self {
        case .brian, .mia: return "en-US"
        case .amelia, .frederick: return "en-GB"
        case .paul, .matilda: return "en-AU"
        }
    }
}

// MARK: - App Theme

enum AppTheme: String, Codable, CaseIterable, Identifiable {
    case classic = "Classic"
    case dark = "Dark"
    case cozyWindow = "Cozy Window"
    case library = "Library"
    case studyRoom = "Study Room"
    case readingNook = "Reading Nook"

    var id: String { rawValue }
    var displayText: String { rawValue }

    /// Whether this theme uses a photo/gradient background on the home screen.
    var usesImageBackground: Bool {
        switch self {
        case .classic, .dark: return false
        case .cozyWindow, .library, .studyRoom, .readingNook: return true
        }
    }

    /// Whether text should be light-colored on this theme.
    var prefersDarkText: Bool {
        self == .classic
    }
}
