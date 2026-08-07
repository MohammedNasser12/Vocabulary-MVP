import SwiftUI

/// Vocabulary level selection — "What's your vocabulary level?"
///
/// Presents 3 level options. Auto-advances after selection.
struct VocabularyLevelView: View {

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
            Text("What's your vocabulary\nlevel?")
                .font(.appTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appText)
                .padding(.horizontal, Constants.horizontalPadding)

            Spacer()
                .frame(height: 28)

            // Options
            VStack(spacing: Constants.optionSpacing) {
                ForEach(VocabularyLevel.allCases) { level in
                    OptionRow(
                        title: level.displayText,
                        isSelected: viewModel.selectedVocabularyLevel == level
                    ) {
                        let isNewSelection = viewModel.selectedVocabularyLevel != level
                        viewModel.selectedVocabularyLevel = level
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
        VocabularyLevelView(viewModel: OnboardingViewModel())
    }
}
