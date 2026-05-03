import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../cubit/quiz/quiz_cubit.dart';
import '../widgets/primary_button.dart';

class QuizTextScreen extends StatefulWidget {
  const QuizTextScreen({super.key});

  @override
  State<QuizTextScreen> createState() => _QuizTextScreenState();
}

class _QuizTextScreenState extends State<QuizTextScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.quizIntroTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppPaddings.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Anything else you want?', style: AppTextStyles.title),
            const SizedBox(height: 12),
            Text(
              'Tell us what matters most (budget, days, vibe, interests...).',
              style: AppTextStyles.bodyGrey,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              minLines: 5,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Write your preferences...',
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Finish',
              onPressed: () {
                context
                    .read<QuizCubit>()
                    .selectAnswer('freeText', _controller.text.trim());
                context.go(AppRoutes.loading);
              },
            ),
          ],
        ),
      ),
    );
  }
}
