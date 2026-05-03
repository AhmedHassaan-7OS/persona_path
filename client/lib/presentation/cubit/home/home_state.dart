/// PersonaPath — Home State

import '../../../data/models/itinerary.dart';

class HomeState {
  final bool isLoading;
  final List<Itinerary> itineraries;
  final Map<String, dynamic>? lastQuiz;
  final String? error;

  const HomeState({
    this.isLoading = false,
    this.itineraries = const [],
    this.lastQuiz,
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    List<Itinerary>? itineraries,
    Map<String, dynamic>? lastQuiz,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      itineraries: itineraries ?? this.itineraries,
      lastQuiz: lastQuiz ?? this.lastQuiz,
      error: error,
    );
  }
}
