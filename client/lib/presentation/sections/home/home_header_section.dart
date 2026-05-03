import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:persona_path/presentation/search/history_search_delegate.dart';

import '../../../../core/constants.dart';
import '../../../../data/models/itinerary.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    required this.displayName,
    required this.itineraries,
    super.key,
  });

  final String displayName;
  final List<Itinerary> itineraries;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: const Icon(Icons.auto_awesome, color: AppColors.primaryOrange),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Journey', style: AppTextStyles.title),
              Text('Welcome, $displayName', style: AppTextStyles.bodyGrey),
            ],
          ),
        ),
        IconButton(
          onPressed: itineraries.isEmpty
              ? null
              : () => showSearch<Itinerary?>(
                  context: context,
                  delegate: HistorySearchDelegate(
                    itineraries: itineraries,
                    onSelected: (it) => context.push(
                      AppRoutes.itineraryDetail.replaceFirst(':id', it.id),
                    ),
                  ),
                ),
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}
