import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:persona_path/data/models/itinerary.dart';
import 'package:persona_path/data/models/user_profile.dart';
import 'package:persona_path/data/services/ai_service.dart';
import 'package:persona_path/data/services/firestore_service.dart';
import 'package:persona_path/presentation/cubit/auth/auth_session_cubit.dart';
import 'package:persona_path/presentation/cubit/auth/auth_session_state.dart';
import 'package:persona_path/presentation/cubit/quiz/quiz_cubit.dart';
import 'package:persona_path/presentation/cubit/itinerary/itinerary_cubit.dart';
import 'package:persona_path/presentation/screens/loading_itinerary_screen.dart';

class _TestUser extends Fake implements User {
  @override
  String get uid => 'integration-user';

  @override
  String? get email => 'integration@example.com';

  @override
  String? get displayName => 'Integration';
}

class FakeAiService extends AiService {
  @override
  Future<Itinerary> generateItinerary({
    required String userId,
    required Map<String, dynamic> answers,
  }) async {
    return Itinerary(
      id: '',
      userId: userId,
      title: 'Generated',
      description: 'desc',
      days: const ['Day 1'],
      activities: const [],
      imageUrls: const [],
      generatedAt: DateTime.now(),
      quizAnswers: Map<String, dynamic>.from(answers),
    );
  }
}

class _InMemoryFirestoreRepository implements FirestoreRepository {
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
      const Stream.empty();

  @override
  Future<Itinerary?> getItineraryById(String id) async => null;
}

class _SpyItineraryCubit extends ItineraryCubit {
  _SpyItineraryCubit(AiService aiService, FirestoreRepository repository)
    : super(aiService: aiService, firestoreRepository: repository);

  bool generateFromQuizCalled = false;

  @override
  Future<void> generateFromQuiz(
    String userId,
    Map<String, dynamic> answers,
  ) async {
    generateFromQuizCalled = true;
    await super.generateFromQuiz(userId, answers);
  }
}

class _TestAuthCubit extends AuthSessionCubit {
  _TestAuthCubit(User user) : super(user);
}

void main() {
  testWidgets('loading screen triggers itinerary generation', (tester) async {
    final authCubit = _TestAuthCubit(_TestUser());
    final quizCubit = QuizCubit();
    quizCubit.selectAnswer('mood', 'calm');
    final repository = _InMemoryFirestoreRepository();
    final aiService = FakeAiService();
    final cubit = _SpyItineraryCubit(aiService, repository);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<AuthSessionCubit>.value(value: authCubit),
              BlocProvider<QuizCubit>.value(value: quizCubit),
              BlocProvider<ItineraryCubit>.value(value: cubit),
            ],
            child: const LoadingItineraryScreen(),
          ),
        ),
        GoRoute(
          path: '/itinerary-result',
          builder: (context, state) => const Scaffold(body: SizedBox()),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.pumpAndSettle();

    expect(cubit.generateFromQuizCalled, isTrue);
  });
}
