import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../core/config/env.dart';
import '../models/itinerary.dart';
import '../models/user_profile.dart';

abstract class FirestoreRepository {
  Future<void> upsertUser({
    required String uid,
    required String email,
    required String displayName,
  });

  Future<void> updateQuizAnswers({
    required String uid,
    required Map<String, dynamic> quizAnswers,
    required String preferredTravelStyle,
  });

  Future<String> saveItinerary(Itinerary itinerary);

  Stream<UserProfile?> watchUserProfile(String uid);

  Stream<List<Itinerary>> watchUserItineraries(String uid);

  Future<Itinerary?> getItineraryById(String id);
}

class FirestoreService implements FirestoreRepository {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? _createFirestore();

  final FirebaseFirestore _firestore;

  static FirebaseFirestore _createFirestore() {
    final databaseId = AppEnv.firestoreDatabaseId.trim();
    if (databaseId.isEmpty) {
      return FirebaseFirestore.instance;
    }

    return FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: databaseId,
    );
  }

  @override
  Future<void> upsertUser({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'quizAnswers': {},
      'preferredTravelStyle': '',
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> updateQuizAnswers({
    required String uid,
    required Map<String, dynamic> quizAnswers,
    required String preferredTravelStyle,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'quizAnswers': quizAnswers,
      'preferredTravelStyle': preferredTravelStyle,
    }, SetOptions(merge: true));
  }

  @override
  Stream<UserProfile?> watchUserProfile(String uid) {
    if (uid.trim().isEmpty) return const Stream<UserProfile?>.empty();
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return null;
      return UserProfile.fromMap(data);
    });
  }

  @override
  Future<String> saveItinerary(Itinerary itinerary) async {
    final doc = await _firestore.collection('itineraries').add(itinerary.toMap());
    return doc.id;
  }

  @override
  Stream<List<Itinerary>> watchUserItineraries(String uid) {
    return _firestore
        .collection('itineraries')
        .where('userId', isEqualTo: uid)
        .orderBy('generatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Itinerary.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  @override
  Future<Itinerary?> getItineraryById(String id) async {
    final doc = await _firestore.collection('itineraries').doc(id).get();
    if (!doc.exists) return null;
    return Itinerary.fromMap(doc.id, doc.data()!);
  }
}
