import SwiftUI

/// Settings view providing controls to:
/// 1. Reset learning progress & spaced repetition history
/// 2. Change active app theme with live preview
/// 3. Control all existing setup preferences (name, vocabulary level, words per week, voice, topics, etc.)
struct SettingsView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var preferences: UserPreferences
    @State private var showResetProgressAlert = false
    @State private var showResetAllAlert = false

    let onPreferencesChanged: (UserPreferences) -> Void
    let onResetProgress: () -> Void

    init(
        preferences: UserPreferences = PreferencesService.shared.load(),
        onPreferencesChanged: @escaping (UserPreferences) -> Void,
        onResetProgress: @escaping () -> Void
    ) {
        _preferences = State(initialValue: preferences)
        self.onPreferencesChanged = onPreferencesChanged
        self.onResetProgress = onResetProgress
    }

    private let themeColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: - Section 1: Appearance & Theme
                    themeSection

                    // MARK: - Section 2: Learning & Setup Preferences
                    setupPreferencesSection

                    // MARK: - Section 3: Topics Selection
                    topicsSection

                    // MARK: - Section 4: Progress & Data Management
                    progressManagementSection

                    // MARK: - Section 5: App Information
                    appInfoSection
                }
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.vertical, 16)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appTealDark)
                }
            }
            .alert("Reset Learning Progress?", isPresented: $showResetProgressAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset Progress", role: .destructive) {
                    onResetProgress()
                    HapticService.shared.success()
                }
            } message: {
                Text("This will clear your viewed daily words, progress bar, self-assessment ratings, and spaced repetition review schedules. Your setup preferences will be kept.")
            }
            .alert("Reset All App Data?", isPresented: $showResetAllAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset Everything", role: .destructive) {
                    PreferencesService.shared.reset()
                    SpacedRepetitionService.shared.resetAll()
                    onResetProgress()
                    HapticService.shared.success()
                    dismiss()
                }
            } message: {
                Text("This will clear all preferences, learning history, and restart onboarding.")
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(24)
    }

    // MARK: - Theme Section

    private var themeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "APPEARANCE", subtitle: "Choose your favorite atmospheric theme")

            LazyVGrid(columns: themeColumns, spacing: 12) {
                ForEach(AppTheme.allCases) { theme in
                    ThemeGridItem(
                        theme: theme,
                        isSelected: preferences.selectedTheme == theme
                    ) {
                        preferences.selectedTheme = theme
                        saveAndNotify()
                    }
                }
            }

            // Current theme indicator label
            HStack {
                Text("Active Theme:")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)
                Text(preferences.selectedTheme.displayText)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.appText)
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(Color.appCardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .stroke(Color.appBorderLight, lineWidth: 1)
        )
    }

    // MARK: - Setup Preferences Section

    private var setupPreferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "LEARNING SETUP", subtitle: "Customize your personal vocabulary experience")

            // Name
            VStack(alignment: .leading, spacing: 6) {
                Text("Name")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)

                TextField("Your name", text: Binding(
                    get: { preferences.name ?? "" },
                    set: { preferences.name = $0.isEmpty ? nil : $0; saveAndNotify() }
                ))
                .font(.system(size: 16, weight: .regular))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appBorderLight, lineWidth: 1)
                )
            }

            Divider()

            // Vocabulary Level
            VStack(alignment: .leading, spacing: 6) {
                Text("Vocabulary Level")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)

                Picker("Vocabulary Level", selection: Binding(
                    get: { preferences.vocabularyLevel ?? .intermediate },
                    set: { preferences.vocabularyLevel = $0; saveAndNotify() }
                )) {
                    ForEach(VocabularyLevel.allCases) { level in
                        Text(level.displayText).tag(level)
                    }
                }
                .pickerStyle(.segmented)
            }

            Divider()

            // Words Per Week
            VStack(alignment: .leading, spacing: 6) {
                Text("Words Per Week")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)

                Picker("Words Per Week", selection: Binding(
                    get: { preferences.wordsPerWeek ?? .thirty },
                    set: { preferences.wordsPerWeek = $0; saveAndNotify() }
                )) {
                    ForEach(WordsPerWeek.allCases) { option in
                        Text(option.displayText).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            Divider()

            // Voice Selection
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Pronunciation Voice")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.appTextSecondary)

                    Spacer()

                    Button {
                        SpeechService.shared.speak("Vocabulary", voice: preferences.selectedVoice)
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "speaker.wave.2.fill")
                            Text("Test Voice")
                        }
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.appTealDark)
                    }
                }

                Menu {
                    ForEach(VoiceOption.allCases) { voiceOption in
                        Button {
                            preferences.selectedVoice = voiceOption
                            saveAndNotify()
                            SpeechService.shared.speak(voiceOption.displayText, voice: voiceOption)
                        } label: {
                            HStack {
                                Text("\(voiceOption.displayText) (\(voiceOption.accent))")
                                if preferences.selectedVoice == voiceOption {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(preferences.selectedVoice.displayText)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color.appText)
                            Text("\(preferences.selectedVoice.accent) Accent")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.appTextSecondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.appTextTertiary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.appBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.appBorderLight, lineWidth: 1)
                    )
                }
            }

            Divider()

            // Curiosity Driver
            VStack(alignment: .leading, spacing: 6) {
                Text("Curiosity Motivation")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)

                Menu {
                    ForEach(CuriosityDriver.allCases) { driver in
                        Button {
                            preferences.curiosityDriver = driver
                            saveAndNotify()
                        } label: {
                            HStack {
                                Text(driver.displayText)
                                if preferences.curiosityDriver == driver {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(preferences.curiosityDriver?.displayText ?? "Select motivation")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(Color.appText)

                        Spacer()

                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.appTextTertiary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.appBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.appBorderLight, lineWidth: 1)
                    )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(Color.appCardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .stroke(Color.appBorderLight, lineWidth: 1)
        )
    }

    // MARK: - Topics Section

    private var topicsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "INTEREST TOPICS", subtitle: "Select categories to prioritize for learning")

            FlowLayout(spacing: 8) {
                ForEach(Topic.allCases) { topic in
                    let isSelected = preferences.selectedTopics.contains(topic)

                    Button {
                        if isSelected {
                            preferences.selectedTopics.removeAll { $0 == topic }
                        } else {
                            preferences.selectedTopics.append(topic)
                        }
                        saveAndNotify()
                        HapticService.shared.selectionTap()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 14))
                            Text(topic.displayText)
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundStyle(isSelected ? Color.appText : Color.appTextSecondary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(isSelected ? Color.appSelectedTint : Color.appBackground)
                        )
                        .overlay(
                            Capsule()
                                .stroke(isSelected ? Color.appTealDark : Color.appBorderLight, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(Color.appCardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .stroke(Color.appBorderLight, lineWidth: 1)
        )
    }

    // MARK: - Progress Management Section

    private var progressManagementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "DATA & PROGRESS", subtitle: "Manage your review history and app state")

            // Reset Progress CTA
            Button {
                HapticService.shared.buttonPress()
                showResetProgressAlert = true
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.orange)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Reset Learning Progress")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.appText)
                        Text("Clears viewed daily words & mastery ratings")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.appTextSecondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.appTextTertiary)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)

            // Reset All App Data CTA
            Button {
                HapticService.shared.buttonPress()
                showResetAllAlert = true
            } label: {
                HStack {
                    Image(systemName: "trash.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.red)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Reset All App Data")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.red)
                        Text("Clears preferences & restarts onboarding")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.appTextSecondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.appTextTertiary)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red.opacity(0.06))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red.opacity(0.2), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(Color.appCardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .stroke(Color.appBorderLight, lineWidth: 1)
        )
    }

    // MARK: - App Info Section

    private var appInfoSection: some View {
        VStack(spacing: 4) {
            Text("Vocabulary App")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.appTextSecondary)
            Text("Version 1.0 • Built with SwiftUI")
                .font(.system(size: 11))
                .foregroundStyle(Color.appTextTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    // MARK: - Helpers

    private func sectionHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appTextTertiary)
                .tracking(1.0)
            Text(subtitle)
                .font(.system(size: 13))
                .foregroundStyle(Color.appTextSecondary)
        }
        .padding(.bottom, 4)
    }

    private func saveAndNotify() {
        PreferencesService.shared.save(preferences)
        onPreferencesChanged(preferences)
    }
}

// MARK: - Preview

#Preview {
    SettingsView(
        preferences: .default,
        onPreferencesChanged: { _ in },
        onResetProgress: { }
    )
}
