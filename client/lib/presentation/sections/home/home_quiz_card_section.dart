import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:persona_path/presentation/widgets/primary_button.dart';

import '../../../../core/constants.dart';

class HomeQuizCardSection extends StatelessWidget {
  const HomeQuizCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPaddings.card),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: const Color(0xFFECECEC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Discover your travel personality',
            style: AppTextStyles.subtitle,
          ),
          const SizedBox(height: 8),
          Text(
            'Answer a quick quiz to generate a personalized itinerary.',
            style: AppTextStyles.bodyGrey,
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Take Personality Quiz',
            onPressed: () => context.push(AppRoutes.quizIntro),
          ),
        ],
      ),
    );
  }
}
