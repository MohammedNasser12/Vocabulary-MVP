import Foundation

/// Provides vocabulary word data from the bundled JSON resource.
final class WordService {

    /// Shared singleton instance.
    static let shared = WordService()

    /// All available words loaded from the bundle.
    private(set) var allWords: [Word] = []

    private init() {
        loadWords()
    }

    // MARK: - Public API

    /// Returns a set of daily words for the home screen.
    /// - Parameter count: Number of words to return (default: 5).
    /// - Returns: An array of words, shuffled for variety.
    func dailyWords(count: Int = Constants.dailyWordCount) -> [Word] {
        // Use the current date as a seed for consistent daily shuffle
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let daySeed = (components.year ?? 0) * 10000 + (components.month ?? 0) * 100 + (components.day ?? 0)

        var generator = SeededRandomNumberGenerator(seed: UInt64(daySeed))
        let shuffled = allWords.shuffled(using: &generator)
        return Array(shuffled.prefix(count))
    }

    /// Returns words filtered by difficulty level.
    func words(for difficulty: Word.Difficulty) -> [Word] {
        allWords.filter { $0.difficulty == difficulty }
    }

    // MARK: - Private

    private func loadWords() {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json") else {
            assertionFailure("words.json not found in bundle")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            allWords = try decoder.decode([Word].self, from: data)
        } catch {
            assertionFailure("Failed to decode words.json: \(error)")
        }
    }
}

// MARK: - Seeded Random Number Generator

/// A deterministic random number generator for consistent daily word sets.
private struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        // xorshift64 algorithm
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}
