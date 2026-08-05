import SwiftUI

/// A selectable option row used across onboarding screens.
///
/// Recreates the original app's distinctive "clay/embossed" pill-shaped rows
/// with a thick dark bottom border, label on the left, and radio circle on the right.
/// Supports both single-select and multi-select modes.
///
/// Usage:
/// ```swift
/// OptionRow(title: "Beginner", isSelected: level == .beginner) {
///     level = .beginner
/// }
/// ```
struct OptionRow: View {

    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            HapticService.shared.selectionTap()
            action()
        } label: {
            HStack {
                Text(title)
                    .font(.appOption)
                    .foregroundStyle(Color.appText)

                Spacer()

                // Radio circle indicator
                ZStack {
                    Circle()
                        .stroke(Color.appBorder.opacity(0.4), lineWidth: 1.5)
                        .frame(width: Constants.radioSize, height: Constants.radioSize)

                    if isSelected {
                        Circle()
                            .fill(Color.appTeal)
                            .frame(width: Constants.radioSize - 4, height: Constants.radioSize - 4)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(Constants.quickSpring, value: isSelected)
            }
            .padding(.horizontal, 20)
            .frame(height: Constants.optionRowHeight)
            .background(
                ZStack {
                    // Bottom shadow layer (embossed effect)
                    RoundedRectangle(cornerRadius: Constants.optionCornerRadius)
                        .fill(Color.appBorder.opacity(0.15))
                        .offset(y: 4)

                    // Main surface
                    RoundedRectangle(cornerRadius: Constants.optionCornerRadius)
                        .fill(isSelected ? Color.appSelectedTint : Color.appOptionBackground)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: Constants.optionCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: Constants.optionCornerRadius)
                    .stroke(Color.appBorder.opacity(isSelected ? 0.6 : 0.35), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

// MARK: - Multi-Select Option Row

/// A variant of OptionRow that uses a checkmark instead of a radio circle,
/// suitable for multi-select screens like topic selection.
struct MultiSelectOptionRow: View {

    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            HapticService.shared.selectionTap()
            action()
        } label: {
            HStack {
                Text(title)
                    .font(.appOption)
                    .foregroundStyle(Color.appText)

                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color.appBorder.opacity(0.4), lineWidth: 1.5)
                        .frame(width: Constants.radioSize, height: Constants.radioSize)

                    if isSelected {
                        Circle()
                            .fill(Color.appTeal)
                            .frame(width: Constants.radioSize, height: Constants.radioSize)

                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.appText)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(Constants.quickSpring, value: isSelected)
            }
            .padding(.horizontal, 20)
            .frame(height: Constants.optionRowHeight)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: Constants.optionCornerRadius)
                        .fill(Color.appBorder.opacity(0.15))
                        .offset(y: 4)

                    RoundedRectangle(cornerRadius: Constants.optionCornerRadius)
                        .fill(isSelected ? Color.appSelectedTint : Color.appOptionBackground)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: Constants.optionCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: Constants.optionCornerRadius)
                    .stroke(Color.appBorder.opacity(isSelected ? 0.6 : 0.35), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()

        VStack(spacing: Constants.optionSpacing) {
            OptionRow(title: "Beginner", isSelected: false) { }
            OptionRow(title: "Intermediate", isSelected: true) { }
            OptionRow(title: "Advanced", isSelected: false) { }

            Divider().padding(.vertical)

            MultiSelectOptionRow(title: "Society", isSelected: true) { }
            MultiSelectOptionRow(title: "Business", isSelected: false) { }
        }
    }
}
