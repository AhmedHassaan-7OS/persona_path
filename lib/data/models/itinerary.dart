import 'package:cloud_firestore/cloud_firestore.dart';

class Itinerary {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<String> days;
  final List<ActivityItem> activities;
  final List<String> imageUrls;
  final DateTime generatedAt;

  Itinerary({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.days,
    required this.activities,
    required this.imageUrls,
    required this.generatedAt,
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

    bool isAllowedImageUrl(String url) {
      final u = url.trim();
      if (!(u.startsWith('http://') || u.startsWith('https://'))) return false;
      final host = Uri.tryParse(u)?.host ?? '';
      return host.contains('picsum.photos');
    }

    List<String> seededPicsumUrls(String seed) {
      final s = seed.trim().isEmpty ? 'personapath' : seed.trim();
      return [
        'https://picsum.photos/seed/${Uri.encodeComponent(s)}/800/600',
        'https://picsum.photos/seed/${Uri.encodeComponent('${s}2')}/800/600',
        'https://picsum.photos/seed/${Uri.encodeComponent('${s}3')}/800/600',
      ];
    }

    final storedUrls = (map['imageUrls'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && !e.contains('example.com'))
        .where(isAllowedImageUrl)
        .toSet()
        .toList();

    final seed = '${map['userId'] ?? ''}_${map['title'] ?? ''}_$id';
    final rawUrls = storedUrls.isNotEmpty ? storedUrls : seededPicsumUrls(seed);

    return Itinerary(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      days: List<String>.from(map['days'] ?? const []),
      activities: (map['activities'] as List<dynamic>? ?? const [])
          .map((e) => ActivityItem.fromMap(e))
          .toList(),
      imageUrls: rawUrls,
      generatedAt: parsed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'days': days,
      'activities': activities.map((e) => e.toMap()).toList(),
      'imageUrls': imageUrls,
      'generatedAt': generatedAt,
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