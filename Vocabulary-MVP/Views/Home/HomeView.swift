import SwiftUI

/// Main home screen with a **horizontal card-stack** swipe experience.
///
/// Replaces the original vertical scroll with a card-stack metaphor:
/// - Current card is centered at full scale
/// - Adjacent cards peek from the edges with reduced scale/opacity
/// - Horizontal swipe to navigate (left = next, right = previous)
/// - Subtle arrow indicators provide directional clarity
/// - A custom tab bar shows Words (active) and placeholder tabs
struct HomeView: View {

    @State private var viewModel = HomeViewModel()
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false

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

                // Card-stack area with horizontal swipe
                cardStackArea
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

    // MARK: - Card Stack Area

    private var cardStackArea: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width

            ZStack {
                // Render adjacent cards for the peek effect
                ForEach(visibleCardIndices, id: \.self) { index in
                    cardAtIndex(index, cardWidth: cardWidth)
                }

                // Navigation arrows (only when not dragging)
                if !isDragging {
                    navigationArrows
                }
            }
            .gesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onChanged { value in
                        isDragging = true
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        isDragging = false
                        handleHorizontalSwipe(value: value, cardWidth: cardWidth)
                    }
            )
        }
    }

    // MARK: - Card at Index

    @ViewBuilder
    private func cardAtIndex(_ index: Int, cardWidth: CGFloat) -> some View {
        if viewModel.words.indices.contains(index) {
            let word = viewModel.words[index]
            let offset = cardOffsetX(for: index, cardWidth: cardWidth)
            let scale = cardScale(for: index)
            let opacity = cardOpacity(for: index)

            WordCardView(
                word: word,
                theme: viewModel.theme,
                isFavorited: viewModel.isFavorited(word),
                isBookmarked: viewModel.isBookmarked(word),
                selectedRating: viewModel.rating(for: word),
                nextReviewText: viewModel.nextReviewText(for: word),
                onInfoTapped: { viewModel.showDetail() },
                onShareTapped: { viewModel.showShare() },
                onFavoriteTapped: { viewModel.toggleFavorite(word) },
                onBookmarkTapped: { viewModel.toggleBookmark(word) },
                onSpeakTapped: { viewModel.speakCurrentWord() },
                onRateTapped: { rating in viewModel.rateWord(word, rating: rating) }
            )
            .frame(width: cardWidth)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(x: offset)
            .zIndex(index == viewModel.currentIndex ? 1 : 0)
            .allowsHitTesting(index == viewModel.currentIndex)
        }
    }

    // MARK: - Navigation Arrows

    private var navigationArrows: some View {
        HStack {
            // Left arrow (previous)
            if viewModel.currentIndex > 0 {
                arrowButton(direction: .left) {
                    withAnimation(Constants.springAnimation) {
                        viewModel.goToPreviousWord()
                    }
                }
            }

            Spacer()

            // Right arrow (next)
            if viewModel.currentIndex < viewModel.totalWords - 1 {
                arrowButton(direction: .right) {
                    withAnimation(Constants.springAnimation) {
                        viewModel.goToNextWord()
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }

    private enum ArrowDirection {
        case left, right
    }

    private func arrowButton(direction: ArrowDirection, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: direction == .left ? "chevron.left" : "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.text(for: viewModel.theme).opacity(0.4))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.4)
                )
        }
        .accessibilityLabel(direction == .left ? "Previous word" : "Next word")
    }

    // MARK: - Card Stack Calculations

    /// Indices of cards to render (current ± 1 for performance).
    private var visibleCardIndices: [Int] {
        let indices = [viewModel.currentIndex - 1, viewModel.currentIndex, viewModel.currentIndex + 1]
        return indices.filter { viewModel.words.indices.contains($0) }
    }

    /// Horizontal offset for a card at the given index.
    private func cardOffsetX(for index: Int, cardWidth: CGFloat) -> CGFloat {
        let relativeIndex = CGFloat(index - viewModel.currentIndex)
        return relativeIndex * cardWidth + dragOffset
    }

    /// Scale factor for a card based on distance from center.
    private func cardScale(for index: Int) -> CGFloat {
        if index == viewModel.currentIndex {
            // Current card scales down slightly as it's dragged away
            let dragProgress = abs(dragOffset) / 300
            return max(1.0 - dragProgress * 0.05, 0.95)
        } else {
            // Adjacent cards are slightly smaller
            let dragProgress = abs(dragOffset) / 300
            return min(0.92 + dragProgress * 0.08, 1.0)
        }
    }

    /// Opacity for a card based on distance from center.
    private func cardOpacity(for index: Int) -> Double {
        if index == viewModel.currentIndex {
            return 1.0
        } else {
            // Adjacent cards are more transparent
            let dragProgress = abs(dragOffset) / 300
            return min(0.4 + dragProgress * 0.6, 1.0)
        }
    }

    // MARK: - Horizontal Swipe Handling

    private func handleHorizontalSwipe(value: DragGesture.Value, cardWidth: CGFloat) {
        let threshold: CGFloat = Constants.swipeThreshold
        let velocity = value.predictedEndTranslation.width - value.translation.width

        if value.translation.width < -threshold || velocity < -threshold {
            // Swipe left → next word
            withAnimation(Constants.springAnimation) {
                dragOffset = 0
            }
            viewModel.goToNextWord()
        } else if value.translation.width > threshold || velocity > threshold {
            // Swipe right → previous word
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
