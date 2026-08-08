import SwiftUI

/// Post-onboarding splash screen — "Welcome to Vocabulary"
///
/// Displays over a blurred themed background with the app name in
/// large serif text and animated "Swipe" chevrons. Dismisses
/// on horizontal swipe to reveal the first word card, matching
/// the card-stack navigation direction.
struct WelcomeSplashView: View {

    let theme: AppTheme
    let userName: String?
    let onDismiss: () -> Void

    @State private var isVisible = false
    @State private var chevronOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Blurred themed background
            LinearGradient.themeGradient(for: theme)
                .ignoresSafeArea()
                .blur(radius: 10)
                .overlay(Color.black.opacity(0.2))

            // Content
            VStack(spacing: 16) {
                Spacer()

                // Welcome text
                VStack(spacing: 8) {
                    Text("Welcome to")
                        .font(.appBody)
                        .foregroundStyle(.white.opacity(0.8))

                    Text("Vocabulary")
                        .font(.system(size: 42, weight: .bold, design: .serif))
                        .foregroundStyle(.white)
                        .italic()
                }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)

                Spacer()

                // Swipe indicator (horizontal)
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.4))

                    Text("Swipe to start")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))

                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.4))
                }
                .offset(x: chevronOffset)
                .opacity(isVisible ? 1 : 0)
                .padding(.bottom, 60)
            }
            .offset(x: dragOffset)
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    dragOffset = value.translation.width * 0.5
                }
                .onEnded { value in
                    if abs(value.translation.width) > Constants.swipeThreshold {
                        // Dismiss with animation (slide in direction of swipe)
                        let direction: CGFloat = value.translation.width > 0 ? 1 : -1
                        withAnimation(.easeIn(duration: 0.3)) {
                            dragOffset = direction * UIScreen.main.bounds.width
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onDismiss()
                        }
                    } else {
                        // Snap back
                        withAnimation(Constants.springAnimation) {
                            dragOffset = 0
                        }
                    }
                }
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                isVisible = true
            }
            startChevronAnimation()
        }
    }

    // MARK: - Chevron Animation

    private func startChevronAnimation() {
        withAnimation(
            .easeInOut(duration: 1.2)
            .repeatForever(autoreverses: true)
        ) {
            chevronOffset = 6
        }
    }
}

// MARK: - Preview

#Preview {
    WelcomeSplashView(
        theme: .cozyWindow,
        userName: "Mohamed"
    ) { }
}
