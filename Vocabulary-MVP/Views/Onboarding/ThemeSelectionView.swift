import SwiftUI

/// Theme selection screen — "Which theme would you like to start with?"
///
/// Displays a 3×2 grid of theme previews. This is the final onboarding step;
/// tapping Continue completes onboarding and transitions to the home screen.
struct ThemeSelectionView: View {

    @Bindable var viewModel: OnboardingViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 24)

            // Title
            Text("Which theme would\nyou like to start with?")
                .font(.appTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appText)
                .padding(.horizontal, Constants.horizontalPadding)

            Spacer()
                .frame(height: 32)

            // Theme grid
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(AppTheme.allCases) { theme in
                    ThemeGridItem(
                        theme: theme,
                        isSelected: viewModel.selectedTheme == theme
                    ) {
                        viewModel.selectedTheme = theme
                    }
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)

            Spacer()

            // CTA — this is the final step
            PrimaryButton(title: "Continue") {
                viewModel.completeOnboarding()
            }
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        ThemeSelectionView(viewModel: OnboardingViewModel())
    }
}
