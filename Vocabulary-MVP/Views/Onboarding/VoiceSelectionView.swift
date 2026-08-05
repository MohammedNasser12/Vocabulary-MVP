import SwiftUI

/// Voice selection screen — "Choose a voice to pronounce words"
///
/// Displays 6 voice options (American, British, Australian) each with
/// a play button, waveform visualization, and accent label.
/// Users can preview each voice before confirming their selection.
struct VoiceSelectionView: View {

    @Bindable var viewModel: OnboardingViewModel
    @State private var playingVoice: VoiceOption?

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 24)

            // Title
            Text("Choose a voice to\npronounce words")
                .font(.appTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appText)
                .padding(.horizontal, Constants.horizontalPadding)

            Spacer()
                .frame(height: 24)

            // Voice options
            ScrollView(showsIndicators: false) {
                VStack(spacing: Constants.optionSpacing) {
                    ForEach(VoiceOption.allCases) { voice in
                        VoiceRow(
                            voice: voice,
                            isSelected: viewModel.selectedVoice == voice,
                            isPlaying: playingVoice == voice,
                            onSelect: {
                                viewModel.selectedVoice = voice
                            },
                            onPlay: {
                                playVoicePreview(voice)
                            }
                        )
                    }
                }
                .padding(.horizontal, Constants.horizontalPadding)
            }

            Spacer()

            // CTA
            PrimaryButton(title: "Save voice selection") {
                SpeechService.shared.stop()
                viewModel.advance()
            }
            .padding(.bottom, 40)
        }
    }

    // MARK: - Voice Preview

    private func playVoicePreview(_ voice: VoiceOption) {
        playingVoice = voice
        HapticService.shared.softTap()
        SpeechService.shared.speak("Ephemeral. Lasting for a very short time.", voice: voice)

        // Reset playing state after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if playingVoice == voice {
                playingVoice = nil
            }
        }
    }
}

// MARK: - Voice Row

/// An individual voice option row with play button, name, accent, and waveform.
private struct VoiceRow: View {

    let voice: VoiceOption
    let isSelected: Bool
    let isPlaying: Bool
    let onSelect: () -> Void
    let onPlay: () -> Void

    var body: some View {
        Button {
            HapticService.shared.selectionTap()
            onSelect()
        } label: {
            HStack(spacing: 12) {
                // Play button
                Button {
                    onPlay()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.appText)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color.appTeal.opacity(isPlaying ? 0.4 : 0.2))
                        )
                }
                .buttonStyle(.plain)

                // Name and accent
                VStack(alignment: .leading, spacing: 2) {
                    Text(voice.displayText)
                        .font(.appVoiceName)
                        .foregroundStyle(Color.appText)
                    Text(voice.accent)
                        .font(.appVoiceAccent)
                        .foregroundStyle(Color.appTextSecondary)
                }

                Spacer()

                // Waveform visualization
                waveformView
                    .frame(width: 80)

                // Radio indicator
                ZStack {
                    Circle()
                        .stroke(Color.appBorder.opacity(0.4), lineWidth: 1.5)
                        .frame(width: Constants.radioSize, height: Constants.radioSize)

                    if isSelected {
                        Circle()
                            .fill(Color.appTeal)
                            .frame(width: Constants.radioSize - 4, height: Constants.radioSize - 4)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(Constants.quickSpring, value: isSelected)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: Constants.optionCornerRadius)
                        .fill(Color.appBorder.opacity(0.15))
                        .offset(y: 4)

                    RoundedRectangle(cornerRadius: Constants.optionCornerRadius)
                        .fill(isSelected ? Color.appSelectedTint : Color.appOptionBackground)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: Constants.optionCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: Constants.optionCornerRadius)
                    .stroke(Color.appBorder.opacity(isSelected ? 0.6 : 0.35), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Waveform

    private var waveformView: some View {
        HStack(spacing: 2) {
            ForEach(0..<20, id: \.self) { index in
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.appText.opacity(isPlaying ? 0.5 : 0.2))
                    .frame(width: 2, height: barHeight(for: index))
                    .animation(
                        isPlaying
                            ? .easeInOut(duration: 0.3)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.05)
                            : .default,
                        value: isPlaying
                    )
            }
        }
        .frame(height: 20)
    }

    private func barHeight(for index: Int) -> CGFloat {
        // Create a natural waveform pattern
        let pattern: [CGFloat] = [4, 8, 6, 12, 8, 14, 10, 16, 12, 8, 14, 10, 18, 8, 12, 6, 14, 8, 10, 6]
        let height = pattern[index % pattern.count]
        return isPlaying ? height * 1.2 : height * 0.6
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        VoiceSelectionView(viewModel: OnboardingViewModel())
    }
}
