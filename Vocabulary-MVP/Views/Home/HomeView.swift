import SwiftUI

/// Main home screen containing the word card swipe experience,
/// progress bar, custom tab bar, and optional welcome splash overlay.
///
/// Users swipe vertically to navigate between daily vocabulary words.
/// A custom tab bar at the bottom shows Words (active) and placeholder tabs.
struct HomeView: View {

    @State private var viewModel = HomeViewModel()
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Themed background
            themedBackground
                .ignoresSafeArea()

            // Main content
            VStack(spacing: 0) {
                // Top bar with progress
                topBar
                    .padding(.top, 8)

                // Word card area with swipe gesture
                wordCardArea
                    .frame(maxHeight: .infinity)

                // Custom tab bar
                customTabBar
            }

            // Welcome splash overlay
            if viewModel.showWelcomeSplash {
                WelcomeSplashView(
                    theme: viewModel.theme,
                    userName: viewModel.userName
                ) {
                    viewModel.dismissWelcomeSplash()
                }
                .transition(.opacity)
                .zIndex(10)
            }
        }
        .sheet(isPresented: $viewModel.isDetailSheetPresented) {
            if let word = viewModel.currentWord {
                WordDetailSheet(
                    word: word,
                    voice: viewModel.voice,
                    useDarkStyle: viewModel.theme.prefersDarkText
                )
            }
        }
        .sheet(isPresented: $viewModel.isSharePresented) {
            if !viewModel.shareText.isEmpty {
                ShareSheet(text: viewModel.shareText)
            }
        }
    }

    // MARK: - Themed Background

    @ViewBuilder
    private var themedBackground: some View {
        LinearGradient.themeGradient(for: viewModel.theme)
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Spacer()

            ProgressBarView(
                current: viewModel.wordsViewedCount,
                total: viewModel.totalWords,
                pulsingSegment: viewModel.pulsingSegment,
                allComplete: viewModel.allWordsViewed
            )
            .frame(maxWidth: 240)

            Spacer()

            // App logo/icon
            Image(systemName: "textformat.abc")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.text(for: viewModel.theme).opacity(0.7))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.6)
                )
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Word Card Area

    private var wordCardArea: some View {
        GeometryReader { geometry in
            ZStack {
                if let word = viewModel.currentWord {
                    WordCardView(
                        word: word,
                        theme: viewModel.theme,
                        isFavorited: viewModel.isFavorited(word),
                        isBookmarked: viewModel.isBookmarked(word),
                        onInfoTapped: { viewModel.showDetail() },
                        onShareTapped: { viewModel.showShare() },
                        onFavoriteTapped: { viewModel.toggleFavorite(word) },
                        onBookmarkTapped: { viewModel.toggleBookmark(word) },
                        onSpeakTapped: { viewModel.speakCurrentWord() }
                    )
                    .offset(y: dragOffset)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 30, coordinateSpace: .local)
                    .onChanged { value in
                        dragOffset = value.translation.height * 0.4
                    }
                    .onEnded { value in
                        handleSwipe(value: value, height: geometry.size.height)
                    }
            )
        }
    }

    // MARK: - Custom Tab Bar

    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabItem(icon: "house.fill", title: "Words", isActive: true)
            tabItem(icon: "square.grid.2x2", title: "Topics", isActive: false)
            tabItem(icon: "graduationcap.fill", title: "Practice", isActive: false)
            tabItem(icon: "chart.bar.fill", title: "Stats", isActive: false)
            tabItem(icon: "person", title: "Profile", isActive: false)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tabItem(icon: String, title: String, isActive: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(title)
                .font(.system(size: 10, weight: .medium))
        }
        .foregroundStyle(isActive ? Color.appText : Color.appTextTertiary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .accessibilityLabel(title)
        .accessibilityAddTraits(isActive ? .isSelected : [])
    }

    // MARK: - Swipe Handling

    private func handleSwipe(value: DragGesture.Value, height: CGFloat) {
        let threshold: CGFloat = Constants.swipeThreshold
        let velocity = value.predictedEndTranslation.height - value.translation.height

        if value.translation.height < -threshold || velocity < -threshold {
            // Swipe up → next word
            withAnimation(Constants.springAnimation) {
                dragOffset = 0
            }
            viewModel.goToNextWord()
        } else if value.translation.height > threshold || velocity > threshold {
            // Swipe down → previous word
            withAnimation(Constants.springAnimation) {
                dragOffset = 0
            }
            viewModel.goToPreviousWord()
        } else {
            // Snap back
            withAnimation(Constants.springAnimation) {
                dragOffset = 0
            }
        }
    }
}

// MARK: - Share Sheet

/// UIKit wrapper for the system share sheet.
struct ShareSheet: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview

#Preview {
    HomeView()
}
