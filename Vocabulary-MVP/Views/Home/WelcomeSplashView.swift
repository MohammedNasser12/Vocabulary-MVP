import SwiftUI

/// Post-onboarding splash screen — "Welcome to Vocabulary"
///
/// Displays over a blurred themed background with the app name in
/// large serif text and animated "Swipe up" chevrons. Dismisses
/// on swipe-up gesture to reveal the first word card.
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

                // Swipe up indicator
                VStack(spacing: 4) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))

                    Image(systemName: "chevron.up")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.4))

                    Text("Swipe up")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .offset(y: chevronOffset)
                .opacity(isVisible ? 1 : 0)
                .padding(.bottom, 60)
            }
            .offset(y: dragOffset)
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    // Only allow upward swipes
                    if value.translation.height < 0 {
                        dragOffset = value.translation.height * 0.5
                    }
                }
                .onEnded { value in
                    if value.translation.height < -Constants.swipeThreshold {
                        // Dismiss with animation
                        withAnimation(.easeIn(duration: 0.3)) {
                            dragOffset = -UIScreen.main.bounds.height
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
            chevronOffset = -8
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
