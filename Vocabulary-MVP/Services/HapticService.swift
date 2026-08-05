import UIKit

/// Centralized haptic feedback service inspired by Supercell's tactile interactions.
///
/// Provides categorized haptic patterns for different interaction types,
/// ensuring consistent tactile feedback throughout the app.
final class HapticService {

    /// Shared singleton instance.
    static let shared = HapticService()

    // Pre-initialized generators for performance
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let rigidImpact = UIImpactFeedbackGenerator(style: .rigid)
    private let softImpact = UIImpactFeedbackGenerator(style: .soft)
    private let notificationGenerator = UINotificationFeedbackGenerator()

    private init() {
        // Prepare generators for immediate use
        selectionGenerator.prepare()
        lightImpact.prepare()
        mediumImpact.prepare()
    }

    // MARK: - Interaction Haptics

    /// Light selection tap — for option row selections.
    func selectionTap() {
        selectionGenerator.selectionChanged()
    }

    /// Medium impact — for button presses (CTA, action buttons).
    func buttonPress() {
        mediumImpact.impactOccurred()
    }

    /// Light impact — for card swipes and skip taps.
    func lightTap() {
        lightImpact.impactOccurred()
    }

    /// Rigid snap — for bookmark/save toggles.
    func snapFeedback() {
        rigidImpact.impactOccurred()
    }

    /// Soft impact — for voice preview playback.
    func softTap() {
        softImpact.impactOccurred()
    }

    // MARK: - Notification Haptics

    /// Success notification — for completing onboarding steps or daily words.
    func success() {
        notificationGenerator.notificationOccurred(.success)
    }

    /// Warning notification — for validation feedback.
    func warning() {
        notificationGenerator.notificationOccurred(.warning)
    }

    /// Error notification — for error states.
    func error() {
        notificationGenerator.notificationOccurred(.error)
    }

    // MARK: - Preparation

    /// Call before an anticipated interaction to reduce latency.
    func prepare() {
        selectionGenerator.prepare()
        mediumImpact.prepare()
        lightImpact.prepare()
        notificationGenerator.prepare()
    }
}
