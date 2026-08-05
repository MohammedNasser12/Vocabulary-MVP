import SwiftUI

// MARK: - App Color Palette

extension Color {

    // MARK: Backgrounds

    /// Warm beige background used throughout onboarding and classic theme.
    static let appBackground = Color(red: 0.96, green: 0.94, blue: 0.91)

    /// White card background for content cards.
    static let appCardBackground = Color.white

    // MARK: Brand Colors

    /// Primary teal used for CTA buttons.
    static let appTeal = Color(red: 0.66, green: 0.84, blue: 0.82)

    /// Darker teal for button borders and pressed states.
    static let appTealDark = Color(red: 0.50, green: 0.70, blue: 0.68)

    /// Coral/salmon accent used sparingly in illustrations.
    static let appCoral = Color(red: 0.93, green: 0.65, blue: 0.58)

    // MARK: Text Colors

    /// Primary text color (near-black).
    static let appText = Color(red: 0.10, green: 0.10, blue: 0.10)

    /// Secondary text color (medium gray).
    static let appTextSecondary = Color(red: 0.42, green: 0.42, blue: 0.42)

    /// Tertiary text color (light gray for captions).
    static let appTextTertiary = Color(red: 0.60, green: 0.60, blue: 0.60)

    // MARK: UI Elements

    /// Dark border color for option rows (the embossed look).
    static let appBorder = Color(red: 0.17, green: 0.17, blue: 0.17)

    /// Light border for cards and containers.
    static let appBorderLight = Color(red: 0.85, green: 0.85, blue: 0.85)

    /// Option row background (slightly lighter than main background).
    static let appOptionBackground = Color.white

    /// Selected option background tint.
    static let appSelectedTint = Color(red: 0.90, green: 0.96, blue: 0.95)

    // MARK: Theme-Specific Backgrounds

    /// Returns the appropriate background color for a given theme.
    static func background(for theme: AppTheme) -> Color {
        switch theme {
        case .classic:
            return .appBackground
        case .dark:
            return Color(red: 0.11, green: 0.11, blue: 0.12)
        case .cozyWindow, .library, .studyRoom, .readingNook:
            return .clear // These use gradient/image backgrounds
        }
    }

    /// Returns the appropriate text color for a given theme.
    static func text(for theme: AppTheme) -> Color {
        theme.prefersDarkText ? .appText : .white
    }
}

// MARK: - Theme Gradients

extension LinearGradient {

    /// Creates an atmospheric gradient for photo-style themes.
    static func themeGradient(for theme: AppTheme) -> LinearGradient {
        switch theme {
        case .classic:
            return LinearGradient(
                colors: [.appBackground],
                startPoint: .top,
                endPoint: .bottom
            )
        case .dark:
            return LinearGradient(
                colors: [
                    Color(red: 0.15, green: 0.15, blue: 0.17),
                    Color(red: 0.08, green: 0.08, blue: 0.10)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .cozyWindow:
            return LinearGradient(
                colors: [
                    Color(red: 0.35, green: 0.50, blue: 0.45),
                    Color(red: 0.20, green: 0.35, blue: 0.30),
                    Color(red: 0.15, green: 0.25, blue: 0.22)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .library:
            return LinearGradient(
                colors: [
                    Color(red: 0.25, green: 0.18, blue: 0.12),
                    Color(red: 0.15, green: 0.10, blue: 0.06),
                    Color(red: 0.10, green: 0.07, blue: 0.04)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .studyRoom:
            return LinearGradient(
                colors: [
                    Color(red: 0.30, green: 0.25, blue: 0.20),
                    Color(red: 0.20, green: 0.16, blue: 0.12),
                    Color(red: 0.12, green: 0.10, blue: 0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .readingNook:
            return LinearGradient(
                colors: [
                    Color(red: 0.40, green: 0.35, blue: 0.28),
                    Color(red: 0.25, green: 0.20, blue: 0.15),
                    Color(red: 0.15, green: 0.12, blue: 0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}
