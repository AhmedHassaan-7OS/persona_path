import 'package:flutter/material.dart';

import '../../../../core/constants.dart';

// Images removed - now text-only cards like quiz_drive_section
class QuizImageChoiceSection extends StatelessWidget {
  const QuizImageChoiceSection({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final q1 = AppQuiz.questions[0];
    final a = q1.options[0];
    final b = q1.options[1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Where do you feel most at peace?', style: AppTextStyles.title),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _TextChoiceCard(
                title: a.title,
                icon: Icons.wb_sunny_outlined,
                selected: selected == a.title,
                onTap: () => onSelected(a.title),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TextChoiceCard(
                title: b.title,
                icon: Icons.storefront_outlined,
                selected: selected == b.title,
                onTap: () => onSelected(b.title),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TextChoiceCard extends StatelessWidget {
  const _TextChoiceCard({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: selected ? AppColors.primaryOrange : const Color(0xFFFFE5D1),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryOrange),
            const SizedBox(height: 8),
            Text(title, style: AppTextStyles.body, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
