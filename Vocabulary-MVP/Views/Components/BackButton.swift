import SwiftUI

/// A back navigation button for onboarding screens.
///
/// Displays a left-pointing chevron in the top-left corner.
/// Provides haptic feedback on tap.
///
/// Usage:
/// ```swift
/// BackButton { viewModel.goBack() }
/// ```
struct BackButton: View {

    let action: () -> Void

    var body: some View {
        Button {
            HapticService.shared.lightTap()
            action()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color.appText)
                .frame(width: Constants.minimumTapTarget, height: Constants.minimumTapTarget)
                .contentShape(Rectangle())
        }
        .accessibilityLabel("Go back")
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        HStack {
            BackButton { }
            Spacer()
            SkipButton { }
        }
        .padding(.horizontal, 16)
    }
}
