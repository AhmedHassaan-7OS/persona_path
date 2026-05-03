import 'package:flutter/material.dart';

import '../../../../core/constants.dart';

class ItinerariesTabsSection extends StatelessWidget {
  const ItinerariesTabsSection({
    required this.index,
    required this.onChanged,
    super.key,
  });

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _tab(context, 'All Activity', 0),
          _tab(context, 'Quizzes', 1),
          _tab(context, 'Itineraries', 2),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, String text, int i) {
    final selected = index == i;
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(i),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.black : AppColors.darkGrey,
            ),
          ),
        ),
      ),
    );
  }
}
