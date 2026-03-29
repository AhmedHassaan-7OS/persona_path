import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/models/user_profile.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({required this.profile, super.key});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top + kToolbarHeight + 12;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Quiz Result'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(AppPaddings.screen, topPad, AppPaddings.screen, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppPaddings.card),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(color: const Color(0xFFECECEC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your travel style', style: AppTextStyles.subtitle),
                  const SizedBox(height: 10),
                  Text(
                    profile.preferredTravelStyle.isEmpty
                        ? 'Not completed yet'
                        : profile.preferredTravelStyle,
                    style: AppTextStyles.title,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Your answers', style: AppTextStyles.subtitle),
            const SizedBox(height: 10),
            ...profile.quizAnswers.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(AppPaddings.card),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    border: Border.all(color: const Color(0xFFECECEC)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.key, style: AppTextStyles.bodyGrey),
                      const SizedBox(height: 6),
                      Text(e.value.toString(), style: AppTextStyles.body),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
