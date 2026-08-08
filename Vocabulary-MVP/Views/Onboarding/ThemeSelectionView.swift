import SwiftUI

/// Theme selection screen — "Which theme would you like to start with?"
///
/// Displays a 3×2 grid of theme previews with a **live preview card**
/// below that shows exactly how a word will look in the selected theme.
/// This is the final onboarding step; tapping Continue completes onboarding.
struct ThemeSelectionView: View {

    @Bindable var viewModel: OnboardingViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    /// Sample word used in the live preview.
    private let previewWord = (text: "ephemeral", phonetic: "ɪˈfɛmərəl", definition: "adj. Lasting for a very short time")

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
                .frame(height: 24)

            // Theme grid
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(AppTheme.allCases) { theme in
                    ThemeGridItem(
                        theme: theme,
                        isSelected: viewModel.selectedTheme == theme
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.selectedTheme = theme
                        }
                    }
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)

            Spacer()
                .frame(height: 24)

            // Live preview card
            livePreviewCard
                .padding(.horizontal, Constants.horizontalPadding)
                .animation(.easeInOut(duration: 0.3), value: viewModel.selectedTheme)

            Spacer()

            // CTA — this is the final step
            PrimaryButton(title: "Continue") {
                viewModel.completeOnboarding()
            }
            .padding(.bottom, 40)
        }
    }

    // MARK: - Live Preview Card

    private var livePreviewCard: some View {
        let theme = viewModel.selectedTheme
        let textColor = Color.text(for: theme)

        return VStack(spacing: 0) {
            // "Preview" label
            HStack {
                Text("PREVIEW")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.appTextTertiary)
                    .tracking(1.2)
                Spacer()
            }
            .padding(.bottom, 8)

            // Card preview
            VStack(spacing: 12) {
                // Progress bar preview
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index < 2 ? Color.white.opacity(0.9) : Color.white.opacity(0.3))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer()
                    .frame(height: 8)

                // Word
                Text(previewWord.text)
                    .font(.system(size: 22, weight: .bold, design: .serif))
                    .foregroundStyle(textColor)

                // Phonetic pill
                Text(previewWord.phonetic)
                    .font(.system(size: 12))
                    .foregroundStyle(textColor.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(textColor.opacity(0.1))
                    )

                // Definition
                Text(previewWord.definition)
                    .font(.system(size: 13))
                    .foregroundStyle(textColor.opacity(0.7))
                    .multilineTextAlignment(.center)

                Spacer()
                    .frame(height: 4)

                // Action buttons preview
                HStack(spacing: 20) {
                    Image(systemName: "info.circle")
                    Image(systemName: "square.and.arrow.up")
                    Image(systemName: "heart")
                    Image(systemName: "bookmark")
                }
                .font(.system(size: 16))
                .foregroundStyle(textColor.opacity(0.5))
                .padding(.bottom, 16)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(
                RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                    .fill(.clear)
                    .overlay(
                        LinearGradient.themeGradient(for: theme)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cardCornerRadius))
            )
            .overlay(
                RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                    .stroke(Color.appBorderLight.opacity(0.5), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: Constants.cardCornerRadius))
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
