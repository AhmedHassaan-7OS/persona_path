import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../widgets/primary_button.dart';

class QuizIntroScreen extends StatelessWidget {
  const QuizIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.quizIntroTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppPaddings.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppStrings.quizIntroTitle, style: AppTextStyles.title),
            const SizedBox(height: 12),
            Text(AppStrings.quizIntroSubtitle, style: AppTextStyles.bodyGrey),
            const Spacer(),
            PrimaryButton(
              label: AppStrings.beginQuiz,
              onPressed: () => context.push(AppRoutes.quiz),
            ),
          ],
        ),
      ),
    );
  }
}
