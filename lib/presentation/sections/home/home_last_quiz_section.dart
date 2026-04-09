import 'package:flutter/material.dart';

import '../../../../core/constants.dart';
import '../../../../data/models/user_profile.dart';

class HomeLastQuizSection extends StatelessWidget {
  const HomeLastQuizSection({
    required this.profile,
    required this.onTap,
    super.key,
  });

  final UserProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = profile.preferredTravelStyle.trim().isEmpty
        ? 'Not completed yet'
        : profile.preferredTravelStyle.trim();

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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE9D6),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Icon(Icons.quiz, color: AppColors.primaryOrange),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last Quiz Result', style: AppTextStyles.bodyGrey),
                  const SizedBox(height: 4),
                  Text(title, style: AppTextStyles.body, maxLines: 1, overflow: TextOverflow.ellipsis),
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
