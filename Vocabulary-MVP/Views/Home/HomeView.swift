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
        .sheet(isPresented: $viewModel.isSettingsPresented) {
            SettingsView(
                preferences: PreferencesService.shared.load(),
                onPreferencesChanged: { prefs in
                    viewModel.updatePreferences(prefs)
                },
                onResetProgress: {
                    viewModel.resetProgress()
                }
            )
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

            // Settings gear button
            Button {
                viewModel.showSettings()
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.text(for: viewModel.theme).opacity(0.85))
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .opacity(0.6)
                    )
            }
            .accessibilityLabel("Settings")
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Card Stack Area

    private var cardStackArea: some View {
        ZStack {
            TabView(selection: $viewModel.currentIndex) {
                ForEach(Array(viewModel.words.enumerated()), id: \.element.id) { index, word in
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
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: viewModel.currentIndex) { _ in
                viewModel.markCurrentWordViewed()
            }

            // Navigation arrows
            navigationArrows
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

    // MARK: - Custom Tab Bar

    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabItem(icon: "house.fill", title: "Words", isActive: true, action: nil)
            tabItem(icon: "square.grid.2x2", title: "Topics", isActive: false, action: nil)
            tabItem(icon: "graduationcap.fill", title: "Practice", isActive: false, action: nil)
            tabItem(icon: "chart.bar.fill", title: "Stats", isActive: false, action: nil)
            tabItem(icon: "gearshape.fill", title: "Settings", isActive: false) {
                viewModel.showSettings()
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tabItem(icon: String, title: String, isActive: Bool, action: (() -> Void)?) -> some View {
        Button {
            action?()
        } label: {
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
        }
        .buttonStyle(.plain)
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
