import 'package:flutter/material.dart';

import '../../../../core/constants.dart';

class QuizLandscapeSection extends StatelessWidget {
  const QuizLandscapeSection({
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
        Text('Preferred landscape?', style: AppTextStyles.title),
        const SizedBox(height: 10),
        _RadioTile(
          title: 'Modern City',
          subtitle: 'Skyscrapers, tech hubs, urban energy',
          selected: selected == 'Modern City',
          onTap: () => onSelected('Modern City'),
        ),
        const SizedBox(height: 10),
        _RadioTile(
          title: 'Natural Rural',
          subtitle: 'Mountains, forests, open fields',
          selected: selected == 'Natural Rural',
          onTap: () => onSelected('Natural Rural'),
        ),
      ],
    );
  }
}

class _RadioTile extends StatelessWidget {
  const _RadioTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        padding: const EdgeInsets.all(AppPaddings.card),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: const Color(0xFFECECEC)),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primaryOrange : AppColors.darkGrey,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.darkGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
