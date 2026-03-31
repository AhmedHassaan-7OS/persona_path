# Tasks: PersonaPath Refactor Fixes

**Input**: Design documents from `/specs/001-flutter-refactor-fixes/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests are REQUIRED. Every generated task list MUST include the unit, widget, and integration coverage needed by the constitution for the affected behavior.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter app**: `lib/app/`, `lib/core/`, `lib/features/`, `test/unit/`, `test/widget/`, `test/integration/`
- Generated paths MUST reference the actual feature directories chosen in `plan.md`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the refactor workspace and test scaffolding for the affected modules.

- [x] T001 Confirm directories used by this refactor exist: `lib/core/routing`, `lib/core/utils`, `lib/presentation/screens`, and the targeted test folders.
- [x] T002 Verify the test scaffolding for widget and integration suites under `test/widget/` and `test/integration/` can host the new coverage.
- [x] T003 [P] Add concrete spec coverage files in `test/unit/core/utils/string_utils_test.dart`, `test/unit/core/utils/image_url_allowlist_test.dart`, `test/unit/features/itinerary/presentation/cubit/itinerary_cubit_test.dart`, `test/widget/features/home/presentation/home_screen_test.dart`, and `test/integration/features/quiz/quiz_to_itinerary_flow_test.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**?? CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Move the fallback-name logic into `lib/core/utils/string_utils.dart` for reuse across widgets and cubits.
- [x] T005 [P] Wire `lib/data/services/ai_service.dart` and `lib/data/models/itinerary.dart` through `lib/core/utils/image_url_utils.dart` so Picsum and Unsplash URLs are allowed.
- [x] T006 [P] Extract `AppBlocScope` into `lib/core/routing/app_bloc_scope.dart` to keep the router definition focused on navigation.
- [x] T007 Update `lib/core/routing/app_router.dart` to import and consume the extracted `AppBlocScope` while keeping the same route graph.
- [x] T008 Remove the `_runNetworkProbe` startup probes from `lib/main.dart`, leaving the bootstrap lean.

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Stable Home Experience (Priority: P1) ?? MVP

**Goal**: Ensure the home experience avoids duplicate user writes and renders a recoverable stream error state.

**Independent Test**: Open HomeScreen with valid user data and with a failing itinerary-related stream; confirm no duplicate `upsertUser` behavior occurs and the UI shows an explicit error state.

### Tests for User Story 1

- [x] T009 [P] [US1] Verify `resolveFallbackName` with `test/unit/core/utils/string_utils_test.dart`
- [x] T010 [P] [US1] Confirm the HomeScreen stream error handling via `test/widget/features/home/presentation/home_screen_test.dart`

### Implementation for User Story 1

- [x] T011 [US1] Replace the in-widget `_fallbackName` and rely on `lib/core/utils/string_utils.dart` inside `lib/presentation/screens/home_screen.dart`
- [x] T012 [US1] Ensure the home screen only writes the user document once by guarding `_ensureUserDoc` in `lib/presentation/screens/home_screen.dart`
- [x] T013 [US1] Render a recoverable error card when `StreamBuilder` fails in `lib/presentation/screens/home_screen.dart`

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Reliable Quiz-to-Itinerary Flow (Priority: P2)

**Goal**: Make itinerary generation the single owner of quiz-result persistence and remove duplicate quiz presentation artifacts.

**Independent Test**: Complete the quiz flow once and verify the generated itinerary plus quiz-derived data are persisted only through `ItineraryCubit.generateFromQuiz()` with no partial saved result on failure.

### Tests for User Story 2

- [x] T014 [P] [US2] Cover `ItineraryCubit.generateFromQuiz()` once quiz answers flow through `test/unit/features/itinerary/presentation/cubit/itinerary_cubit_test.dart`
- [x] T015 [P] [US2] Exercise the quiz-to-itinerary UI path in `test/integration/features/quiz/quiz_to_itinerary_flow_test.dart`

### Implementation for User Story 2

- [x] T016 [US2] Delete the unused duplicate folder `lib/presentation/screens/quiz/`, keeping the active `sections/quiz` implementation.
- [x] T017 [US2] Collapse the quiz flow so `LoadingItineraryScreen` no longer talks to Firestore directly but relies on `ItineraryCubit`.
- [x] T018 [US2] Push Firestore quiz updates into `ItineraryCubit.generateFromQuiz()` so generation owns persistence.
- [x] T019 [US2] Persist the quiz context with each itinerary via `lib/data/models/itinerary.dart` and `lib/data/services/firestore_service.dart`.

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - Predictable Asset and App Startup Behavior (Priority: P3)

