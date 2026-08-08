import SwiftUI

/// Manages the home screen state including daily words, navigation,
/// favorites, bookmarks, and the "Word Mastery Pulse" completion state.
@Observable
final class HomeViewModel {

    // MARK: - Word State

    /// The set of daily words to display.
    private(set) var words: [Word] = []

    /// Index of the currently visible word card.
    var currentIndex: Int = 0

    // MARK: - Interaction State

    /// Set of favorited word IDs.
    var favoritedWordIDs: Set<UUID> = []

    /// Set of bookmarked/saved word IDs.
    var bookmarkedWordIDs: Set<UUID> = []

    /// User self-assessment ratings per word ID (Item B-1).
    var wordRatings: [UUID: WordRating] = [:]

    /// Whether the word detail sheet is presented.
    var isDetailSheetPresented = false

    /// Whether the share sheet is presented.
    var isSharePresented = false

    // MARK: - Welcome Splash

    /// Whether to show the welcome splash overlay.
    var showWelcomeSplash = true

    // MARK: - Mastery Pulse (UX Enhancement)

    /// Index of the segment that just completed (triggers pulse glow).
    var pulsingSegment: Int? = nil

    /// Whether all daily words have been viewed (triggers shimmer).
    var allWordsViewed = false

    /// Tracks which word indices have been viewed.
    private var viewedIndices: Set<Int> = []

    // MARK: - User Preferences

    /// The user's selected theme.
    private(set) var theme: AppTheme = .classic

    /// The user's selected voice.
    private(set) var voice: VoiceOption = .brian

    /// The user's display name.
    private(set) var userName: String?

    // MARK: - Initialization

    init() {
        loadPreferences()
        loadRatingsFromSRS()
        loadDailyWords()
    }

    // MARK: - Public API

    /// The currently displayed word.
    var currentWord: Word? {
        guard words.indices.contains(currentIndex) else { return nil }
        return words[currentIndex]
    }

    /// Total number of daily words.
    var totalWords: Int {
        words.count
    }

    /// Progress fraction (0.0 to 1.0).
    var progress: Double {
        guard totalWords > 0 else { return 0 }
        return Double(viewedIndices.count) / Double(totalWords)
    }

    /// Number of words viewed so far.
    var wordsViewedCount: Int {
        viewedIndices.count
    }

    /// Whether the given word is favorited.
    func isFavorited(_ word: Word) -> Bool {
        favoritedWordIDs.contains(word.id)
    }

    /// Whether the given word is bookmarked.
    func isBookmarked(_ word: Word) -> Bool {
        bookmarkedWordIDs.contains(word.id)
    }

    /// User self-assessment rating for a word if rated.
    func rating(for word: Word) -> WordRating? {
        wordRatings[word.id]
    }

    /// User-friendly label for next scheduled review (Item B-2).
    func nextReviewText(for word: Word) -> String? {
        SpacedRepetitionService.shared.record(for: word.id)?.formattedNextReview
    }

    // MARK: - Actions

    /// Rates a word, records SRS interval, and auto-advances after a short delay (Item B-1 & B-2).
    func rateWord(_ word: Word, rating: WordRating) {
        wordRatings[word.id] = rating

        // Persist spaced repetition schedule
        SpacedRepetitionService.shared.recordReview(for: word.id, rating: rating)

        switch rating {
        case .knewIt:
            HapticService.shared.success()
        case .learning:
            HapticService.shared.buttonPress()
        case .newWord:
            HapticService.shared.lightTap()
        }

        // Auto-advance to next word after rating selection
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            self?.goToNextWord()
        }
    }

    /// Toggles the favorite state for a word.
    func toggleFavorite(_ word: Word) {
        if favoritedWordIDs.contains(word.id) {
            favoritedWordIDs.remove(word.id)
        } else {
            favoritedWordIDs.insert(word.id)
        }
        HapticService.shared.snapFeedback()
    }

    /// Toggles the bookmark state for a word.
    func toggleBookmark(_ word: Word) {
        if bookmarkedWordIDs.contains(word.id) {
            bookmarkedWordIDs.remove(word.id)
        } else {
            bookmarkedWordIDs.insert(word.id)
        }
        HapticService.shared.snapFeedback()
    }

    /// Speaks the current word using the selected voice.
    func speakCurrentWord() {
        guard let word = currentWord else { return }
        SpeechService.shared.speak(word.text, voice: voice)
    }

    /// Shows the detail sheet for the current word.
    func showDetail() {
        HapticService.shared.lightTap()
        isDetailSheetPresented = true
    }

    /// Shows the share sheet.
    func showShare() {
        HapticService.shared.lightTap()
        isSharePresented = true
    }

    /// Navigates to the next word card.
    func goToNextWord() {
        guard currentIndex < words.count - 1 else { return }
        currentIndex += 1
        markCurrentWordViewed()
        HapticService.shared.lightTap()
    }

    /// Navigates to the previous word card.
    func goToPreviousWord() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        HapticService.shared.lightTap()
    }

    /// Marks the current word as viewed and triggers mastery pulse.
    func markCurrentWordViewed() {
        let previousCount = viewedIndices.count
        viewedIndices.insert(currentIndex)

        // Trigger pulse if this is a newly viewed word
        if viewedIndices.count > previousCount {
            triggerMasteryPulse()
        }
    }

    /// Dismisses the welcome splash.
    func dismissWelcomeSplash() {
        withAnimation(.easeInOut(duration: 0.5)) {
            showWelcomeSplash = false
        }
        // Mark the first word as viewed
        markCurrentWordViewed()
    }

    /// Generates share text for the current word.
    var shareText: String {
        guard let word = currentWord else { return "" }
        var text = "\(word.text) (\(word.partOfSpeech)) — \(word.definition)"
        if let example = word.example {
            text += "\n\nExample: \(example)"
        }
        text += "\n\n— Vocabulary App"
        return text
    }

    // MARK: - Private

    private func loadPreferences() {
        let prefs = PreferencesService.shared.load()
        theme = prefs.selectedTheme
        voice = prefs.selectedVoice
        userName = prefs.name
    }

    private func loadRatingsFromSRS() {
        let records = SpacedRepetitionService.shared.allRecords()
        for (id, record) in records {
            wordRatings[id] = record.rating
        }
    }

    private func loadDailyWords() {
        words = WordService.shared.dailyWords(count: Constants.dailyWordCount)
    }

    private func triggerMasteryPulse() {
        // Trigger segment pulse
        pulsingSegment = viewedIndices.count - 1

        // Clear pulse after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.pulsingSegment = nil
        }

        // Check for completion
        if viewedIndices.count >= totalWords {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.allWordsViewed = true
                HapticService.shared.success()
            }
        }
    }
}
