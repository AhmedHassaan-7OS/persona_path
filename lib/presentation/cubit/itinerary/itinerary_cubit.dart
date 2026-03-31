import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/itinerary.dart';
import '../../../data/services/ai_service.dart';
import '../../../data/services/firestore_service.dart';
import 'itinerary_state.dart';

export 'itinerary_state.dart';

class ItineraryCubit extends Cubit<ItineraryState> {
  ItineraryCubit({AiService? aiService, FirestoreRepository? firestoreRepository})
      : _ai = aiService ?? AiService(),
        _firestore = firestoreRepository ?? FirestoreService(),
        super(const ItineraryState());

  final AiService _ai;
  final FirestoreRepository _firestore;

  Future<void> generate(String userId, Map<String, dynamic> answers) async {
    await _performGenerate(userId, answers);
  }

  Future<void> generateFromQuiz(String userId, Map<String, dynamic> answers) async {
    Object? firestoreError;
    final preferredStyle = answers.values.isNotEmpty ? answers.values.first.toString() : '';
    try {
      await _firestore.updateQuizAnswers(
        uid: userId,
        quizAnswers: answers,
        preferredTravelStyle: preferredStyle,
      );
    } catch (e) {
      firestoreError = e;
    }

    await _performGenerate(userId, answers);

    if (firestoreError != null) {
      throw firestoreError;
    }
  }

  Future<void> _performGenerate(String userId, Map<String, dynamic> answers) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final itinerary = await _ai.generateItinerary(userId: userId, answers: answers);
      emit(state.copyWith(isLoading: false, itinerary: itinerary));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<String?> saveCurrent() async {
    final itinerary = state.itinerary;
    if (itinerary == null) return null;
    if (state.isSaving) return null;
    emit(state.copyWith(isSaving: true, error: null));
    try {
      final id = await _firestore.saveItinerary(itinerary);
      emit(state.copyWith(isSaving: false, itinerary: itinerary.copyWithId(id)));
      return id;
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
      rethrow;
    }
  }
}
