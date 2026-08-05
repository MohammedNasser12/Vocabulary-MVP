import SwiftUI

/// Gender selection screen — "Which option represents you best?"
///
/// Presents gender options in the standard OptionRow style.
/// Auto-advances after selection.
struct GenderSelectionView: View {

    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Skip button
            HStack {
                Spacer()
                SkipButton { viewModel.skip() }
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.top, 8)

            Spacer()
                .frame(height: 16)

            // Title
            Text("Which option represents\nyou best?")
                .font(.appTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appText)
                .padding(.horizontal, Constants.horizontalPadding)

            Spacer()
                .frame(height: 28)

            // Options
            VStack(spacing: Constants.optionSpacing) {
                ForEach(Gender.allCases) { gender in
                    OptionRow(
                        title: gender.displayText,
                        isSelected: viewModel.selectedGender == gender
                    ) {
                        viewModel.selectedGender = gender
                        autoAdvance()
                    }
                }
            }

            Spacer()
        }
    }

    private func autoAdvance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            viewModel.advance()
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        GenderSelectionView(viewModel: OnboardingViewModel())
    }
}
