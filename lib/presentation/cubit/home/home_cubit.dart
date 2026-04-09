import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/firestore_service.dart';
import 'home_state.dart';

export 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({FirestoreRepository? firestore})
      : _firestore = firestore ?? FirestoreService(),
        super(const HomeState());

  final FirestoreRepository _firestore;
  StreamSubscription? _itinerarySub;
  StreamSubscription? _profileSub;

  Future<void> init({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    if (uid.isEmpty) return;
    emit(state.copyWith(isLoading: true));
    try {
      await _firestore.upsertUser(
        uid: uid,
        email: email,
        displayName: displayName,
      );
    } catch (_) {}

    _itinerarySub = _firestore.watchUserItineraries(uid).listen(
      (items) => emit(state.copyWith(itineraries: items, isLoading: false)),
      onError: (e) => emit(state.copyWith(isLoading: false, error: e.toString())),
    );

    _profileSub = _firestore.watchUserProfile(uid).listen(
      (profile) => emit(state.copyWith(profile: profile)),
    );
  }

  @override
  Future<void> close() {
    _itinerarySub?.cancel();
    _profileSub?.cancel();
    return super.close();
  }
}
