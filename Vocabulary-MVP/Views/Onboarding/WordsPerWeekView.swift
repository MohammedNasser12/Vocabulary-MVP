import SwiftUI

/// Words per week selection — "How many words do you want to learn per week?"
///
/// Presents 3 learning intensity options. Auto-advances after selection.
struct WordsPerWeekView: View {

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
            Text("How many words do you\nwant to learn per week?")
                .font(.appTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appText)
                .padding(.horizontal, Constants.horizontalPadding)

            Spacer()
                .frame(height: 28)

            // Options
            VStack(spacing: Constants.optionSpacing) {
                ForEach(WordsPerWeek.allCases) { option in
                    OptionRow(
                        title: option.displayText,
                        isSelected: viewModel.selectedWordsPerWeek == option
                    ) {
                        let isNewSelection = viewModel.selectedWordsPerWeek != option
                        viewModel.selectedWordsPerWeek = option
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
        WordsPerWeekView(viewModel: OnboardingViewModel())
    }
}
