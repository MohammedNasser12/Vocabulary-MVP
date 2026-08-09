import AVFoundation

/// Wrapper around AVSpeechSynthesizer for pronouncing vocabulary words.
///
/// Supports multiple voice options (American, British, Australian) and
/// manages a single synthesizer instance for memory efficiency.
final class SpeechService: NSObject, AVSpeechSynthesizerDelegate {

    /// Shared singleton instance.
    static let shared = SpeechService()

    private let synthesizer = AVSpeechSynthesizer()

    /// Callback closure triggered when speech playback starts or finishes.
    var onSpeechStateChanged: ((Bool) -> Void)?

    override private init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }

    // MARK: - Public API

    /// Speaks the given text using the specified voice option.
    /// - Parameters:
    ///   - text: The word or phrase to pronounce.
    ///   - voice: The voice option selected by the user.
    ///   - rate: Speech rate (0.0 to 1.0). Default is slightly slower for clarity.
    func speak(_ text: String, voice: VoiceOption, rate: Float = 0.4) {
        // Stop any ongoing speech
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = rate
        utterance.pitchMultiplier = 1.0
        utterance.preUtteranceDelay = 0.1
        utterance.postUtteranceDelay = 0.1

        // Try to find the specific voice, fall back to language default
        if let avVoice = findVoice(for: voice) {
            utterance.voice = avVoice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: voice.languageCode)
        }

        synthesizer.speak(utterance)
    }

    /// Stops any currently playing speech.
    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

    /// Whether speech is currently being synthesized.
    var isSpeaking: Bool {
        synthesizer.isSpeaking
    }

    // MARK: - Private

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Audio session configuration is best-effort
            print("SpeechService: Failed to configure audio session: \(error)")
        }
    }

    private func findVoice(for option: VoiceOption) -> AVSpeechSynthesisVoice? {
        let voices = AVSpeechSynthesisVoice.speechVoices()

        // First try to find by identifier prefix
        if let voice = voices.first(where: { $0.identifier.contains(option.voiceIdentifierPrefix) }) {
            return voice
        }

        // Fall back to any voice matching the language
        return voices.first(where: { $0.language == option.languageCode })
    }

    // MARK: - AVSpeechSynthesizerDelegate

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in
            self?.onSpeechStateChanged?(true)
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in
            self?.onSpeechStateChanged?(false)
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in
            self?.onSpeechStateChanged?(false)
        }
    }
}
