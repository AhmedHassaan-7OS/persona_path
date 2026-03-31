# PersonaPath — Refactor Spec
> Feed this file to Codex (or any AI coding tool).  
> Each task is self-contained. Do them in order.

---

## Context

Flutter app called **PersonaPath**.  
State management: `flutter_bloc` (Cubit pattern).  
Navigation: `go_router`.  
Backend: Firebase Auth + Firestore + AI REST endpoint.

---

## Task 1 — Delete the duplicate quiz folder

**Problem:** `lib/presentation/screens/quiz/` is an exact copy of
`lib/presentation/sections/quiz/`. The canonical one is `sections/quiz/`.

**Instructions:**
1. Delete the entire folder `lib/presentation/screens/quiz/` and everything inside it.
2. Make sure `lib/presentation/screens/quiz_screen.dart` imports from the correct path:

```dart
// lib/presentation/screens/quiz_screen.dart
import '../sections/quiz/quiz_screen_body.dart';
```

---

## Task 2 — Create `lib/core/utils/string_utils.dart`

**Problem:** The helper function `_fallbackName` is copy-pasted in three cubits
(`sign_in_cubit.dart`, `sign_up_cubit.dart`, `google_sign_in_cubit.dart`).

**Instructions:**  
Create a new file with this exact content:

```dart
// lib/core/utils/string_utils.dart

/// Returns a display name derived from an email address.
/// Example: "john@example.com" → "john"
/// Falls back to 'Traveler' for malformed addresses.
String fallbackDisplayName(String email) {
  final at = email.indexOf('@');
  if (at <= 0) return 'Traveler';
  return email.substring(0, at);
}
```

Then in each of the three cubits:
- Remove the private `_fallbackName` method.
- Add the import: `import '../../../core/utils/string_utils.dart';`
- Replace every call to `_fallbackName(x)` with `fallbackDisplayName(x)`.

---

## Task 3 — Fix the image URL allowlist in `AiService`

**File:** `lib/data/services/ai_service.dart`

**Problem:** `_isAllowedImageUrl` only accepts `picsum.photos`, but the AI
prompt asks for Unsplash images — so all Unsplash URLs are silently dropped
and replaced with random Picsum images.

**Instructions:**  
Replace the `_isAllowedImageUrl` method with:

```dart
static const _allowedImageHosts = [
  'images.unsplash.com',
  'unsplash.com',
  'source.unsplash.com',
  'picsum.photos',
];

static bool _isAllowedImageUrl(String url) {
  final trimmed = url.trim();
  if (!trimmed.startsWith('https://')) return false;
  final host = Uri.tryParse(trimmed)?.host ?? '';
  return _allowedImageHosts.any(
    (allowed) => host == allowed || host.endsWith('.$allowed'),
  );
}
```

No other changes to this file.

---

## Task 4 — Split `app_router.dart` into two files

**Problem:** `app_router.dart` contains three unrelated things:
the router, `AppBlocScope`, and `GoRouterRefreshStream`. 

**Instructions:**

### 4a — Create `lib/core/routing/app_bloc_scope.dart`

Move `AppBlocScope` and `GoRouterRefreshStream` out of `app_router.dart`
into this new file. Keep all imports they need.

```dart
// lib/core/routing/app_bloc_scope.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ... all cubit imports ...

class AppBlocScope extends StatelessWidget {
  // (same implementation, just moved here)
}

class GoRouterRefreshStream extends ChangeNotifier {
  // (same implementation, just moved here)
}
```

### 4b — Clean up `app_router.dart`

- Remove `AppBlocScope` and `GoRouterRefreshStream` class definitions.
- Add the import: `import 'app_bloc_scope.dart';`
- The file should now only contain the `AppRouter` class.

### 4c — Update `main.dart`

- Change the `AppBlocScope` import to:  
  `import 'core/routing/app_bloc_scope.dart';`

---

## Task 5 — Remove the network probe from `main.dart`

**File:** `lib/main.dart`

**Problem:** `_runNetworkProbe()` makes HTTP requests on every app start
and prints to the console. This is debug code that should not ship.

**Instructions:**
1. Delete the entire `_runNetworkProbe` function and its inner `probe` helper.
2. Remove the call `_runNetworkProbe();` from `main()`.
3. Remove the `import 'package:http/http.dart' as http;` line if it is now unused.

