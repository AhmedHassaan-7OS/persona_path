import 'package:flutter/material.dart';

import '../../../../core/constants.dart';

class ItineraryHistoryCard extends StatelessWidget {
  const ItineraryHistoryCard({
    required this.leading,
    required this.badgeText,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final Widget leading;
  final String badgeText;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8EDF2)),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bookmark, size: 14, color: AppColors.primaryOrange),
                      const SizedBox(width: 6),
                      Text(badgeText,
                          style: const TextStyle(
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          )),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9AA3AF)),
          ],
        ),
      ),
    );
  }
}
