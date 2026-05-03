# Data Model: PersonaPath Refactor Fixes

## UserProfileSummary

- Purpose: Represents the user-facing identity details displayed in greeting or profile-adjacent surfaces.
- Fields:
  - `userId`: stable user identifier
  - `displayName`: preferred resolved name shown in the UI
  - `firstName`: optional source field
  - `lastName`: optional source field
  - `email`: optional fallback source field
- Validation Rules:
  - `displayName` must always resolve to a non-empty string before rendering.
  - Fallback priority must be deterministic across all consumers.
- Relationships:
  - Used by HomeScreen and any other presentation surface showing user identity.

## RemoteImageSource

- Purpose: Represents a validated remote image reference accepted by the app.
- Fields:
  - `url`: full remote image URL
  - `provider`: approved host classification such as Unsplash or Picsum
  - `isAllowed`: validation result
- Validation Rules:
  - The provider must belong to the approved allowlist.
  - URL parsing failures must resolve to a rejected state.
- Relationships:
  - Consumed by presentation widgets that render remote imagery.

## QuizResponseSet

- Purpose: Represents the answers collected from the trip-planning quiz before itinerary generation.
- Fields:
  - `responseId`: client or backend identifier for the quiz submission
  - `userId`: owner of the responses
  - `answers`: structured quiz responses
  - `submittedAt`: completion timestamp
- Validation Rules:
  - Required quiz prompts must be present before generation can start.
  - Answers used for a saved itinerary must match the generation request that produced it.
- Relationships:
  - Feeds `ItineraryGenerationRequest` and remains associated with `GeneratedItinerary`.

## ItineraryGenerationRequest

- Purpose: Represents the command to generate an itinerary from quiz inputs.
- Fields:
  - `userId`: requesting user
  - `quizResponses`: source quiz response set
  - `requestState`: idle, running, success, or failure
  - `retryCount`: number of retried attempts
- Validation Rules:
  - A request may persist results only on successful completion.
  - Failed attempts must not create a misleading completed itinerary record.
- Relationships:
  - Owned by `ItineraryCubit.generateFromQuiz()`.
  - Produces `GeneratedItinerary` on success.

## GeneratedItinerary

- Purpose: Represents the final persisted trip-planning result.
- Fields:
  - `itineraryId`: stable itinerary identifier
  - `userId`: owner of the itinerary
  - `destinations`: generated trip stops
  - `schedule`: generated timing structure
  - `sourceQuizResponseId`: quiz response set that produced the itinerary
  - `savedAt`: persistence timestamp
- Validation Rules:
  - A saved itinerary must reference the quiz response set that generated it.
  - Duplicate saves for the same successful generation request are not allowed.
- Relationships:
  - Persisted through itinerary-generation flow and later consumed by home or itinerary views.
