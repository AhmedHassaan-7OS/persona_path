import 'package:flutter/material.dart';

import '../../../../core/constants.dart';
import '../../../widgets/safe_network_image.dart';

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
              child: _ImageChoiceCard(
                title: a.title,
                imageUrl: a.imageUrl,
                selected: selected == a.title,
                onTap: () => onSelected(a.title),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ImageChoiceCard(
                title: b.title,
                imageUrl: b.imageUrl,
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

class _ImageChoiceCard extends StatelessWidget {
  const _ImageChoiceCard({
    required this.title,
    required this.imageUrl,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String imageUrl;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        height: 132,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: selected ? AppColors.primaryOrange : const Color(0xFFFFE5D1),
            width: selected ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Stack(
            fit: StackFit.expand,
            children: [
              SafeNetworkImage(url: imageUrl, fit: BoxFit.cover),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x00000000),
                        Color(0xAA000000),
                      ],
                    ),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
