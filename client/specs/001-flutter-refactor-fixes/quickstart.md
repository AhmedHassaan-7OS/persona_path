# Quickstart: PersonaPath Refactor Fixes

## Goal

Verify that the refactor preserves user-visible behavior while correcting duplicate ownership, legacy folder drift, and missing error handling.

## Preconditions

- PersonaPath Flutter app source is available in the working tree.
- Firebase configuration for the existing development environment is present.
- Test dependencies are installed for Flutter, bloc tests, widget tests, and integration tests.

## Validation Steps

1. Confirm the duplicate quiz presentation folder has been removed and the retained quiz flow still builds.
2. Run unit tests for shared string fallback behavior and remote image URL allowlist rules.
3. Run bloc or cubit tests covering `ItineraryCubit.generateFromQuiz()` success, failure, and retry persistence ownership.
4. Run widget tests for HomeScreen loading, success, and stream-error states.
5. Run an integration test or manual end-to-end validation for the quiz-to-itinerary flow.
6. Launch the app and verify startup proceeds without `_runNetworkProbe` and without route regressions after splitting `AppBlocScope`.
7. Open a screen that renders approved Unsplash and Picsum images and verify valid URLs are accepted.
8. Trigger a recoverable failure in the home data stream and verify the UI shows an explicit error state.

## Expected Outcomes

- One authoritative quiz presentation path remains.
- Shared fallback-name logic produces the same resolved display text across screens.
- Unsplash and Picsum images render when URLs are valid.
- HomeScreen no longer triggers duplicate user upserts.
- Home stream failures render a recoverable error state.
- Quiz completion persists itinerary data only through `ItineraryCubit.generateFromQuiz()`.
- Route behavior remains unchanged from the user perspective.
