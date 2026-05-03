import 'package:flutter/material.dart';

import '../../../../core/constants.dart';

class QuizDriveSection extends StatelessWidget {
  const QuizDriveSection({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What drives you?', style: AppTextStyles.title),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _IconChoiceCard(
                title: 'Exploration',
                icon: Icons.explore_outlined,
                selected: selected == 'Exploration',
                onTap: () => onSelected('Exploration'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _IconChoiceCard(
                title: 'Making Things',
                icon: Icons.handyman_outlined,
                selected: selected == 'Making Things',
                onTap: () => onSelected('Making Things'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _IconChoiceCard extends StatelessWidget {
  const _IconChoiceCard({
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
            Text(title, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}
