import SwiftUI

/// A grid cell for theme selection during onboarding.
///
/// Displays a preview of the theme (color/gradient) with an "Aa" label
/// and shows a checkmark badge when selected.
///
/// Usage:
/// ```swift
/// ThemeGridItem(theme: .cozyWindow, isSelected: selectedTheme == .cozyWindow) {
///     selectedTheme = .cozyWindow
/// }
/// ```
struct ThemeGridItem: View {

    let theme: AppTheme
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            HapticService.shared.selectionTap()
            action()
        } label: {
            ZStack(alignment: .topTrailing) {
                // Theme preview
                themePreview
                    .frame(maxWidth: .infinity)
                    .aspectRatio(0.8, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.gridItemCornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.gridItemCornerRadius)
                            .stroke(
                                isSelected ? Color.appTeal : Color.appBorderLight,
                                lineWidth: isSelected ? 2.5 : 1
                            )
                    )

                // Selection checkmark badge
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.appTeal)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 18, height: 18)
                        )
                        .offset(x: 4, y: -4)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(Constants.quickSpring, value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(theme.displayText) theme\(isSelected ? ", selected" : "")")
    }

    // MARK: - Theme Preview

    @ViewBuilder
    private var themePreview: some View {
        ZStack {
            themeBackground

            Text("Aa")
                .font(.system(size: 28, weight: .medium, design: theme == .classic ? .serif : .default))
                .foregroundStyle(theme.prefersDarkText ? Color.appText : Color.white)
        }
    }

    @ViewBuilder
    private var themeBackground: some View {
        switch theme {
        case .classic:
            Color.appBackground

        case .dark:
            Color(red: 0.11, green: 0.11, blue: 0.12)

        case .cozyWindow:
            LinearGradient(
                colors: [
                    Color(red: 0.35, green: 0.55, blue: 0.50),
                    Color(red: 0.20, green: 0.38, blue: 0.33),
                    Color(red: 0.12, green: 0.22, blue: 0.20)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .library:
            LinearGradient(
                colors: [
                    Color(red: 0.30, green: 0.20, blue: 0.14),
                    Color(red: 0.18, green: 0.12, blue: 0.08),
                    Color(red: 0.10, green: 0.07, blue: 0.04)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .studyRoom:
            LinearGradient(
                colors: [
                    Color(red: 0.38, green: 0.30, blue: 0.22),
                    Color(red: 0.22, green: 0.18, blue: 0.14),
                    Color(red: 0.14, green: 0.10, blue: 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .readingNook:
            LinearGradient(
                colors: [
                    Color(red: 0.45, green: 0.38, blue: 0.30),
                    Color(red: 0.28, green: 0.22, blue: 0.18),
                    Color(red: 0.15, green: 0.12, blue: 0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()

        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            ForEach(AppTheme.allCases) { theme in
                ThemeGridItem(
                    theme: theme,
                    isSelected: theme == .classic
                ) { }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }
}
