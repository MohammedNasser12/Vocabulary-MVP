import Foundation

/// Represents a vocabulary word with all its linguistic properties.
struct Word: Identifiable, Codable, Hashable {
    let id: UUID
    let text: String
    let phonetic: String
    let partOfSpeech: String
    let definition: String
    let example: String?
    let synonyms: [String]
    let origin: String?
    let difficulty: Difficulty

    enum Difficulty: String, Codable, CaseIterable {
        case beginner
        case intermediate
        case advanced
    }
}
