import SwiftUI

/// Badge view for displaying part of speech and difficulty level pills with distinct color-coding.
struct WordBadgeView: View {

    let partOfSpeech: String
    let difficulty: Word.Difficulty
    let useDarkStyle: Bool

    var body: some View {
        HStack(spacing: 8) {
            // Part of Speech Pill
            badgePill(
                icon: "circle.fill",
                iconIsDot: true,
                text: partOfSpeech.trimmingCharacters(in: .whitespacesAndNewlines),
                color: posColor
            )

            // Difficulty Level Pill
            badgePill(
                icon: difficultyIcon,
                iconIsDot: false,
                text: difficultyText,
                color: difficultyColor
            )
        }
    }

    private func badgePill(icon: String, iconIsDot: Bool, text: String, color: Color) -> some View {
        HStack(spacing: 5) {
            if iconIsDot {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
            } else {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(color)
            }

            Text(text)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(color.opacity(0.18))
        )
        .background(
            Capsule()
                .fill(useDarkStyle ? Color.white.opacity(0.9) : Color.black.opacity(0.35))
        )
        .overlay(
            Capsule()
                .stroke(color.opacity(0.45), lineWidth: 1.2)
        )
    }

    private var posColor: Color {
        let pos = partOfSpeech.lowercased()
        if pos.contains("noun") || pos == "n." {
            return useDarkStyle ? Color(red: 0.35, green: 0.25, blue: 0.75) : Color(red: 0.65, green: 0.55, blue: 0.98) // Indigo / Violet
        } else if pos.contains("adj") {
            return useDarkStyle ? Color(red: 0.05, green: 0.52, blue: 0.45) : Color(red: 0.35, green: 0.85, blue: 0.78) // Emerald Teal
        } else if pos.contains("verb") || pos == "v." {
            return useDarkStyle ? Color(red: 0.80, green: 0.20, blue: 0.25) : Color(red: 0.98, green: 0.45, blue: 0.50) // Crimson
        } else if pos.contains("adv") {
            return useDarkStyle ? Color(red: 0.78, green: 0.45, blue: 0.10) : Color(red: 0.98, green: 0.70, blue: 0.25) // Amber
        } else {
            return useDarkStyle ? Color(red: 0.35, green: 0.45, blue: 0.55) : Color(red: 0.70, green: 0.80, blue: 0.90) // Slate
        }
    }

    private var difficultyColor: Color {
        switch difficulty {
        case .beginner:
            return useDarkStyle ? Color(red: 0.12, green: 0.55, blue: 0.28) : Color(red: 0.40, green: 0.88, blue: 0.55) // Mint Green
        case .intermediate:
            return useDarkStyle ? Color(red: 0.10, green: 0.45, blue: 0.78) : Color(red: 0.38, green: 0.75, blue: 0.98) // Ocean Blue
        case .advanced:
            return useDarkStyle ? Color(red: 0.60, green: 0.22, blue: 0.65) : Color(red: 0.85, green: 0.50, blue: 0.90) // Amethyst Purple
        }
    }

    private var difficultyText: String {
        switch difficulty {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }

    private var difficultyIcon: String {
        switch difficulty {
        case .beginner: return "leaf.fill"
        case .intermediate: return "chart.bar.fill"
        case .advanced: return "crown.fill"
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        WordBadgeView(partOfSpeech: "adj.", difficulty: .intermediate, useDarkStyle: true)
        WordBadgeView(partOfSpeech: "noun", difficulty: .advanced, useDarkStyle: true)
        WordBadgeView(partOfSpeech: "verb", difficulty: .beginner, useDarkStyle: true)
    }
    .padding()
}
