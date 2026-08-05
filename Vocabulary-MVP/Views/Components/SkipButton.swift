import SwiftUI

/// A "Skip" text button positioned in the top-right corner of skippable onboarding screens.
///
/// Usage:
/// ```swift
/// .toolbar {
///     ToolbarItem(placement: .topBarTrailing) {
///         SkipButton { viewModel.skip() }
///     }
/// }
/// ```
struct SkipButton: View {

    let action: () -> Void

    var body: some View {
        Button {
            HapticService.shared.lightTap()
            action()
        } label: {
            Text("Skip")
                .font(.appSkip)
                .foregroundStyle(Color.appText)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            Text("Skippable Screen")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                SkipButton { }
            }
        }
    }
}
