import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:persona_path/data/models/itinerary.dart';
import 'package:persona_path/data/models/user_profile.dart';
import 'package:persona_path/data/services/firestore_service.dart';
import 'package:persona_path/presentation/cubit/auth/auth_session_cubit.dart';
import 'package:persona_path/presentation/cubit/auth/auth_session_state.dart';
import 'package:persona_path/presentation/cubit/quiz/quiz_cubit.dart';
import 'package:persona_path/presentation/screens/home_screen.dart';

class _TestUser extends Fake implements User {
  @override
  String get uid => 'test-user';

  @override
  String? get email => 'test@example.com';

  @override
  String? get displayName => null;
}

class _ErrorFirestoreRepository implements FirestoreRepository {
  @override
  Future<void> upsertUser({
    required String uid,
    required String email,
    required String displayName,
  }) async {}

  @override
  Future<void> updateQuizAnswers({
    required String uid,
    required Map<String, dynamic> quizAnswers,
    required String preferredTravelStyle,
  }) async {}

  @override
  Future<String> saveItinerary(Itinerary itinerary) async => 'id';

  @override
  Stream<UserProfile?> watchUserProfile(String uid) => const Stream.empty();

  @override
  Stream<List<Itinerary>> watchUserItineraries(String uid) =>
      Stream.error('boom');

  @override
  Future<Itinerary?> getItineraryById(String id) async => null;
}

class _TestAuthCubit extends AuthSessionCubit {
  _TestAuthCubit(User user) : super(user);
}

void main() {
  testWidgets('home displays error when itinerary stream fails', (
    tester,
  ) async {
    final authCubit = _TestAuthCubit(_TestUser());
    final quizCubit = QuizCubit();
    final repository = _ErrorFirestoreRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthSessionCubit>.value(value: authCubit),
            BlocProvider<QuizCubit>.value(value: quizCubit),
          ],
          child: HomeScreen(firestoreService: repository),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Itinerary service unavailable'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
