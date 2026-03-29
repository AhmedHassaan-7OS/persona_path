import 'package:flutter/material.dart';

import '../../core/constants.dart';
import 'safe_network_image.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final bool selected;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.title,
    this.imageUrl,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppPaddings.card),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryOrange : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(
            color: selected ? AppColors.primaryOrange : AppColors.lightGrey,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl != null)
              Expanded(
                child: SafeNetworkImage(
                  url: imageUrl,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
              ),
            if (imageUrl != null) const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: selected ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
