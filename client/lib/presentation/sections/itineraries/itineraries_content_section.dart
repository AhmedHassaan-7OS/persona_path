import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../data/models/itinerary.dart';
import 'itinerary_history_card.dart';

class ItinerariesContentSection extends StatelessWidget {
  const ItinerariesContentSection({
    required this.itineraries,
    required this.showItineraries,
    required this.showQuizzes,
    required this.isLoading,
    super.key,
  });

  final List<Itinerary> itineraries;
  final bool showItineraries;
  final bool showQuizzes;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showItineraries) ...[
          _SectionLabel('RECENT'),
          const SizedBox(height: 10),
          ..._buildCards(context, itineraries.take(2).toList()),
          const SizedBox(height: 18),
          _SectionLabel('EARLIER THIS MONTH'),
          const SizedBox(height: 10),
          ..._buildCards(context, itineraries.skip(2).take(3).toList()),
        ],
        if (showQuizzes) ...[
          if (showItineraries) const SizedBox(height: 18),
          _SectionLabel('QUIZZES'),
          const SizedBox(height: 10),
          ItineraryHistoryCard(
            leading: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE9D6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.quiz, color: AppColors.primaryOrange),
            ),
            badgeText: 'QUIZ RESULT',
            title: 'Personality Archetype Quiz',
            subtitle: 'Completed',
            onTap: () {},
          ),
        ],
        if (itineraries.isEmpty && showItineraries && !isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Center(
              child: Text('Keep exploring to see more here',
                  style: AppTextStyles.bodyGrey, textAlign: TextAlign.center),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildCards(BuildContext context, List<Itinerary> items) {
    if (items.isEmpty) return [Text('No itineraries yet.', style: AppTextStyles.bodyGrey)];
    return items.map((it) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ItineraryHistoryCard(
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE9D6),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.map_outlined, color: AppColors.primaryOrange),
        ),
        badgeText: 'ITINERARY',
        title: it.title,
        subtitle: 'Completed ${_formatDate(it.generatedAt)}',
        onTap: () => context.push('/itinerary-detail/${it.id}'),
      ),
    )).toList();
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[(dt.month - 1).clamp(0, 11)]} ${dt.day}, ${dt.year}';
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
          color: Color(0xFF9AA3AF),
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ));
  }
}
