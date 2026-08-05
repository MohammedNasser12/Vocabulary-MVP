import SwiftUI

/// Primary call-to-action button used throughout the app.
///
/// Matches the original app's distinctive embossed/3D teal button style with
/// a darker bottom border, rounded pill shape, and press animation.
///
/// Usage:
/// ```swift
/// PrimaryButton(title: "Get started") {
///     // action
/// }
/// ```
struct PrimaryButton: View {

    let title: String
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button {
            HapticService.shared.buttonPress()
            action()
        } label: {
            Text(title)
                .font(.appButton)
                .foregroundStyle(Color.appText)
                .frame(maxWidth: .infinity)
                .frame(height: Constants.buttonHeight)
                .background(
                    ZStack {
                        // Bottom shadow/border layer (creates the embossed look)
                        RoundedRectangle(cornerRadius: Constants.buttonCornerRadius)
                            .fill(Color.appTealDark.opacity(0.6))
                            .offset(y: 4)

                        // Main button surface
                        RoundedRectangle(cornerRadius: Constants.buttonCornerRadius)
                            .fill(Color.appTeal)

                        // Subtle inner highlight at top
                        RoundedRectangle(cornerRadius: Constants.buttonCornerRadius)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.2),
                                        Color.clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: Constants.buttonCornerRadius))
                // Dark outer border
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.buttonCornerRadius)
                        .stroke(Color.appBorder.opacity(0.8), lineWidth: 1.5)
                )
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

// MARK: - Scale Button Style

/// A button style that provides a subtle scale-down animation on press.
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(Constants.quickSpring, value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()

        VStack(spacing: 20) {
            PrimaryButton(title: "Get started") { }
            PrimaryButton(title: "Continue") { }
            PrimaryButton(title: "Save voice selection") { }
        }
    }
}
