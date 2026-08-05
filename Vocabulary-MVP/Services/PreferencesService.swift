import Foundation

/// Manages persistence of user preferences using UserDefaults.
final class PreferencesService {

    /// Shared singleton instance.
    static let shared = PreferencesService()

    private let defaults = UserDefaults.standard
    private let preferencesKey = "com.vocabulary.userPreferences"

    private init() {}

    // MARK: - Public API

    /// Loads saved user preferences, or returns defaults if none exist.
    func load() -> UserPreferences {
        guard let data = defaults.data(forKey: preferencesKey),
              let preferences = try? JSONDecoder().decode(UserPreferences.self, from: data) else {
            return .default
        }
        return preferences
    }

    /// Saves user preferences to UserDefaults.
    func save(_ preferences: UserPreferences) {
        guard let data = try? JSONEncoder().encode(preferences) else { return }
        defaults.set(data, forKey: preferencesKey)
    }

    /// Quick check for whether onboarding has been completed.
    var hasCompletedOnboarding: Bool {
        load().hasCompletedOnboarding
    }

    /// Marks onboarding as complete.
    func completeOnboarding() {
        var preferences = load()
        preferences.hasCompletedOnboarding = true
        save(preferences)
    }

    /// Resets all preferences (useful for testing).
    func reset() {
        defaults.removeObject(forKey: preferencesKey)
    }
}
