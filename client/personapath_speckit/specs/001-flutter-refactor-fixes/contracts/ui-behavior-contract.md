# UI and Behavior Contract: PersonaPath Refactor Fixes

## 1. Shared Name Fallback Contract

- Input: Partial or complete user identity fields.
- Output: One non-empty display string.
- Rules:
  - Prefer the existing product-preferred name fields.
  - Fall back deterministically to secondary identity fields.
  - Never return an empty display value to presentation.

## 2. Approved Image Source Contract

- Input: Remote image URL.
- Output: Accepted or rejected validation result.
- Rules:
  - Accept valid URLs from the approved Unsplash and Picsum hosts.
  - Reject malformed URLs.
  - Reject unapproved hosts.

## 3. Home Stream Rendering Contract

- Input: Loading, success, empty, and error states from the home data stream.
- Output: Matching user-visible UI state.
- Rules:
  - Loading must render a visible loading state.
  - Success must render the available itinerary-related content.
  - Error must render an explicit recoverable error state.
  - Home initialization must not trigger duplicate user upserts.

## 4. Quiz-to-Itinerary Persistence Contract

- Input: Completed quiz response set submitted for itinerary generation.
- Output: One generated itinerary persisted with its source quiz context on success.
- Rules:
  - Quiz presentation only collects input and dispatches generation intent.
  - `ItineraryCubit.generateFromQuiz()` owns the persistence side effect.
  - Failed generation attempts must not produce a misleading completed saved result.
  - Successful retries may persist one final authoritative outcome.

## 5. Routing Composition Contract

- Input: App startup and navigation events.
- Output: The same user-visible route behavior as before the refactor.
- Rules:
  - `app_router.dart` remains the centralized route declaration surface.
  - `app_bloc_scope.dart` provides app-level bloc scope composition only.
  - Splitting files must not alter route destinations, guards, or redirect behavior.