---

## Task 6 — Fix `HomeScreen`: remove duplicate `upsertUser` and add error handling

**File:** `lib/presentation/screens/home_screen.dart`

**Problem A:** `HomeScreen` calls `_firestore.upsertUser(...)` in `initState`.
This is already done by every sign-in cubit, so it runs twice on login.

**Problem B:** The `StreamBuilder<List<Itinerary>>` has no `hasError` check,
so Firestore failures produce a blank screen with no feedback.

**Instructions:**

1. Convert `HomeScreen` from `StatefulWidget` to `StatelessWidget`
   (the only state was for `_ensureUserDoc`).

2. Remove:
   - The `_HomeScreenState` class entirely.
   - The `_firestore` field (re-add it as a `static final` on the widget class
     so it is shared, not re-created on every build).
   - The `initState` override.
   - The `_ensureUserDoc` method.
   - The private `_fallbackName` method — use `fallbackDisplayName` from
     `string_utils.dart` instead (add the import).

3. Inside the `StreamBuilder<List<Itinerary>>` builder, add an error branch
   **before** reading `snapshot.data`:

```dart
if (snapshot.hasError) {
  return Center(
    child: Text(
      'Could not load itineraries.\n${snapshot.error}',
      textAlign: TextAlign.center,
    ),
  );
}
```

---

## Task 7 — Move quiz-answer saving into `ItineraryCubit`

**Problem:** `LoadingItineraryScreen` directly instantiates `FirestoreService`
to save quiz answers, then calls `itineraryCubit.generate(...)` separately.
Screens should not talk to Firestore directly.

### 7a — Update `ItineraryCubit`

**File:** `lib/presentation/cubit/itinerary/itinerary_cubit.dart`

Replace the `generate` method with `generateFromQuiz`:

```dart
/// Saves quiz answers to Firestore, then calls the AI.
/// Screens only need to call this one method.
Future<void> generateFromQuiz({
  required String userId,
  required Map<String, dynamic> answers,
}) async {
  emit(state.copyWith(isLoading: true, error: null));

  final preferredStyle =
      answers.values.isNotEmpty ? answers.values.first.toString() : '';

  try {
    await _firestore.updateQuizAnswers(
      uid: userId,
      quizAnswers: answers,
      preferredTravelStyle: preferredStyle,
    );
  } catch (e) {
    // Non-fatal: failing to save answers should not block itinerary generation.
    emit(state.copyWith(error: 'Could not save quiz answers: $e'));
  }

  try {
    final itinerary = await _ai.generateItinerary(
      userId: userId,
      answers: answers,
    );
    emit(state.copyWith(isLoading: false, itinerary: itinerary));
  } catch (e) {
    emit(state.copyWith(isLoading: false, error: e.toString()));
  }
}
```

### 7b — Update `LoadingItineraryScreen`

**File:** `lib/presentation/screens/loading_itinerary_screen.dart`

1. Remove the `final _firestore = FirestoreService();` field.
2. Remove the `import` for `firestore_service.dart`.
3. In `_generate()`, replace the two separate try/catch blocks
   (Firestore save + AI call) with a single call:

```dart
await context.read<ItineraryCubit>().generateFromQuiz(
  userId: user.uid,
  answers: answers,
);
```

---

## Verification checklist

After all tasks are done, confirm:

- [ ] `lib/presentation/screens/quiz/` folder does not exist.
- [ ] `_fallbackName` does not appear anywhere — only `fallbackDisplayName`.
- [ ] `_isAllowedImageUrl` accepts `images.unsplash.com`.
- [ ] `AppBlocScope` is defined in `app_bloc_scope.dart`, not `app_router.dart`.
- [ ] `main.dart` has no `_runNetworkProbe` and no `http` import.
- [ ] `HomeScreen` is a `StatelessWidget` with no `upsertUser` call.
- [ ] `StreamBuilder<List<Itinerary>>` in `HomeScreen` has `snapshot.hasError` handling.
- [ ] `LoadingItineraryScreen` has no `FirestoreService` field.
- [ ] `ItineraryCubit` has `generateFromQuiz` (not the old `generate`).