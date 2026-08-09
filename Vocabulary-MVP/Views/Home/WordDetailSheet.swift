import SwiftUI

/// Bottom sheet displaying detailed information about a vocabulary word.
///
/// Shows: word name, phonetic pronunciation, definition,
/// example sentence, synonyms (as tag chips), and word origin.
struct WordDetailSheet: View {

    let word: Word
    let voice: VoiceOption
    let useDarkStyle: Bool

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // Word name
                Text(word.text)
                    .font(.appHeadline)
                    .foregroundStyle(Color.appText)

                // Phonetic + speaker
                PhoneticPill(phonetic: word.phonetic, useDarkStyle: true) {
                    SpeechService.shared.speak(word.text, voice: voice)
                }

                // Definition
                Text("\(word.partOfSpeech) \(word.definition)")
                    .font(.appBody)
                    .foregroundStyle(Color.appText)

                // Example
                if let example = word.example {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Example")
                            .font(.appCaption)
                            .foregroundStyle(Color.appTextTertiary)

                        Text.highlightedExample(
                            sentence: example,
                            targetWord: word.text,
                            baseColor: Color.appText,
                            highlightColor: Color.appTealDark
                        )
                        .font(.appBody)
                        .italic()
                    }
                }

                // Synonyms
                if !word.synonyms.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Synonyms")
                            .font(.appCaption)
                            .foregroundStyle(Color.appTextTertiary)

                        FlowLayout(spacing: 8) {
                            ForEach(word.synonyms, id: \.self) { synonym in
                                Text(synonym)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color.appText)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(
                                        Capsule()
                                            .fill(Color.appBackground)
                                    )
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.appBorderLight, lineWidth: 1)
                                    )
                            }
                        }
                    }
                }

                // Origin
                if let origin = word.origin {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Origin")
                            .font(.appCaption)
                            .foregroundStyle(Color.appTextTertiary)

                        Text(origin)
                            .font(.appBody)
                            .foregroundStyle(Color.appText)
                    }
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.top, 16)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appCardBackground)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(24)
        .presentationBackground(Color.appCardBackground)
        .presentationContentInteraction(.scrolls)
    }
}

// MARK: - Flow Layout

/// A simple horizontal flow layout that wraps items to the next line.
struct FlowLayout: Layout {

    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(in: proposal.width ?? 0, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(in: bounds.width, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func layout(in availableWidth: CGFloat, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > availableWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            maxWidth = max(maxWidth, currentX - spacing)
        }

        return (
            size: CGSize(width: maxWidth, height: currentY + lineHeight),
            positions: positions
        )
    }
}

// MARK: - Preview

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            WordDetailSheet(
                word: Word(
                    id: UUID(),
                    text: "ephemeral",
                    phonetic: "ɪˈfɛmərəl",
                    partOfSpeech: "adj.",
                    definition: "Lasting for a very short time",
                    example: "The beauty of cherry blossoms is ephemeral, gone within a week.",
                    synonyms: ["fleeting", "transient", "short-lived"],
                    origin: "From Greek ephémeros, meaning \"lasting only a day.\"",
                    difficulty: .intermediate
                ),
                voice: .brian,
                useDarkStyle: true
            )
        }
}
