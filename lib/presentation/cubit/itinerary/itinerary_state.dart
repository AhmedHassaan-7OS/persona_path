import '../../../data/models/itinerary.dart';

class ItineraryState {
  final bool isLoading;
  final bool isSaving;
  final Itinerary? itinerary;
  final String? error;

  const ItineraryState({
    this.isLoading = false,
    this.isSaving = false,
    this.itinerary,
    this.error,
  });

  ItineraryState copyWith({
    bool? isLoading,
    bool? isSaving,
    Itinerary? itinerary,
    String? error,
  }) {
    return ItineraryState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      itinerary: itinerary ?? this.itinerary,
      error: error,
    );
  }
}
