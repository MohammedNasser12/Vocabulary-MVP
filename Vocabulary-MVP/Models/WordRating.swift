import SwiftUI

/// Represents a user's self-assessment rating for a word after revealing its definition.
enum WordRating: String, Codable, CaseIterable, Identifiable {
    case knewIt = "knew_it"
    case learning = "learning"
    case newWord = "new"

    var id: String { rawValue }

    /// Human-readable label with icon/symbol.
    var label: String {
        switch self {
        case .knewIt: return "Knew it ✓"
        case .learning: return "Learning 📖"
        case .newWord: return "New ✨"
        }
    }

    /// Accent color associated with this rating state.
    var accentColor: Color {
        switch self {
        case .knewIt:
            return Color(red: 0.30, green: 0.70, blue: 0.50) // Emerald Green
        case .learning:
            return Color(red: 0.92, green: 0.65, blue: 0.30) // Amber Warmth
        case .newWord:
            return Color(red: 0.55, green: 0.50, blue: 0.85) // Lavender Violet
        }
    }
}
