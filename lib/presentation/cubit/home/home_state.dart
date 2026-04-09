import '../../../data/models/itinerary.dart';
import '../../../data/models/user_profile.dart';

class HomeState {
  final List<Itinerary> itineraries;
  final UserProfile? profile;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.itineraries = const [],
    this.profile,
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<Itinerary>? itineraries,
    UserProfile? profile,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      itineraries: itineraries ?? this.itineraries,
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
