import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/itinerary.dart';
import '../../../data/services/ai_service.dart';
import '../../../data/services/firestore_service.dart';
import 'itinerary_state.dart';

export 'itinerary_state.dart';

class ItineraryCubit extends Cubit<ItineraryState> {
  ItineraryCubit({AiService? aiService, FirestoreService? firestoreService})
      : _ai = aiService ?? AiService(),
        _firestore = firestoreService ?? FirestoreService(),
        super(const ItineraryState());

  final AiService _ai;
  final FirestoreService _firestore;

  Future<void> generate(String userId, Map<String, dynamic> answers) async {
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

extension on Itinerary {
  Itinerary copyWithId(String id) {
    return Itinerary(
      id: id,
      userId: userId,
      title: title,
      description: description,
      days: days,
      activities: activities,
      imageUrls: imageUrls,
      generatedAt: generatedAt,
    );
  }
}
