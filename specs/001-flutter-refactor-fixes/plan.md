# Implementation Plan: PersonaPath Refactor Fixes

**Branch**: `001-flutter-refactor-fixes` | **Date**: 2026-03-31 | **Spec**: [spec.md](D:/programing/DART/persona_path/personapath_speckit/specs/001-flutter-refactor-fixes/spec.md)
**Input**: Feature specification from `/specs/001-flutter-refactor-fixes/spec.md`

**Note**: This plan is based on the specification and the paths named in the refactor request. The current repository snapshot does not include the Flutter source tree, so file paths below are design targets inferred from the requested refactor scope.

## Summary

Refactor the existing PersonaPath Flutter application to eliminate duplicated quiz presentation code, centralize shared string fallback behavior, expand approved remote image hosts, separate route declarations from app-level bloc scope composition, remove obsolete startup probing, harden HomeScreen stream failure handling, and make itinerary generation the single owner of quiz-result persistence.

## Technical Context

**Language/Version**: Dart 3.x with Flutter stable  
**Primary Dependencies**: Flutter, flutter_bloc, go_router, Firebase Auth, Cloud Firestore  
**Storage**: Cloud Firestore for itinerary and quiz-derived persistence; local in-memory state during UI flows  
**Testing**: flutter_test, bloc_test, widget tests, integration_test  
**Target Platform**: Android and iOS mobile app  
**Project Type**: mobile-app  
**Performance Goals**: Home and quiz flows continue to render perceived state changes within 2 seconds under normal network conditions; no additional startup latency from removed probe logic  
**Constraints**: Preserve current user-visible navigation, keep Firebase usage out of presentation widgets, avoid duplicate writes, and complete the refactor without changing core product scope  
**Scale/Scope**: One existing Flutter app; affects app bootstrap, routing, shared utilities, home flow, quiz flow, and itinerary persistence

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- `Layer Boundaries`: Pass. Shared name fallback moves to `lib/core/utils/string_utils.dart`; Firestore quiz-save ownership moves into itinerary generation flow while staying behind data and state boundaries.
- `State Ownership`: Pass. `ItineraryCubit` remains the owner of generation-side persistence decisions, and `HomeScreen` is limited to presentation plus stream-state rendering.
- `Routing Contract`: Pass. `go_router` remains the single navigation surface; `AppBlocScope` is split out of `app_router.dart` without changing route contracts.
- `Firebase Isolation`: Pass. Firestore persistence is consolidated into the itinerary-generation path instead of being triggered from quiz presentation code.
- `Test Coverage`: Pass with planned coverage. Unit tests cover fallback-name and URL allowlist rules, bloc/cubit tests cover itinerary save ownership, and widget or integration tests cover home stream errors and quiz completion persistence.

## Project Structure

### Documentation (this feature)

```text
specs/001-flutter-refactor-fixes/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
`-- tasks.md
```

### Source Code (repository root)

```text
lib/
|-- app/
|   |-- router/
|   |   |-- app_router.dart
|   |   `-- app_bloc_scope.dart
|   `-- main.dart
|-- core/
|   `-- utils/
|       `-- string_utils.dart
|-- features/
|   |-- home/
|   |   `-- presentation/
|   |       `-- home_screen.dart
|   |-- itinerary/
|   |   |-- data/
|   |   `-- presentation/
|   |       `-- cubit/
|   |           `-- itinerary_cubit.dart
|   `-- quiz/
|       `-- presentation/
|           `-- screens/
`-- presentation/
    `-- screens/
        `-- quiz/  # legacy duplicate folder scheduled for removal

test/
|-- unit/
|-- widget/
`-- integration/
```

**Structure Decision**: Use the constitution-aligned `lib/app`, `lib/core`, and `lib/features` layout as the target structure while explicitly removing the legacy duplicate quiz presentation folder. The feature intentionally preserves compatibility with the existing app shape implied by the request, but every moved responsibility lands in the constitution-approved layer.

## Phase 0: Research

- Validate the single authoritative location for quiz presentation so folder deletion does not orphan imports or routes.
- Confirm the shared fallback-name rule order so all profile display surfaces resolve the same text.
- Confirm the exact URL host patterns required for Unsplash and Picsum so the allowlist accepts valid CDN variants without broadening trust unnecessarily.
- Confirm the desired ownership boundary for Firestore quiz persistence so `ItineraryCubit.generateFromQuiz()` coordinates the save without leaking Firebase access into widgets.
- Confirm the minimal HomeScreen error-state behavior required when a `StreamBuilder` receives an error.

## Phase 1: Design

- Extract shared string resolution into a core utility contract used by home and any other profile display surfaces.
- Define routing composition boundaries between `app_router.dart` and `app_bloc_scope.dart`.
- Define itinerary generation lifecycle ownership, including success, retry, and failure persistence behavior.
- Define the legacy-to-target path cleanup for duplicate quiz presentation assets.
- Define the regression coverage needed for approved image hosts, home stream errors, and generation-side persistence.

## Post-Design Constitution Check

- `Layer Boundaries`: Maintained. Shared utility resides in `core`; app composition resides in `app`; quiz-save ownership sits with itinerary state logic rather than a screen.
- `State Ownership`: Maintained. `ItineraryCubit` owns generation flow side effects; `HomeScreen` renders stream states only.
- `Routing Contract`: Maintained. Route declarations stay centralized in `go_router` configuration after file split.
- `Firebase Isolation`: Maintained. Firebase persistence remains behind repository or cubit-coordinated data calls, not direct widget code.
- `Test Coverage`: Maintained. Research and design outputs define unit, bloc/cubit, widget, and integration validation for each affected behavior.

## Complexity Tracking

No constitution violations are required for this feature.
