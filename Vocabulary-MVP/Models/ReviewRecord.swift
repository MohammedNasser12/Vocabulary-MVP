import Foundation

/// Persistent record tracking spaced repetition review interval for a word.
struct ReviewRecord: Codable, Identifiable {
    let wordID: UUID
    var rating: WordRating
    var lastReviewedAt: Date
    var nextReviewDate: Date
    var repetitionCount: Int
    var intervalDays: Int

    var id: UUID { wordID }

    /// Returns true if the word is due for review today or overdue.
    var isDue: Bool {
        Calendar.current.startOfDay(for: nextReviewDate) <= Calendar.current.startOfDay(for: Date())
    }

    /// User-friendly label for next review schedule.
    var formattedNextReview: String {
        let calendar = Calendar.current
        let startToday = calendar.startOfDay(for: Date())
        let startNext = calendar.startOfDay(for: nextReviewDate)

        let components = calendar.dateComponents([.day], from: startToday, to: startNext)
        let days = components.day ?? 0

        if days <= 0 {
            return "Due for review today"
        } else if days == 1 {
            return "Review tomorrow"
        } else {
            return "Review in \(days) days"
        }
    }
}
