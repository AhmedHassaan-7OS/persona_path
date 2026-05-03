---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests are REQUIRED. Every generated task list MUST include the unit,
widget, and integration coverage needed by the constitution for the affected
behavior.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter app**: `lib/app/`, `lib/core/`, `lib/features/`, `test/unit/`,
  `test/widget/`, `test/integration/`
- Generated paths MUST reference the actual feature directories chosen in
  `plan.md`

<!-- 
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.
  
  The /speckit.tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/
  
  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment
  
  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize [language] project with [framework] dependencies
- [ ] T003 [P] Configure linting and formatting tools

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

Examples of foundational tasks (adjust based on your project):

- [ ] T004 Define or update shared domain contracts and use cases in `lib/core/`
- [ ] T005 [P] Configure dependency injection and feature composition
- [ ] T006 [P] Setup or update `go_router` route graph, guards, and redirects
- [ ] T007 Create base repositories, data sources, and Firebase adapters that all
  stories depend on
- [ ] T008 Configure error handling, result mapping, and logging infrastructure
- [ ] T009 Setup environment and Firebase configuration management

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T010 [P] [US1] Unit test for use case or repository behavior in `test/unit/[feature]/[name]_test.dart`
- [ ] T011 [P] [US1] BLoC/Cubit test for presentation state transitions in `test/unit/[feature]/[name]_bloc_test.dart`
- [ ] T012 [P] [US1] Widget or integration test for the primary user journey in `test/widget/` or `test/integration/`

### Implementation for User Story 1

- [ ] T013 [P] [US1] Create or update domain entities/contracts in `lib/core/` or `lib/features/[feature]/data/models/`
- [ ] T014 [P] [US1] Implement Firebase-backed data source or repository logic in `lib/features/[feature]/data/`
- [ ] T015 [US1] Implement BLoC/Cubit and immutable state in `lib/features/[feature]/presentation/`
- [ ] T016 [US1] Implement screen or widget flow in `lib/features/[feature]/presentation/`
- [ ] T017 [US1] Wire route entries, redirects, and navigation handoff in `lib/app/router/`
- [ ] T018 [US1] Add validation, failure mapping, and logging for user story 1 operations

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 2

- [ ] T019 [P] [US2] Unit test for changed domain or repository behavior in `test/unit/[feature]/`
- [ ] T020 [P] [US2] BLoC/Cubit test for state transitions in `test/unit/[feature]/`
- [ ] T021 [P] [US2] Widget or integration test for the user journey in `test/widget/` or `test/integration/`

### Implementation for User Story 2

- [ ] T022 [P] [US2] Create or update required models, entities, or contracts
- [ ] T023 [US2] Implement or extend data-layer Firebase integration
- [ ] T024 [US2] Implement BLoC/Cubit changes and presentation flow
- [ ] T025 [US2] Integrate with User Story 1 components through shared contracts

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 3

- [ ] T026 [P] [US3] Unit test for changed domain or repository behavior in `test/unit/[feature]/`
- [ ] T027 [P] [US3] BLoC/Cubit test for state transitions in `test/unit/[feature]/`
- [ ] T028 [P] [US3] Widget or integration test for the user journey in `test/widget/` or `test/integration/`

### Implementation for User Story 3

- [ ] T029 [P] [US3] Create or update required models, entities, or contracts
- [ ] T030 [US3] Implement or extend data-layer Firebase integration
- [ ] T031 [US3] Implement BLoC/Cubit changes and presentation flow
- [ ] T032 [US3] Wire routing or guarded navigation changes

**Checkpoint**: All user stories should now be independently functional

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Documentation and quickstart updates in `specs/[###-feature-name]/quickstart.md`
- [ ] TXXX Code cleanup and refactoring
- [ ] TXXX Performance optimization across all stories
- [ ] TXXX [P] Additional unit, widget, and integration coverage as needed
- [ ] TXXX Security hardening
- [ ] TXXX Run quickstart.md validation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story

- Tests MUST be written and FAIL before implementation
- Domain contracts before data implementations
- Data implementations before BLoC/Cubit integration
- BLoC/Cubit integration before route wiring and UI polish
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together:
Task: "Unit test for use case or repository behavior in test/unit/[feature]/[name]_test.dart"
Task: "BLoC/Cubit test for presentation state transitions in test/unit/[feature]/[name]_bloc_test.dart"
Task: "Widget or integration test for the primary user journey in test/widget/ or test/integration/"

# Launch independent implementation tasks for User Story 1 together:
Task: "Create or update domain entities/contracts"
Task: "Implement Firebase-backed data source or repository logic"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
