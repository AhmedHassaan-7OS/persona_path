<!--
Sync Impact Report
- Version change: template -> 1.0.0
- Modified principles:
  - Template Principle 1 -> I. Layered Architecture Enforcement
  - Template Principle 2 -> II. BLoC/Cubit Owns Presentation State
  - Template Principle 3 -> III. go_router Is the Single Navigation Surface
  - Template Principle 4 -> IV. Firebase Stays Behind Data Boundaries
  - Template Principle 5 -> V. Testable Delivery Is Mandatory
- Added sections:
  - Stack Constraints
  - Delivery Workflow
- Removed sections:
  - None
- Templates requiring updates:
  - updated: .specify/templates/plan-template.md
  - updated: .specify/templates/spec-template.md
  - updated: .specify/templates/tasks-template.md
  - reviewed: .specify/templates/agent-file-template.md
  - pending: .specify/templates/commands/ (directory not present in this repository)
- Follow-up TODOs:
  - None
-->
# PersonaPath Flutter Constitution

## Core Principles

### I. Layered Architecture Enforcement
Every feature MUST preserve clean architecture boundaries across `core`, `data`,
and `presentation`. `presentation` may depend on `core` contracts and use cases,
`data` may depend on `core` contracts and external services, and `core` MUST not
depend on Flutter UI packages, Firebase SDKs, or route implementations. Shared
cross-feature utilities belong in `core` only when they are framework-agnostic
or explicitly defined as app-wide abstractions. This rule exists to keep domain
logic portable, testable, and resistant to framework churn.

### II. BLoC/Cubit Owns Presentation State
User-facing state transitions MUST be coordinated through BLoC or Cubit classes.
Widgets MUST remain declarative and may not contain business rules, persistence
logic, or navigation branching beyond rendering state and dispatching intents.
Each feature MUST define explicit events or public Cubit methods, immutable state
objects, and predictable error/loading handling. This rule exists so behavior is
observable, reviewable, and unit-testable outside the widget tree.

### III. go_router Is the Single Navigation Surface
Application navigation MUST be declared through `go_router` and treated as a
first-class contract. Route names, path parameters, redirects, and guards MUST
be centralized in routing configuration instead of being scattered through UI
code. Navigation decisions that depend on authentication, onboarding, or feature
access MUST be expressed through route guards or redirect logic backed by app
state. This rule exists to prevent fragmented navigation flows and regressions in
deep linking and guarded access.

### IV. Firebase Stays Behind Data Boundaries
Firebase services MUST be accessed only from `data` layer implementations such as
repositories, remote data sources, or adapters. `presentation` and `core` MUST
not import Firebase SDK types directly. Domain-facing contracts MUST expose app
language rather than vendor language, and Firebase-specific mapping, security,
serialization, and error translation MUST stay in the `data` layer. This rule
exists to keep the app replaceable, testable, and insulated from backend detail.

### V. Testable Delivery Is Mandatory
All feature work MUST include automated tests for the behavior it introduces or
changes. At minimum, use cases, repositories, and BLoC/Cubit logic require unit
tests; route guards and Firebase-backed flows require integration coverage when
their behavior spans multiple layers; widgets that encode non-trivial rendering
or interaction states require widget tests. A feature is not complete until the
generated quickstart and test instructions verify the main user path. This rule
exists because architecture without executable verification degrades quickly.

## Stack Constraints

The default application stack is Flutter with Dart, `flutter_bloc` or compatible
BLoC/Cubit tooling, `go_router` for navigation, and Firebase for backend
capabilities. New dependencies MUST be justified in the implementation plan when
the existing stack can reasonably solve the problem.

Source organization MUST map to the architecture:

- `lib/core/` for shared domain contracts, use cases, base failures, and common
  framework-agnostic utilities
- `lib/features/<feature>/data/` for models, data sources, repository
  implementations, and Firebase adapters
- `lib/features/<feature>/presentation/` for screens, widgets, Cubits/BLoCs, and
  view models
- `lib/app/` or equivalent top-level composition area for app bootstrap, DI, and
  routing configuration

Cross-feature dependencies MUST flow through `core` contracts or explicitly
approved shared modules. Copying Firebase queries, route definitions, or business
rules between features is prohibited.

## Delivery Workflow

Every feature plan MUST document:

- Which layers are touched and why
- Which BLoC/Cubit units are introduced or modified
- Which `go_router` routes, redirects, or guards change
- Which Firebase services, collections, or auth flows are affected
- Which unit, widget, and integration tests prove the change

Every task list MUST group work by user story while preserving the order:
contracts and entities, data implementations, state management, UI/routing
integration, then automated validation. Pull requests MUST identify any
intentional boundary exceptions in the Complexity Tracking section of the plan and
justify why a simpler compliant option was rejected.

## Governance

This constitution overrides conflicting local conventions for architecture,
navigation, state management, and data access. Amendments require a documented
update to this file, a summary of impacted templates, and any migration guidance
needed for in-flight work.

Versioning policy follows semantic versioning for governance:

- MAJOR for removing or redefining principles in a backward-incompatible way
- MINOR for adding a principle or materially expanding mandatory guidance
- PATCH for clarifications that do not change required behavior

Compliance review is mandatory at plan creation, task generation, code review,
and pre-merge validation. Any feature that violates a principle MUST record the
exception in the plan's Complexity Tracking section and receive explicit approval
before implementation proceeds.

**Version**: 1.0.0 | **Ratified**: 2026-03-31 | **Last Amended**: 2026-03-31
