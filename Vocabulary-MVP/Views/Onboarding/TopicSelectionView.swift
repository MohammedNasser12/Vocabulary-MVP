import SwiftUI

/// Topic selection screen — "Which topics are you interested in?"
///
/// Unlike single-select screens, this uses multi-select checkmark rows.
/// Users can select multiple topics before tapping Continue.
struct TopicSelectionView: View {

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
            Text("Which topics are you\ninterested in?")
                .font(.appTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appText)
                .padding(.horizontal, Constants.horizontalPadding)

            Spacer()
                .frame(height: 28)

            // Options (multi-select)
            VStack(spacing: Constants.optionSpacing) {
                ForEach(Topic.allCases) { topic in
                    MultiSelectOptionRow(
                        title: topic.displayText,
                        isSelected: viewModel.isTopicSelected(topic)
                    ) {
                        viewModel.toggleTopic(topic)
                    }
                }
            }

            Spacer()

            // CTA
            PrimaryButton(title: "Continue") {
                viewModel.advance()
            }
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        TopicSelectionView(viewModel: OnboardingViewModel())
    }
}
