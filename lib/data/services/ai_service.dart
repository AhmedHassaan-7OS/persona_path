import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:persona_path/core/constants.dart';

import '../../core/config/env.dart';
import '../../core/utils/image_url_utils.dart';

import '../models/itinerary.dart';

class AiService {
  static bool _isAllowedImageUrl(String url) {
    final u = url.trim();
    if (!(u.startsWith('http://') || u.startsWith('https://'))) return false;
    final host = Uri.tryParse(u)?.host ?? '';
    return host.contains('picsum.photos');
  }

  static List<String> _seededPicsumUrls(String seed) {
    final s = seed.trim().isEmpty ? 'personapath' : seed.trim();
    return [
      'https://picsum.photos/seed/${Uri.encodeComponent(s)}/800/600',
      'https://picsum.photos/seed/${Uri.encodeComponent('${s}2')}/800/600',
      'https://picsum.photos/seed/${Uri.encodeComponent('${s}3')}/800/600',
    ];
  }

  Future<Itinerary> generateItinerary({
    required String userId,
    required Map<String, dynamic> answers,
  }) async {
    final uri = AppEnv.aiUri;
    if (uri == null) {
      return _mockItinerary(userId, answers);
    }

    final prompt = AppPrompts.itineraryPrompt.replaceAll(
      '[answers]',
      jsonEncode(answers),
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (AppEnv.aiAuthToken.isNotEmpty)
          'Authorization': 'Bearer ${AppEnv.aiAuthToken}',
      },
      body: _buildBody(prompt),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('AI request failed: ${response.statusCode}');
    }

    try {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final jsonMap = _extractJson(decoded);
      return _fromAiResponse(userId, jsonMap, answers);
    } catch (_) {
      return _mockItinerary(userId, answers);
    }
  }

  String _buildBody(String prompt) {
    final endpoint = AppEnv.aiEndpoint;
    if (endpoint.contains('generativelanguage.googleapis.com')) {
      return jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      });
    }

    return jsonEncode({'prompt': prompt});
  }

  Map<String, dynamic> _extractJson(Map<String, dynamic> decoded) {
    if (decoded['candidates'] is List) {
      final candidates = decoded['candidates'] as List<dynamic>;
      if (candidates.isNotEmpty) {
        final content = candidates.first['content'];
        final parts = content?['parts'] as List<dynamic>?;
        final text = parts?.isNotEmpty == true
            ? parts!.first['text'] as String
            : '';
        if (text.isNotEmpty) {
          return jsonDecode(_cleanJson(text)) as Map<String, dynamic>;
        }
      }
    }

    return decoded;
  }

  String _cleanJson(String text) {
    var cleaned = text.trim();
    if (cleaned.startsWith('```')) {
      cleaned = cleaned.replaceAll('```json', '').replaceAll('```', '').trim();
    }
    return cleaned;
  }

  Itinerary _fromAiResponse(
    String userId,
    Map<String, dynamic> map,
    Map<String, dynamic> answers,
  ) {
    final urls = <String>[];
    final imageUrls = map['imageUrls'];
    if (imageUrls is List) {
      urls.addAll(imageUrls.whereType<String>());
    }
    final imageUrl = map['imageUrl'];
    if (imageUrl is String && imageUrl.trim().isNotEmpty) {
      urls.add(imageUrl.trim());
    }

    final cleanedUrls = urls
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && !e.contains('example.com'))
        .where(isAllowedImageUrl)
        .toSet()
        .toList();

    final seed = '${userId}_${(map['title'] ?? '').toString()}';
    final finalUrls = cleanedUrls.isNotEmpty
        ? cleanedUrls
        : seededPicsumUrls(seed);

    return Itinerary(
      id: '',
      userId: userId,
      title: map['title'] ?? 'My Journey',
      description: map['description'] ?? '',
      days: List<String>.from(map['days'] ?? const []),
      activities: (map['activities'] as List<dynamic>? ?? const [])
          .map((e) => ActivityItem.fromMap(e))
          .toList(),
      imageUrls: finalUrls,
      generatedAt: DateTime.now(),
      quizAnswers: Map<String, dynamic>.from(answers),
    );
  }

  Itinerary _mockItinerary(String userId, Map<String, dynamic> answers) {
    return Itinerary(
      id: '',
      userId: userId,
      title: 'Cairo & Alexandria Escape',
      description:
          'A relaxed 5-day plan that mixes history, food, and sea views.',
      days: const [
        'Day 1: Old Cairo',
        'Day 2: The Pyramids',
        'Day 3: Alexandria Coast',
        'Day 4: Museums & Cafes',
        'Day 5: Markets & Souvenirs',
      ],
      activities: const [
        ActivityItem(
          day: 'Day 1',
          time: '09:00',
          title: 'Khan El-Khalili',
          note: 'Start with a calm walk.',
        ),
        ActivityItem(
          day: 'Day 2',
          time: '10:00',
          title: 'Giza Plateau',
          note: 'Sunrise photos & camel ride.',
        ),
        ActivityItem(
          day: 'Day 3',
          time: '12:00',
          title: 'Corniche',
          note: 'Sea breeze lunch.',
        ),
        ActivityItem(
          day: 'Day 4',
          time: '15:00',
          title: 'Egyptian Museum',
          note: 'History and art.',
        ),
        ActivityItem(
          day: 'Day 5',
          time: '18:00',
          title: 'Local Market',
          note: 'Find unique gifts.',
        ),
      ],
      imageUrls: _seededPicsumUrls('mock_${userId}_cairo'),
      generatedAt: DateTime.now(),
      quizAnswers: Map<String, dynamic>.from(answers),
    );
  }
}
