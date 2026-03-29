import 'package:flutter/material.dart';

import '../../../../core/constants.dart';

class QuizProgressHeader extends StatelessWidget {
  const QuizProgressHeader({required this.progress, super.key});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('STEP 1 OF 6', style: AppTextStyles.bodyGrey),
            Text('$percent% Complete', style: AppTextStyles.bodyGrey),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.lightGrey,
            color: AppColors.primaryOrange,
          ),
        ),
      ],
    );
  }
}
