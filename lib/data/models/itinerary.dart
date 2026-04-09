import 'package:cloud_firestore/cloud_firestore.dart';

class Itinerary {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<String> days;
  final List<ActivityItem> activities;
  final DateTime generatedAt;
  final Map<String, dynamic> quizAnswers;

  Itinerary({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.days,
    required this.activities,
    required this.generatedAt,
    required this.quizAnswers,
  });

  factory Itinerary.fromMap(String id, Map<String, dynamic> map) {
    final generated = map['generatedAt'];
    DateTime parsed;
    if (generated is Timestamp) {
      parsed = generated.toDate();
    } else if (generated is String) {
      parsed = DateTime.tryParse(generated) ?? DateTime.now();
    } else {
      parsed = DateTime.now();
    }

    final quizAnswers = <String, dynamic>{};
    if (map['quizAnswers'] is Map) {
      quizAnswers.addAll(Map<String, dynamic>.from(map['quizAnswers'] as Map));
    }

    return Itinerary(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      days: List<String>.from(map['days'] ?? const []),
      activities: (map['activities'] as List<dynamic>? ?? const [])
          .map((e) => ActivityItem.fromMap(e))
          .toList(),
      generatedAt: parsed,
      quizAnswers: quizAnswers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'days': days,
      'activities': activities.map((e) => e.toMap()).toList(),
      'generatedAt': generatedAt,
      'quizAnswers': quizAnswers,
    };
  }
}

class ActivityItem {
  final String day;
  final String time;
  final String title;
  final String note;

  const ActivityItem({
    required this.day,
    required this.time,
    required this.title,
    required this.note,
  });

  factory ActivityItem.fromMap(Map<String, dynamic> map) {
    return ActivityItem(
      day: map['day'] ?? '',
      time: map['time'] ?? '',
      title: map['title'] ?? '',
      note: map['note'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'time': time,
      'title': title,
      'note': note,
    };
  }
}

extension ItineraryCopyWith on Itinerary {
  Itinerary copyWithId(String id) {
    return Itinerary(
      id: id,
      userId: userId,
      title: title,
      description: description,
      days: days,
      activities: activities,
      generatedAt: generatedAt,
      quizAnswers: quizAnswers,
    );
  }
}
