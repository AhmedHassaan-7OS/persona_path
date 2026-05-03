/// PersonaPath — Home Cubit
///
/// Fetches user's itineraries and last quiz from the server API.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/api_service.dart';
import 'home_state.dart';

export 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({ApiService? api})
      : _api = api ?? ApiService(),
        super(const HomeState());

  final ApiService _api;

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      // Fetch itineraries and quizzes in parallel
      final itineraries = await _api.getMyItineraries();

      Map<String, dynamic>? lastQuiz;
      try {
        final quizzes = await _api.getMyQuizzes();
        if (quizzes.isNotEmpty) {
          lastQuiz = quizzes.first;
        }
      } catch (_) {}

      emit(state.copyWith(
        isLoading: false,
        itineraries: itineraries,
        lastQuiz: lastQuiz,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> refresh() async {
    await init();
  }
}
