import SwiftUI

/// Age selection screen — "How old are you?"
///
/// Presents 6 age range options in the standard OptionRow style.
/// Selecting an option auto-advances after a brief delay.
struct AgeSelectionView: View {

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
            Text("How old are you?")
                .font(.appTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appText)
                .padding(.horizontal, Constants.horizontalPadding)

            Spacer()
                .frame(height: 28)

            // Options
            VStack(spacing: Constants.optionSpacing) {
                ForEach(AgeRange.allCases) { age in
                    OptionRow(
                        title: age.displayText,
                        isSelected: viewModel.selectedAge == age
                    ) {
                        viewModel.selectedAge = age
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
        AgeSelectionView(viewModel: OnboardingViewModel())
    }
}
