import 'package:flutter/material.dart';

import '../../../../core/constants.dart';

class QuizNightlifeSection extends StatelessWidget {
  const QuizNightlifeSection({
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
        Text('Nightlife preference?', style: AppTextStyles.title),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _ChoiceChip(
              label: 'Active Clubbing',
              selected: selected == 'Active Clubbing',
              onSelected: () => onSelected('Active Clubbing'),
            ),
            _ChoiceChip(
              label: 'Quiet Bar',
              selected: selected == 'Quiet Bar',
              onSelected: () => onSelected('Quiet Bar'),
            ),
            _ChoiceChip(
              label: 'Early Bedtime',
              selected: selected == 'Early Bedtime',
              onSelected: () => onSelected('Early Bedtime'),
            ),
            _ChoiceChip(
              label: 'Live Music',
              selected: selected == 'Live Music',
              onSelected: () => onSelected('Live Music'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primaryOrange,
      labelStyle: TextStyle(
        color: selected ? AppColors.white : AppColors.primaryOrange,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: AppColors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? AppColors.primaryOrange : const Color(0xFFFFE5D1),
        ),
      ),
    );
  }
}
