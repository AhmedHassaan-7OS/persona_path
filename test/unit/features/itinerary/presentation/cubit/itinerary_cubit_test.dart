import 'package:flutter_test/flutter_test.dart';
import 'package:persona_path/data/models/itinerary.dart';
import 'package:persona_path/data/models/user_profile.dart';
import 'package:persona_path/data/services/ai_service.dart';
import 'package:persona_path/data/services/firestore_service.dart';
import 'package:persona_path/presentation/cubit/itinerary/itinerary_cubit.dart';

class FakeAiService extends AiService {
  FakeAiService(this.itinerary);

  final Itinerary itinerary;

  @override
  Future<Itinerary> generateItinerary({
    required String userId,
    required Map<String, dynamic> answers,
  }) async {
    return itinerary;
  }
}

class FakeFirestoreRepository implements FirestoreRepository {
  Map<String, dynamic>? quizAnswers;

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
  }) async {
    this.quizAnswers = Map<String, dynamic>.from(quizAnswers);
  }

  @override
  Future<String> saveItinerary(Itinerary itinerary) async => 'saved-id';

  @override
  Stream<UserProfile?> watchUserProfile(String uid) => const Stream.empty();

  @override
  Stream<List<Itinerary>> watchUserItineraries(String uid) =>
      const Stream.empty();

  @override
  Future<Itinerary?> getItineraryById(String id) async => null;
}

void main() {
  test('generateFromQuiz updates quiz answers and emits itinerary', () async {
    final answers = {'mood': 'calm'};
    final itinerary = Itinerary(
      id: '',
      userId: 'user',
      title: 'Title',
      description: 'Desc',
      days: const ['Day 1'],
      activities: const [],
      generatedAt: DateTime.now(),
      quizAnswers: answers,
    );

    final firestore = FakeFirestoreRepository();
    final cubit = ItineraryCubit(
      aiService: FakeAiService(itinerary),
      firestoreRepository: firestore,
    );

    await cubit.generateFromQuiz('user', answers);

    expect(firestore.quizAnswers, answers);
    expect(cubit.state.itinerary?.userId, 'user');
    expect(cubit.state.itinerary?.quizAnswers, answers);
  });
}
