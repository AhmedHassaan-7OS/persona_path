/// PersonaPath — Itinerary Cubit
///
/// Handles AI itinerary generation (via server) and saving to the database.
/// No longer uses Firestore or client-side AI calls.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/itinerary.dart';
import '../../../data/services/api_service.dart';
import 'itinerary_state.dart';

export 'itinerary_state.dart';

class ItineraryCubit extends Cubit<ItineraryState> {
  ItineraryCubit({ApiService? api})
      : _api = api ?? ApiService(),
        super(const ItineraryState());

  final ApiService _api;

  /// Generate itinerary from answers (calls server AI endpoint)
  Future<void> generate(int userId, Map<String, dynamic> answers) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final itinerary = await _api.generateItinerary(
        userId: userId,
        answers: answers,
      );
      emit(state.copyWith(isLoading: false, itinerary: itinerary));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Generate from quiz and also save quiz answers to server
  Future<void> generateFromQuiz(int userId, Map<String, dynamic> answers) async {
    // Save quiz answers to server
    try {
      await _api.saveQuiz({
        'name': 'Personality Archetype Quiz',
        'peace_ans': answers['What kind of morning feels perfect to you?'] ?? '',
        'landscape_ans': answers['Choose your favorite scenery'] ?? '',
        'nightlife_ans': answers['Your evening vibe'] ?? '',
        'motv_ans': answers['Your ideal afternoon is...'] ?? '',
        'duration': 5,
        'price_range': '\$\$',
        'trip_desc': answers.values.join(', '),
      });
    } catch (_) {
      // Quiz save failure is non-fatal — continue to generate
    }

    await generate(userId, answers);
  }

  /// Save the current itinerary to the server
  Future<String?> saveCurrent() async {
    final itinerary = state.itinerary;
    if (itinerary == null) return null;
    if (state.isSaving) return null;

    emit(state.copyWith(isSaving: true, error: null));
    try {
      final data = await _api.saveItinerary(
        name: itinerary.title,
        description: itinerary.description,
        itineraryContent: itinerary.toContentJson(),
      );
      final tid = data['tid']?.toString() ?? '';
      emit(state.copyWith(
        isSaving: false,
        itinerary: itinerary.copyWithId(tid),
      ));
      return tid;
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
      rethrow;
    }
  }
}
