import 'package:flutter/material.dart';

import '../../core/constants.dart';

class DayCard extends StatelessWidget {
  final String title;

  const DayCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPaddings.medium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.primaryOrange),
      ),
      child: Text(title, style: AppTextStyles.body),
    );
  }
}