**Goal**: Preserve stable startup and routing behavior while enabling approved remote images to render successfully.

**Independent Test**: Launch the app, navigate through the affected flows, and verify approved Unsplash and Picsum images load while startup and routing behavior remain unchanged.

### Tests for User Story 3

- [x] T020 [P] [US3] Cover the new image allowlist via `test/unit/core/utils/image_url_allowlist_test.dart`
- [x] T021 [P] [US3] Ensure the routable loading flow still triggers the itinerary generator in `test/integration/features/quiz/quiz_to_itinerary_flow_test.dart`

### Implementation for User Story 3

- [x] T022 [US3] Point AI output and itinerary mapping at `lib/core/utils/image_url_utils.dart` so Unsplash/Picsum remain trusted.
- [x] T023 [US3] Confirm the bootstrap now composes `AppBlocScope` from `lib/core/routing/app_bloc_scope.dart` and drives `AppRouter` from `lib/main.dart`.

**Checkpoint**: All user stories should now be independently functional

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T024 [P] Update refactor validation notes in `specs/001-flutter-refactor-fixes/quickstart.md` if implementation details change during execution
- [ ] T025 Run the full validation sequence referenced by `specs/001-flutter-refactor-fixes/quickstart.md` and record any follow-up fixes in the touched source and test files

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel if staffing allows, but US2 depends on the shared utility, router split, and startup cleanup completed in Phase 2
  - US3 depends on the shared allowlist and router split completed in Phase 2
- **Polish (Phase 6)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational and delivers the MVP home stability improvements
- **User Story 2 (P2)**: Starts after Foundational and should follow US1 when validating end-to-end regression impact on home and itinerary flows
- **User Story 3 (P3)**: Starts after Foundational and can run in parallel with US2 after the foundational router split and allowlist update land

### Within Each User Story

- Tests MUST be written and FAIL before implementation
- Shared utilities before screen adoption
- Data and state ownership changes before UI integration cleanup
- Route and startup verification before final polish
- Story complete before moving to next priority for release decisions

### Parallel Opportunities

- `T003`, `T005`, and `T006` can run in parallel during shared setup and foundational work
- `T009` and `T010` can run in parallel for User Story 1
- `T014` and `T015` can run in parallel for User Story 2
- `T020` and `T021` can run in parallel for User Story 3
- After Phase 2, User Story 2 and User Story 3 can be staffed in parallel because they touch mostly different files

---

## Parallel Example: User Story 1

```bash
Task: "Add unit tests for shared fallback-name resolution in test/unit/core/utils/string_utils_test.dart"
Task: "Add widget tests for HomeScreen loading, success, and stream-error rendering in test/widget/features/home/presentation/home_screen_test.dart"
```

## Parallel Example: User Story 2

```bash
Task: "Add bloc or cubit tests for ItineraryCubit.generateFromQuiz() success, failure, and retry persistence ownership in test/unit/features/itinerary/presentation/cubit/itinerary_cubit_test.dart"
Task: "Add integration coverage for the quiz-to-itinerary persistence flow in test/integration/features/quiz/quiz_to_itinerary_flow_test.dart"
```

## Parallel Example: User Story 3

```bash
Task: "Add unit tests for approved Unsplash and Picsum URL acceptance in test/unit/core/utils/image_url_allowlist_test.dart"
Task: "Add widget or integration assertions for startup and routing stability after the router split in test/integration/features/quiz/quiz_to_itinerary_flow_test.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test HomeScreen independently for duplicate upsert removal and stream-error rendering
5. Deploy or demo if ready

### Incremental Delivery

1. Complete Setup + Foundational ? foundation ready
2. Add User Story 1 ? test independently ? validate home stability
3. Add User Story 2 ? test independently ? validate quiz-to-itinerary persistence
4. Add User Story 3 ? test independently ? validate startup, routing, and approved image behavior
5. Run polish validation across all stories

### Parallel Team Strategy

With multiple developers:

1. One developer handles shared utilities and router split in Phase 2
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Merge after each story passes its independent tests and then run the final quickstart validation

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a specific user story for traceability
- Each user story remains independently testable from the specification
- The current repository snapshot does not include the Flutter app source, so implementation paths are taken from the approved plan and refactor request
- All tasks follow the required checklist format with checkbox, ID, labels where applicable, and file paths
