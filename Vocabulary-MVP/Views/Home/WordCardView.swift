import SwiftUI

/// Full-screen word card with a **tap-to-reveal** learning interaction.
///
/// The card has two states:
/// 1. **Face** — Shows the word and phonetic only, prompting the user
///    to think about the meaning before revealing it.
/// 2. **Revealed** — Shows the definition and action buttons after the
///    user taps to reveal.
///
/// This creates the crucial "active recall" moment that transforms
/// passive reading into genuine learning.
struct WordCardView: View {

    let word: Word
    let theme: AppTheme
    let isFavorited: Bool
    let isBookmarked: Bool
    let onInfoTapped: () -> Void
    let onShareTapped: () -> Void
    let onFavoriteTapped: () -> Void
    let onBookmarkTapped: () -> Void
    let onSpeakTapped: () -> Void

    @State private var isVisible = false
    @State private var isRevealed = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Word content (always visible)
            faceContent
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 30)

            Spacer()
                .frame(height: 20)

            // Revealed content (definition + actions)
            if isRevealed {
                revealedContent
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .bottom)
                                .combined(with: .opacity),
                            removal: .opacity
                        )
                    )
            } else {
                revealHint
                    .opacity(isVisible ? 1 : 0)
                    .transition(.opacity)
            }

            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !isRevealed {
                revealDefinition()
            }
        }
        .onAppear {
            isVisible = false
            isRevealed = false
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) {
                isVisible = true
            }
        }
        .id(word.id) // Reset state when word changes
    }

    // MARK: - Face Content (Word + Phonetic)

    private var faceContent: some View {
        VStack(spacing: 16) {
            // Word name
            Text(word.text)
                .font(wordFont)
                .foregroundStyle(textColor)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .padding(.horizontal, Constants.horizontalPadding)

            // Phonetic pill
            PhoneticPill(
                phonetic: word.phonetic,
                useDarkStyle: theme.prefersDarkText
            ) {
                onSpeakTapped()
            }
        }
    }

    // MARK: - Reveal Hint

    private var revealHint: some View {
        VStack(spacing: 12) {
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 24))
                .foregroundStyle(textColor.opacity(0.35))
                .symbolEffect(.pulse, options: .repeating)

            Text("Tap to reveal definition")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(textColor.opacity(0.4))
        }
        .padding(.top, 8)
    }

    // MARK: - Revealed Content (Definition + Actions)

    private var revealedContent: some View {
        VStack(spacing: 20) {
            // Definition
            Text("(\(word.partOfSpeech)) \(word.definition)")
                .font(.appBody)
                .foregroundStyle(textColor.opacity(0.85))
                .multilineTextAlignment(.center)
                .padding(.horizontal, Constants.horizontalPadding + 8)

            // Action buttons
            actionButtons
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack(spacing: 32) {
            ActionButton(
                icon: "info.circle",
                useDarkStyle: theme.prefersDarkText
            ) {
                onInfoTapped()
            }

            ActionButton(
                icon: "square.and.arrow.up",
                useDarkStyle: theme.prefersDarkText
            ) {
                onShareTapped()
            }

            ActionButton(
                icon: "heart",
                activeIcon: "heart.fill",
                isActive: isFavorited,
                useDarkStyle: theme.prefersDarkText
            ) {
                onFavoriteTapped()
            }

            ActionButton(
                icon: "bookmark",
                activeIcon: "bookmark.fill",
                isActive: isBookmarked,
                useDarkStyle: theme.prefersDarkText
            ) {
                onBookmarkTapped()
            }
        }
    }

    // MARK: - Reveal Action

    private func revealDefinition() {
        HapticService.shared.lightTap()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isRevealed = true
        }
    }

    // MARK: - Helpers

    private var textColor: Color {
        Color.text(for: theme)
    }

    private var wordFont: Font {
        // Use smaller font for very long words
        if word.text.count > 15 {
            return .appHeadline
        }
        return .appWordDisplay
    }
}

// MARK: - Preview

#Preview("Unrevealed") {
    ZStack {
        LinearGradient.themeGradient(for: .cozyWindow)
            .ignoresSafeArea()

        WordCardView(
            word: Word(
                id: UUID(),
                text: "ephemeral",
                phonetic: "ɪˈfɛmərəl",
                partOfSpeech: "adj.",
                definition: "Lasting for a very short time",
                example: nil,
                synonyms: [],
                origin: nil,
                difficulty: .intermediate
            ),
            theme: .cozyWindow,
            isFavorited: false,
            isBookmarked: true,
            onInfoTapped: { },
            onShareTapped: { },
            onFavoriteTapped: { },
            onBookmarkTapped: { },
            onSpeakTapped: { }
        )
    }
}
