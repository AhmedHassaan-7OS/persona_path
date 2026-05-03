import 'package:flutter_test/flutter_test.dart';
import 'package:persona_path/data/models/itinerary.dart';
import 'package:persona_path/data/services/api_service.dart';
import 'package:persona_path/presentation/cubit/itinerary/itinerary_cubit.dart';

/// Mock ApiService for testing
class FakeApiService extends ApiService {
  FakeApiService({required this.mockItinerary});

  final Itinerary mockItinerary;
  Map<String, dynamic>? savedQuiz;

  @override
  Future<Itinerary> generateItinerary({
    required Map<String, dynamic> answers,
    required int userId,
  }) async {
    return mockItinerary;
  }

  @override
  Future<Map<String, dynamic>> saveQuiz(Map<String, dynamic> quizData) async {
    savedQuiz = quizData;
    return {'qid': 1, ...quizData};
  }

  @override
  Future<Map<String, dynamic>> saveItinerary({
    required String name,
    required String description,
    required String itineraryContent,
    int? qid,
  }) async {
    return {'tid': 1, 'name': name};
  }
}

void main() {
  test('generateFromQuiz saves quiz and emits itinerary', () async {
    final answers = {'mood': 'calm'};
    final itinerary = Itinerary(
      id: '',
      userlocalId: 1,
      title: 'Title',
      description: 'Desc',
      days: const ['Day 1'],
      activities: const [],
      generatedAt: DateTime.now(),
      quizAnswers: answers,
    );

    final fakeApi = FakeApiService(mockItinerary: itinerary);
    final cubit = ItineraryCubit(api: fakeApi);

    await cubit.generateFromQuiz(1, answers);

    expect(cubit.state.itinerary?.userlocalId, 1);
    expect(cubit.state.itinerary?.quizAnswers, answers);
  });
}
