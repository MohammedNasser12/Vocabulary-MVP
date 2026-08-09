import SwiftUI

extension Text {

    /// Returns a `Text` view displaying an example sentence with all occurrences
    /// of the target vocabulary word highlighted with bold weight and accent color.
    static func highlightedExample(
        sentence: String,
        targetWord: String,
        baseColor: Color = .appText,
        highlightColor: Color = .appTealDark
    ) -> Text {
        var attributed = AttributedString(sentence)
        let lowerSentence = sentence.lowercased()
        let lowerTarget = targetWord.lowercased()

        var searchRange = lowerSentence.startIndex..<lowerSentence.endIndex
        while let range = lowerSentence.range(of: lowerTarget, options: [], range: searchRange) {
            if let attrRange = Range(range, in: attributed) {
                attributed[attrRange].foregroundColor = highlightColor
                attributed[attrRange].font = .system(size: 15, weight: .bold)
            }
            searchRange = range.upperBound..<lowerSentence.endIndex
        }

        return Text(attributed)
    }
}
