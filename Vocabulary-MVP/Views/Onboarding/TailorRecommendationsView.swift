import SwiftUI

/// Motivational screen introducing the personalization flow.
///
/// Shows an illustration of a person climbing stairs toward a trophy,
/// with a "Continue" CTA to begin the tailoring questions.
struct TailorRecommendationsView: View {

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
                .frame(height: 40)

            // Headline
            Text("Tailor your word\nrecommendations")
                .font(.appTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appText)
                .opacity(isVisible ? 1 : 0)

            Spacer()

            // CTA
            PrimaryButton(title: "Continue") {
                viewModel.advance()
            }
            .padding(.bottom, 40)
            .opacity(isVisible ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.15)) {
                isVisible = true
            }
        }
    }

    // MARK: - Illustration

    private var illustrationArea: some View {
        ZStack {
            // Steps/stairs with person climbing
            VStack(spacing: 0) {
                // Trophy at top
                Image(systemName: "trophy.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.appTeal.opacity(0.7))
                    .offset(x: 40, y: 10)

                // Stairs visualization
                HStack(alignment: .bottom, spacing: 6) {
                    ForEach(0..<5) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.appText.opacity(0.75))
                            .frame(width: 36, height: CGFloat(30 + index * 28))
                    }
                }
                .frame(height: 170, alignment: .bottom)

                // Base
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.appCoral.opacity(0.3))
                    .frame(width: 220, height: 20)
            }

            // Person icon
            Image(systemName: "figure.walk")
                .font(.system(size: 36))
                .foregroundStyle(Color.appTeal.opacity(0.8))
                .offset(x: -60, y: 30)

            // Speech bubble accent
            Image(systemName: "text.bubble.fill")
                .font(.system(size: 28))
                .foregroundStyle(Color.appTeal.opacity(0.4))
                .offset(x: -70, y: -60)

            // Decorative dots
            Circle()
                .fill(Color.appTeal.opacity(0.3))
                .frame(width: 6, height: 6)
                .offset(x: 60, y: -80)

            Circle()
                .fill(Color.appCoral.opacity(0.4))
                .frame(width: 8, height: 8)
                .offset(x: 30, y: -90)
        }
        .frame(height: 240)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        TailorRecommendationsView(viewModel: OnboardingViewModel())
    }
}
