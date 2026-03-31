# Feature Specification: PersonaPath Refactor Fixes

**Feature Branch**: `001-flutter-refactor-fixes`  
**Created**: 2026-03-31  
**Status**: Draft  
**Input**: User description: "Refactor existing Flutter app (PersonaPath). Fix 7 specific issues:
1. Delete duplicate folder `presentation/screens/quiz/`
2. Extract `_fallbackName` into shared `string_utils.dart`
3. Fix image URL allowlist to accept Unsplash + Picsum
4. Split `app_router.dart` and move `AppBlocScope` to `app_bloc_scope.dart`
5. Remove `_runNetworkProbe` from `main.dart`
6. Fix `HomeScreen`: remove duplicate `upsertUser`, add `StreamBuilder` error handling
7. Move Firestore quiz-saving into `ItineraryCubit.generateFromQuiz()`"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Stable Home Experience (Priority: P1)

As a returning PersonaPath user, I want the home experience to avoid duplicate
profile updates and show a clear fallback state when loading itinerary-related
content fails, so I can continue using the app without confusion or repeated side
effects.

**Why this priority**: The home screen is a primary entry point, and duplicate
writes or silent loading failures directly undermine user trust.

**Independent Test**: Open the home experience with valid user data and with a
failing live data stream; confirm user data is not written twice and the screen
shows a usable error state instead of hanging or crashing.

**Acceptance Scenarios**:

1. **Given** an authenticated user opens the app, **When** the home experience
   initializes, **Then** user profile persistence occurs once per intended save
   action and does not trigger duplicate updates.
2. **Given** the home experience depends on a live itinerary-related data stream,
   **When** that stream returns an error, **Then** the user sees an explicit error
   state with a recoverable path instead of an empty or broken screen.

---

### User Story 2 - Reliable Quiz-to-Itinerary Flow (Priority: P2)

As a user who completes the trip quiz, I want my generated itinerary and quiz
results to be saved as part of one consistent generation flow, so the app
preserves my planning outcome without scattered or partial save behavior.

**Why this priority**: The quiz-to-itinerary flow is a core value path, and save
responsibility must be consistent to prevent lost or fragmented trip data.

**Independent Test**: Complete the quiz once and verify the app produces and saves
the resulting itinerary through a single end-to-end generation flow, including
the quiz answers that informed it.

**Acceptance Scenarios**:

1. **Given** a user completes the quiz, **When** itinerary generation succeeds,
   **Then** the resulting itinerary and quiz-derived planning data are persisted
   as one coordinated outcome.
2. **Given** itinerary generation fails after quiz submission, **When** the user
   returns to the flow, **Then** the app does not leave behind a misleading
   partially saved result that appears complete.

---

### User Story 3 - Predictable Asset and App Startup Behavior (Priority: P3)

As a user navigating PersonaPath, I want supported remote images to load
consistently and app startup/navigation code to behave predictably, so the app
feels polished and maintainable rather than brittle.

**Why this priority**: These changes reduce visible content failures and improve
confidence in future releases, even though they are less urgent than the primary
home and itinerary flows.

**Independent Test**: Launch the app, navigate through the affected screens, and
verify approved remote images load successfully while startup and navigation
behavior remain unchanged from a user perspective.

**Acceptance Scenarios**:

1. **Given** PersonaPath displays supported remote images from approved content
   providers, **When** a valid image URL is supplied, **Then** the image loads
   without being rejected as unsupported.
2. **Given** the app starts and users navigate through the quiz and home flows,
   **When** the internal startup and routing refactor is applied, **Then** the
   user-visible navigation behavior remains stable.

### Edge Cases

- If a user record is missing optional profile data, the app must still present a
  readable fallback name wherever profile text is shown.
- If a supported image host changes URL format slightly while staying within the
  approved provider domain, the app should continue accepting the URL.
- If itinerary generation is retried after an earlier failure, the final saved
  state must reflect only the successful attempt.
- If live data becomes temporarily unavailable on the home experience, the user
  must receive an error state that does not block later recovery.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST remove redundant quiz presentation artifacts so
  there is one authoritative quiz screen flow.
- **FR-002**: The system MUST provide one shared fallback-name behavior for user
  display strings anywhere that profile names are incomplete or missing.
- **FR-003**: The system MUST accept remote image URLs from the approved image
  providers used by the product, including Unsplash and Picsum.
- **FR-004**: The system MUST preserve existing user-visible navigation behavior
  while separating app-wide state scope responsibilities from route declaration
  responsibilities.
- **FR-005**: The system MUST remove obsolete startup probing behavior that does
  not contribute to the user-facing launch flow.
- **FR-006**: The system MUST prevent duplicate user upsert behavior in the home
  experience.
- **FR-007**: The system MUST show an explicit and recoverable error state when
  the home experience receives a stream error for itinerary-related content.
- **FR-008**: The system MUST make itinerary generation the single owner of quiz
  result persistence so generated trip data is saved consistently.
- **FR-009**: The system MUST avoid leaving users with partial or ambiguous saved
  trip-planning data when itinerary generation does not complete successfully.

### Technical Constraints *(mandatory)*

- **TC-001**: Shared naming fallback behavior belongs in a shared utility within
  the `core` layer; screen-specific duplicate logic must be removed from
  `presentation`.
- **TC-002**: Presentation state ownership remains with existing screen state
  units; the refactor may relocate app-level scope wiring but must not move
  business decisions into widgets.
- **TC-003**: The route graph must retain the current user-visible destinations
  and guards while route declaration and app-level scope composition are split
  into separate responsibilities.
- **TC-004**: Persistence of quiz-derived itinerary data must be triggered from
  the itinerary-generation state flow, and data-layer storage remains behind
  repository or adapter boundaries.
- **TC-005**: The minimum validation set includes unit coverage for shared string
  fallback and URL acceptance rules, state-management coverage for itinerary save
  ownership, and widget or integration coverage for home error handling and the
  quiz-to-itinerary flow.

### Key Entities *(include if feature involves data)*

- **User Profile Summary**: The user-facing profile identity details used for
  greeting and display, including a resolved display name when preferred fields
  are absent.
- **Quiz Response Set**: The collected answers from the planning quiz that inform
  itinerary generation and must stay associated with the generated result.
- **Generated Itinerary**: The saved trip-planning outcome produced from the quiz,
  including destinations, timing, and the source quiz context.
- **Remote Image Source**: An external image reference that is accepted only when
  it belongs to an approved provider.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In regression testing, 100% of reviewed home-entry scenarios avoid
  duplicate user profile save behavior.
- **SC-002**: In validation runs, 100% of approved Unsplash and Picsum image URLs
  used in test scenarios render successfully.
- **SC-003**: In end-to-end testing, 100% of successful quiz completions produce
  one saved itinerary outcome with its associated planning data.
- **SC-004**: In test scenarios where live home data fails, users receive a clear
  error state in under 2 seconds and can retry or recover without restarting the
  app.

## Assumptions

- PersonaPath already has a working quiz, home, and itinerary-generation flow,
  and this feature is limited to refactoring and defect correction within those
  existing experiences.
- Unsplash and Picsum are the only newly required additions to the current
  approved image-provider list for this change.
- No intentional user-facing navigation redesign is in scope; any route changes
  are internal restructuring unless required to preserve current behavior.
- Existing persistence contracts and authentication behavior remain in use; this
  feature only relocates save ownership to the correct generation flow.
