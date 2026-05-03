import 'package:flutter/material.dart';

import '../../../../core/constants.dart';

class QuizTripDetailsSection extends StatelessWidget {
  const QuizTripDetailsSection({
    required this.durationDays,
    required this.priceRange,
    required this.onDurationChanged,
    required this.onPriceChanged,
    super.key,
  });

  final int durationDays;
  final String priceRange;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<String> onPriceChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trip Details', style: AppTextStyles.title),
        const SizedBox(height: 6),
        Text('Duration (Days)', style: AppTextStyles.bodyGrey),
        const SizedBox(height: 8),
        _DurationSlider(
          value: durationDays.toDouble(),
          onChanged: (v) => onDurationChanged(v.round()),
        ),
        const SizedBox(height: 12),
        Text('Price Range', style: AppTextStyles.bodyGrey),
        const SizedBox(height: 8),
        _SegmentedPrice(value: priceRange, onChanged: onPriceChanged),
      ],
    );
  }
}

class _DurationSlider extends StatelessWidget {
  const _DurationSlider({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('1 Day', style: TextStyle(fontSize: 12, color: AppColors.darkGrey)),
            Text('30 Days', style: TextStyle(fontSize: 12, color: AppColors.darkGrey)),
          ],
        ),
        Slider(
          min: 1,
          max: 30,
          divisions: 29,
          value: value.clamp(1, 30),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _SegmentedPrice extends StatelessWidget {
  const _SegmentedPrice({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget item(String v) {
      final selected = value == v;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(v),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.primaryOrange : AppColors.lightGrey,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Text(
              v,
              style: TextStyle(
                color: selected ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        item(r'$'),
        const SizedBox(width: 10),
        item(r'$$'),
        const SizedBox(width: 10),
        item(r'$$$'),
      ],
    );
  }
}
