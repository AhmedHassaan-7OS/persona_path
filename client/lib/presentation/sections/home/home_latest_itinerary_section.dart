import 'package:flutter/material.dart';

import '../../../../core/constants.dart';
import '../../../../data/models/itinerary.dart';

class HomeLatestItinerarySection extends StatelessWidget {
  const HomeLatestItinerarySection({
    required this.itinerary,
    required this.onTap,
    super.key,
  });

  final Itinerary itinerary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Container(
        padding: const EdgeInsets.all(AppPaddings.card),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(color: const Color(0xFFECECEC)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE9D6),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: const Icon(Icons.map_outlined, color: AppColors.primaryOrange, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Continue', style: AppTextStyles.bodyGrey),
                  const SizedBox(height: 4),
                  Text(itinerary.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.body),
                  const SizedBox(height: 2),
                  Text(itinerary.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.darkGrey),
          ],
        ),
      ),
    );
  }
}
