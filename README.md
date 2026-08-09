# Vocabulary MVP

A focused iOS vocabulary-learning experience built with **SwiftUI**, designed around fast onboarding, active recall, and lightweight spaced repetition.

The MVP transforms vocabulary browsing from a passive **see → read → scroll** experience into a more intentional **see → think → reveal → self-assess → review** learning loop.

## Highlights

- **11-step streamlined onboarding** focused on meaningful personalization
- **Daily vocabulary sets** combining new and review words
- **Active recall** through progressive word-detail reveal
- **Self-assessment** with _Knew It_, _Learning_, and _New_ ratings
- **Spaced repetition** based on word familiarity
- **Horizontal card-stack navigation** with swipe and explicit controls
- **Pronunciation playback** with animated audio feedback
- **In-context vocabulary highlighting** in example sentences
- **Word mastery progress** with visual and haptic feedback
- **Theme personalization** carried into the learning experience
- Fully local data with **no network/API dependency**

## Learning Experience

The core learning flow is intentionally lightweight:

```text
See word
   ↓
Think / recall
   ↓
Reveal definition & context
   ↓
Self-assess familiarity
   ↓
Schedule future review
   ↓
Next word
```

Word cards progressively reveal:

- Word and pronunciation
- Part of speech
- Difficulty
- Definition
- Example sentence
- Synonyms
- Origin

Users can then quickly rate their familiarity, allowing the app to determine when the word should appear again.

## Onboarding

The original product contained approximately 25 onboarding screens. The MVP reduces this to **11 focused steps**, removing redundant questions, feature promotions, subscription flows, widgets, notifications, and vocabulary testing.

The implemented flow collects:

1. Welcome
2. Personalization introduction
3. Name
4. Age range
5. Gender
6. Weekly learning goal
7. Curiosity driver
8. Vocabulary level
9. Topics
10. Pronunciation voice
11. Visual theme

The result is a substantially shorter path to the core learning experience while retaining the personalization required for the MVP.

## Core Features

### Daily Vocabulary

Vocabulary is organized into daily sets containing a combination of new and previously learned words.

Daily selection is deterministic through **date-seeded word selection**, providing a consistent set throughout the day without requiring a backend.

### Active Recall

Definitions and supporting information are intentionally hidden initially. The interaction encourages the learner to think about the word before revealing the answer.

This introduces active recall without turning the experience into a conventional quiz.

### Spaced Repetition

Familiarity ratings influence future word scheduling. Words that require more reinforcement can return sooner, while familiar words are progressively deferred.

### Card Stack

The vocabulary deck uses a horizontal card-stack interaction rather than relying exclusively on vertical swiping.

The interface provides:

- Visible next-card preview
- Scale and opacity transitions
- Swipe gestures
- Explicit navigation controls
- Persistent progress feedback

This makes the interaction more discoverable while retaining the speed of gesture-based navigation.

### Pronunciation

Pronunciation is powered by Apple's speech synthesis APIs.

Audio playback includes lightweight visual feedback through animated waveform/pulse effects, providing immediate confirmation that playback is active.

### Word Context

Example sentences highlight the target vocabulary so learners can immediately identify how the word is being used in context.

## Architecture

The project follows a lightweight **MVVM architecture** using SwiftUI's `@Observable` state model.

```text
┌─────────────────────┐
│      SwiftUI        │
│       Views         │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│     ViewModels       │
│     @Observable      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│       Services      │
│ Word / Speech /     │
│ Preferences / Haptic│
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│       Models        │
│ Word / Preferences  │
│ Learning State       │
└─────────────────────┘
```

### Main Responsibilities

**Views**

- SwiftUI presentation and interaction
- Onboarding screens
- Vocabulary card stack
- Word details and supporting UI

**ViewModels**

- Onboarding state and navigation
- Daily deck management
- Card progression
- Learning and review state
- Favorites/bookmarks and UI state

**Services**

- Local vocabulary data
- User preference persistence
- Speech synthesis
- Haptic feedback

## Data & Persistence

The MVP is intentionally self-contained.

- Vocabulary data is bundled locally
- User preferences are persisted with `UserDefaults`
- Onboarding completion is persisted locally
- Learning/spaced-repetition state is stored locally
- No authentication or backend is required
- No network requests are required for the core experience

## Technology

| Area         | Implementation                       |
| ------------ | ------------------------------------ |
| UI           | SwiftUI                              |
| Architecture | MVVM                                 |
| State        | `@Observable`                        |
| Persistence  | UserDefaults                         |
| Speech       | AVFoundation / `AVSpeechSynthesizer` |
| Vocabulary   | Bundled JSON                         |
| Feedback     | SwiftUI animations + haptics         |
| Minimum OS   | iOS 17+                              |
| Target       | iOS 26.5                             |

## Project Structure

```text
Vocabulary-MVP/
├── App/
├── Models/
├── ViewModels/
├── Views/
│   ├── Onboarding/
│   ├── Home/
│   └── Components/
├── Services/
├── Resources/
├── Extensions/
└── Utilities/
```

The structure separates presentation, state management, domain models, and platform services to keep the MVP easy to extend.

## UX & Interaction

The interface uses a restrained interaction language throughout the product:

- Spring-based card and selection animations
- Lightweight haptic confirmation
- Animated pronunciation feedback
- Progressive information reveal
- Visual mastery/progress feedback
- Consistent reusable CTA and selection components
- Accessible tap targets and semantic controls
- Reduced-motion support where applicable

Completing a daily set provides a subtle visual and haptic completion moment rather than an intrusive reward flow.

## Scope

The MVP intentionally focuses on the vocabulary learning loop.

### Included

- Onboarding and personalization
- Daily vocabulary
- Active recall
- Self-assessment
- Spaced repetition
- Pronunciation
- Card-stack navigation
- Word details and context
- Themes
- Local persistence
- Progress feedback

### Out of Scope

- Backend/API integration
- Authentication
- Subscriptions and paywall
- Push notifications
- Home-screen widgets
- Attribution/analytics flows
- App icon customization
- Full Topics, Practice, Stats, and Profile functionality

Non-functional bottom tabs may be presented as placeholders for future expansion.

## Verification

Manual verification covers:

- Complete onboarding flow
- Preference persistence
- Daily vocabulary generation
- Card-stack navigation
- Reveal and self-assessment flow
- Spaced-repetition scheduling
- Theme application
- Pronunciation playback
- Animations and haptics
- Daily progress completion
- Edge cases such as rapid interaction and empty input

## Product Direction

The MVP deliberately prioritizes **learning quality over feature breadth**.

Rather than reproducing every screen from the original product, the implementation concentrates on the smallest set of interactions that can create a meaningful vocabulary-learning habit:

> **Personalize → Learn → Recall → Assess → Review**

This provides a focused foundation for future expansion into richer statistics, topics, practice modes, notifications, and cloud-backed personalization.

## Demo

**App walkthrough**
<video src="https://github.com/user-attachments/assets/39da7c45-c4ee-4917-b020-f6b81a970a45" controls width="800"></video>

**Settings**
<video src="https://github.com/user-attachments/assets/8ed40e1d-d798-41a8-bef1-a9b187ab8ee0" controls width="800"></video>
