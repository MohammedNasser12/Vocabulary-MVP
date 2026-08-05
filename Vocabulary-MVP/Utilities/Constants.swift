import SwiftUI

/// App-wide constants for consistent spacing, sizing, and layout.
enum Constants {

    // MARK: - Layout

    /// Standard horizontal padding for screen content.
    static let horizontalPadding: CGFloat = 24

    /// Padding between option rows.
    static let optionSpacing: CGFloat = 12

    /// Corner radius for option rows (pill shape).
    static let optionCornerRadius: CGFloat = 30

    /// Corner radius for the primary CTA button.
    static let buttonCornerRadius: CGFloat = 30

    /// Corner radius for cards and containers.
    static let cardCornerRadius: CGFloat = 16

    /// Corner radius for theme/icon grid items.
    static let gridItemCornerRadius: CGFloat = 14

    // MARK: - Sizing

    /// Height of the primary CTA button.
    static let buttonHeight: CGFloat = 58

    /// Height of an option row.
    static let optionRowHeight: CGFloat = 60

    /// Size of the radio circle in option rows.
    static let radioSize: CGFloat = 24

    /// Size of action buttons on the word card.
    static let actionButtonSize: CGFloat = 44

    /// Minimum tap target size (accessibility).
    static let minimumTapTarget: CGFloat = 44

    // MARK: - Animation

    /// Standard spring animation for UI interactions.
    static let springAnimation = Animation.spring(response: 0.35, dampingFraction: 0.7)

    /// Quick spring for button presses.
    static let quickSpring = Animation.spring(response: 0.25, dampingFraction: 0.8)

    /// Smooth ease for transitions.
    static let smoothTransition = Animation.easeInOut(duration: 0.3)

    /// Staggered delay between cascading animations.
    static let staggerDelay: TimeInterval = 0.05

    // MARK: - Word Cards

    /// Number of daily words to show.
    static let dailyWordCount: Int = 5

    /// Swipe threshold to trigger card transition.
    static let swipeThreshold: CGFloat = 100

    // MARK: - Onboarding

    /// Stat values displayed on the welcome screen.
    static let wordsLearnedStat = "350 million"
    static let appRating = "4.8"
    static let downloadsStat = "14 million"
}
