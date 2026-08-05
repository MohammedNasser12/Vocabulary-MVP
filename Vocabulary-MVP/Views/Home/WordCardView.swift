import SwiftUI

/// Full-screen word card displaying a vocabulary word over a themed background.
///
/// Shows the word name, phonetic pronunciation, definition, and
/// action buttons (info, share, favorite, bookmark).
/// Supports vertical swiping to navigate between words.
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

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Word content
            wordContent
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 30)

            Spacer()
                .frame(height: 24)

            // Action buttons
            actionButtons
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)

            Spacer()
        }
        .onAppear {
            isVisible = false
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) {
                isVisible = true
            }
        }
        .id(word.id) // Reset animation when word changes
    }

    // MARK: - Word Content

    private var wordContent: some View {
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

            // Definition
            Text("(\(word.partOfSpeech)) \(word.definition)")
                .font(.appBody)
                .foregroundStyle(textColor.opacity(0.85))
                .multilineTextAlignment(.center)
                .padding(.horizontal, Constants.horizontalPadding + 8)
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

#Preview {
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
