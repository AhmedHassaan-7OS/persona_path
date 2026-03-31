# Research: PersonaPath Refactor Fixes

## Decision 1: Remove the duplicate quiz presentation folder and keep one quiz flow

- Decision: Treat `presentation/screens/quiz/` as legacy duplicate presentation code and remove it after confirming all active imports and route references point to the retained quiz flow.
- Rationale: Keeping two quiz screen trees creates drift in navigation, validation, and persistence ownership. The refactor request explicitly identifies this folder as duplicate, so the safest outcome is one authoritative quiz presentation path.
- Alternatives considered:
  - Keep both folders and document a preferred one: rejected because duplication would continue to invite regressions.
  - Merge both folders without deletion: rejected because it preserves ambiguity unless one path is retired completely.

## Decision 2: Move fallback-name behavior into a shared utility

- Decision: Extract `_fallbackName` into `lib/core/utils/string_utils.dart` as a shared display-name resolver used by profile-facing UI.
- Rationale: Display-name fallback is cross-cutting presentation support logic with no screen-specific ownership. Centralizing it prevents diverging fallback rules and makes unit testing straightforward.
- Alternatives considered:
  - Leave `_fallbackName` private to HomeScreen: rejected because the refactor request explicitly calls for shared reuse.
  - Move the logic into a widget helper: rejected because shared text rules belong in a reusable utility, not a widget-specific module.

## Decision 3: Expand the image URL allowlist narrowly

- Decision: Accept approved Unsplash and Picsum host patterns while continuing to reject unapproved hosts.
- Rationale: The feature request is to support specific providers, not to loosen image validation globally. Narrow host-based expansion keeps behavior predictable and reduces the chance of accepting arbitrary external sources.
- Alternatives considered:
  - Disable host validation entirely: rejected because it broadens trust without need.
  - Accept only one canonical URL per provider: rejected because valid CDN or path variants are common for both providers.

## Decision 4: Split route declaration from app-wide bloc scope composition

- Decision: Keep `app_router.dart` focused on `go_router` configuration and move `AppBlocScope` into `app_bloc_scope.dart`.
- Rationale: Routing and top-level dependency or bloc composition are separate responsibilities. Splitting them preserves the routing contract while making app bootstrap simpler to reason about and test.
- Alternatives considered:
  - Keep both responsibilities in one file: rejected because it obscures ownership and makes future route changes harder to review.
  - Move routing into the bloc-scope file instead: rejected because the constitution requires `go_router` to remain a first-class centralized surface.

## Decision 5: Remove obsolete startup network probing

- Decision: Remove `_runNetworkProbe` from `main.dart` unless a proven user-facing requirement depends on it.
- Rationale: The refactor request identifies it as obsolete. Startup code should stay minimal, and extra probing adds maintenance and latency risk without direct product value.
- Alternatives considered:
  - Keep the probe behind a debug flag: rejected because the requested scope is removal, not relocation.
  - Replace it with a different startup probe: rejected because there is no requirement showing a startup health check is needed.

## Decision 6: HomeScreen renders stream failures explicitly and stops duplicate upserts

- Decision: Remove duplicate `upsertUser` behavior from HomeScreen and add explicit `StreamBuilder` error-state rendering with a recoverable path.
- Rationale: HomeScreen should render state, not trigger duplicate persistence side effects. Explicit error handling keeps the user informed and aligns with the constitution requirement for predictable presentation-state behavior.
- Alternatives considered:
  - Hide stream errors behind an empty state: rejected because users cannot distinguish failure from missing data.
  - Retain duplicate upsert calls and rely on backend idempotency: rejected because unnecessary writes still create noise and risk.

## Decision 7: Make itinerary generation the single owner of quiz-result persistence

- Decision: Move Firestore quiz-saving into `ItineraryCubit.generateFromQuiz()` and treat generation completion as the point where quiz-derived planning data is persisted.
- Rationale: Persistence belongs with the state transition that owns itinerary generation, not with a quiz screen that should only collect input and dispatch intent. This keeps side effects centralized and makes retry and failure semantics testable.
- Alternatives considered:
  - Save quiz results directly from the quiz UI before generation: rejected because it splits responsibility and can leave partial state.
  - Persist only the final itinerary without quiz context: rejected because the specification requires the generated result to stay associated with the quiz inputs that produced it.
