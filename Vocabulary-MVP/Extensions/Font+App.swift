import SwiftUI

// MARK: - App Typography

extension Font {

    /// Large title for onboarding headings — bold serif.
    /// e.g. "Expand your Vocabulary in 1 minute a day"
    static let appLargeTitle = Font.system(size: 30, weight: .bold, design: .serif)

    /// Title for screen headings — bold serif.
    /// e.g. "How old are you?"
    static let appTitle = Font.system(size: 28, weight: .bold, design: .serif)

    /// Headline for card titles and word display.
    /// e.g. "ephemeral"
    static let appHeadline = Font.system(size: 24, weight: .bold, design: .serif)

    /// Large word display on home screen cards.
    /// e.g. "RETICENCE" on the word card
    static let appWordDisplay = Font.system(size: 32, weight: .bold, design: .serif)

    /// Body text for definitions and descriptions.
    static let appBody = Font.system(size: 17, weight: .regular, design: .default)

    /// Secondary body text for examples and details.
    static let appBodySecondary = Font.system(size: 16, weight: .regular, design: .default)

    /// Caption text for labels and hints.
    /// e.g. "Example", "Synonyms", "Origin"
    static let appCaption = Font.system(size: 13, weight: .regular, design: .default)

    /// Small caption for stat labels.
    static let appCaptionSmall = Font.system(size: 11, weight: .medium, design: .default)

    /// Button text — bold and prominent.
    static let appButton = Font.system(size: 18, weight: .bold, design: .default)

    /// Option row text.
    static let appOption = Font.system(size: 17, weight: .regular, design: .default)

    /// Phonetic pronunciation text.
    static let appPhonetic = Font.system(size: 15, weight: .regular, design: .default)

    /// Stats numbers.
    static let appStatNumber = Font.system(size: 22, weight: .bold, design: .rounded)

    /// Voice name in selection.
    static let appVoiceName = Font.system(size: 17, weight: .semibold, design: .default)

    /// Voice accent subtitle.
    static let appVoiceAccent = Font.system(size: 13, weight: .regular, design: .default)

    /// Skip button text.
    static let appSkip = Font.system(size: 16, weight: .regular, design: .default)
}
