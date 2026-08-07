import SwiftUI

/// Curiosity driver selection — "What drives your curiosity?"
///
/// Presents 3 motivation options. Auto-advances after selection.
struct CuriosityDriverView: View {

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
            Text("What drives your\ncuriosity?")
                .font(.appTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appText)
                .padding(.horizontal, Constants.horizontalPadding)

            Spacer()
                .frame(height: 28)

            // Options
            VStack(spacing: Constants.optionSpacing) {
                ForEach(CuriosityDriver.allCases) { driver in
                    OptionRow(
                        title: driver.displayText,
                        isSelected: viewModel.selectedCuriosityDriver == driver
                    ) {
                        let isNewSelection = viewModel.selectedCuriosityDriver != driver
                        viewModel.selectedCuriosityDriver = driver
                        if isNewSelection { autoAdvance() }
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
        CuriosityDriverView(viewModel: OnboardingViewModel())
    }
}
