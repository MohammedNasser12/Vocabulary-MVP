import SwiftUI

/// Icon-based action button used on the home screen word cards.
///
/// Supports toggle states (e.g., heart filled/unfilled) and provides
/// haptic feedback on interaction. Adapts color based on theme.
///
/// Usage:
/// ```swift
/// ActionButton(
///     icon: "heart",
///     activeIcon: "heart.fill",
///     isActive: isFavorited,
///     useDarkStyle: theme.prefersDarkText
/// ) {
///     isFavorited.toggle()
/// }
/// ```
struct ActionButton: View {

    let icon: String
    let activeIcon: String?
    let isActive: Bool
    let useDarkStyle: Bool
    let action: () -> Void

    /// Creates an action button.
    /// - Parameters:
    ///   - icon: SF Symbol name for the default state.
    ///   - activeIcon: SF Symbol name for the active/toggled state. Pass nil for non-toggleable buttons.
    ///   - isActive: Whether the button is in its active state.
    ///   - useDarkStyle: Whether to use dark-colored icons (for light backgrounds).
    ///   - action: The action to perform on tap.
    init(
        icon: String,
        activeIcon: String? = nil,
        isActive: Bool = false,
        useDarkStyle: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.activeIcon = activeIcon
        self.isActive = isActive
        self.useDarkStyle = useDarkStyle
        self.action = action
    }

    var body: some View {
        Button {
            if activeIcon != nil {
                HapticService.shared.snapFeedback()
            } else {
                HapticService.shared.lightTap()
            }
            action()
        } label: {
            Image(systemName: currentIcon)
                .font(.system(size: 22))
                .foregroundStyle(iconColor)
                .frame(width: Constants.actionButtonSize, height: Constants.actionButtonSize)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibilityLabel(accessibilityText)
    }

    // MARK: - Private

    private var currentIcon: String {
        if isActive, let activeIcon {
            return activeIcon
        }
        return icon
    }

    private var iconColor: Color {
        if isActive && activeIcon != nil {
            return Color.appTeal
        }
        return useDarkStyle ? Color.appText.opacity(0.8) : Color.white.opacity(0.9)
    }

    private var accessibilityText: String {
        let baseName = icon.replacingOccurrences(of: ".", with: " ")
        return isActive ? "\(baseName) active" : baseName
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color(red: 0.2, green: 0.3, blue: 0.25).ignoresSafeArea()

        HStack(spacing: 24) {
            ActionButton(icon: "info.circle", action: { })
            ActionButton(icon: "square.and.arrow.up", action: { })
            ActionButton(
                icon: "heart",
                activeIcon: "heart.fill",
                isActive: true,
                action: { }
            )
            ActionButton(
                icon: "bookmark",
                activeIcon: "bookmark.fill",
                isActive: false,
                action: { }
            )
        }
    }
}
