import SwiftUI

/// A rounded pill displaying phonetic pronunciation with a speaker button.
///
/// Adapts its appearance based on the current theme — semi-transparent on
/// dark/image backgrounds, or bordered on light backgrounds.
///
/// Usage:
/// ```swift
/// PhoneticPill(phonetic: "ɪˈfɛmərəl", useDarkStyle: false) {
///     SpeechService.shared.speak("ephemeral", voice: .brian)
/// }
/// ```
struct PhoneticPill: View {

    let phonetic: String
    let useDarkStyle: Bool
    let onPlayTapped: () -> Void

    var body: some View {
        Button {
            HapticService.shared.softTap()
            onPlayTapped()
        } label: {
            HStack(spacing: 8) {
                Text(phonetic)
                    .font(.appPhonetic)
                    .foregroundStyle(textColor)

                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(textColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(pillBackground)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Pronunciation: \(phonetic). Tap to hear.")
    }

    // MARK: - Private

    private var textColor: Color {
        useDarkStyle ? Color.appText : Color.white
    }

    @ViewBuilder
    private var pillBackground: some View {
        if useDarkStyle {
            Capsule()
                .stroke(Color.appBorderLight, lineWidth: 1)
                .background(
                    Capsule()
                        .fill(Color.appCardBackground.opacity(0.6))
                )
        } else {
            Color.white.opacity(0.2)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 30) {
        // Dark background variant
        ZStack {
            Color(red: 0.2, green: 0.3, blue: 0.25).ignoresSafeArea()
            PhoneticPill(phonetic: "ɪˈfɛmərəl", useDarkStyle: false) { }
        }
        .frame(height: 100)

        // Light background variant
        ZStack {
            Color.appBackground.ignoresSafeArea()
            PhoneticPill(phonetic: "ˈrɛtɪsəns", useDarkStyle: true) { }
        }
        .frame(height: 100)
    }
}
