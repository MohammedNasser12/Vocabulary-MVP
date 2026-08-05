import SwiftUI

/// The landing screen — first thing users see when opening the app.
///
/// Displays the app's value proposition with an illustration area,
/// headline, social proof stats, and "Get started" CTA.
struct WelcomeView: View {

    let viewModel: OnboardingViewModel

    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Illustration area
            illustrationArea
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)

            Spacer()
                .frame(height: 32)

            // Headline
            VStack(spacing: 12) {
                Text("Expand your Vocabulary\nin 1 minute a day")
                    .font(.appTitle)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.appText)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 15)

                Text("Learn 10,000+ new words with a new daily habit that\ntakes just 1 minute")
                    .font(.appBodySecondary)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.appTextSecondary)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 10)
            }

            Spacer()
                .frame(height: 36)

            // Social proof stats
            statsRow
                .opacity(isVisible ? 1 : 0)

            Spacer()

            // CTA button
            PrimaryButton(title: "Get started") {
                viewModel.advance()
            }
            .padding(.bottom, 40)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.1)) {
                isVisible = true
            }
        }
    }

    // MARK: - Illustration

    private var illustrationArea: some View {
        ZStack {
            // Stylized book stack with people illustration
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.appCoral.opacity(0.15))
                .frame(width: 260, height: 200)
                .overlay(
                    VStack(spacing: 8) {
                        // Books stack
                        HStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.appCoral.opacity(0.4))
                                .frame(width: 80, height: 20)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.appTeal.opacity(0.5))
                                .frame(width: 80, height: 20)
                        }

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.appText.opacity(0.1))
                            .frame(width: 160, height: 16)

                        // Speech bubble
                        Image(systemName: "text.bubble.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.appTeal.opacity(0.6))

                        // People silhouettes
                        HStack(spacing: 30) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.appText.opacity(0.3))
                            Image(systemName: "person.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.appTeal.opacity(0.5))
                            Image(systemName: "person.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.appCoral.opacity(0.5))
                        }
                    }
                )
        }
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: 0) {
            statItem(value: Constants.wordsLearnedStat, label: "words learned")

            // Laurel divider
            Image(systemName: "laurel.leading")
                .font(.system(size: 14))
                .foregroundStyle(Color.appTextTertiary)
                .padding(.horizontal, 4)

            statItem(value: Constants.appRating, label: "★★★★★")

            Image(systemName: "laurel.trailing")
                .font(.system(size: 14))
                .foregroundStyle(Color.appTextTertiary)
                .padding(.horizontal, 4)

            statItem(value: Constants.downloadsStat, label: "downloads")
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.appText)
            Text(label)
                .font(.appCaptionSmall)
                .foregroundStyle(Color.appTextSecondary)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        WelcomeView(viewModel: OnboardingViewModel())
    }
}
