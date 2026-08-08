import Foundation

/// Manages spaced repetition review schedules based on user ratings.
final class SpacedRepetitionService {

    /// Shared singleton instance.
    static let shared = SpacedRepetitionService()

    private let defaults = UserDefaults.standard
    private let recordsKey = "com.vocabulary.spacedRepetitionRecords"

    private init() {}

    // MARK: - Public API

    /// Retrieves all review records.
    func allRecords() -> [UUID: ReviewRecord] {
        guard let data = defaults.data(forKey: recordsKey),
              let records = try? JSONDecoder().decode([UUID: ReviewRecord].self, from: data) else {
            return [:]
        }
        return records
    }

    /// Gets the review record for a specific word.
    func record(for wordID: UUID) -> ReviewRecord? {
        allRecords()[wordID]
    }

    /// Records a new review rating and calculates the next review date.
    @discardableResult
    func recordReview(for wordID: UUID, rating: WordRating) -> ReviewRecord {
        var records = allRecords()
        let now = Date()

        let existing = records[wordID]
        let currentReps = existing?.repetitionCount ?? 0
        let currentInterval = existing?.intervalDays ?? 1

        let newReps: Int
        let newIntervalDays: Int

        switch rating {
        case .knewIt:
            newReps = currentReps + 1
            switch newReps {
            case 1:
                newIntervalDays = 3
            case 2:
                newIntervalDays = 7
            case 3:
                newIntervalDays = 14
            default:
                newIntervalDays = min(currentInterval * 2, 60)
            }

        case .learning:
            newReps = 1
            newIntervalDays = 2

        case .newWord:
            newReps = 0
            newIntervalDays = 1
        }

        let nextReviewDate = Calendar.current.date(byAdding: .day, value: newIntervalDays, to: now) ?? now

        let updatedRecord = ReviewRecord(
            wordID: wordID,
            rating: rating,
            lastReviewedAt: now,
            nextReviewDate: nextReviewDate,
            repetitionCount: newReps,
            intervalDays: newIntervalDays
        )

        records[wordID] = updatedRecord
        save(records)
        return updatedRecord
    }

    /// Returns a set of word IDs that are due for review.
    func dueWordIDs() -> Set<UUID> {
        let records = allRecords()
        let dueRecords = records.values.filter { $0.isDue }
        return Set(dueRecords.map(\.wordID))
    }

    /// Resets all spaced repetition records.
    func resetAll() {
        defaults.removeObject(forKey: recordsKey)
    }

    // MARK: - Private

    private func save(_ records: [UUID: ReviewRecord]) {
        guard let data = try? JSONEncoder().encode(records) else { return }
        defaults.set(data, forKey: recordsKey)
    }
}
