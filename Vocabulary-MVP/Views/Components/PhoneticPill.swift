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

    @State private var isPlaying = false
    @State private var waveAnim = false

    var body: some View {
        Button {
            HapticService.shared.softTap()
            triggerPlayAnimation()
            onPlayTapped()
        } label: {
            HStack(spacing: 8) {
                Text(phonetic)
                    .font(.appPhonetic)
                    .foregroundStyle(textColor)

                if isPlaying {
                    // Animated Sound Waveform Bars
                    HStack(spacing: 2.5) {
                        ForEach(0..<3, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 1)
                                .fill(textColor)
                                .frame(width: 2.5, height: waveAnim ? CGFloat([14, 8, 12][index]) : 6)
                                .animation(
                                    .easeInOut(duration: 0.3)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.1),
                                    value: waveAnim
                                )
                        }
                    }
                    .frame(height: 14)
                    .transition(.scale.combined(with: .opacity))
                } else {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(textColor)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(pillBackground)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(textColor.opacity(isPlaying ? 0.5 : 0), lineWidth: 1.5)
                    .scaleEffect(isPlaying ? 1.15 : 1.0)
                    .opacity(isPlaying ? 0 : 0.8)
                    .animation(isPlaying ? .easeOut(duration: 0.75).repeatForever(autoreverses: false) : .default, value: isPlaying)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Pronunciation: \(phonetic). Tap to hear.")
        .onAppear {
            SpeechService.shared.onSpeechStateChanged = { speaking in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPlaying = speaking
                    waveAnim = speaking
                }
            }
        }
    }

    private func triggerPlayAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isPlaying = true
            waveAnim = true
        }

        // Safety fallback timer to end animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                if !SpeechService.shared.isSpeaking {
                    isPlaying = false
                    waveAnim = false
                }
            }
        }
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
