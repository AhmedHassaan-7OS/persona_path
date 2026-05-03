import 'package:flutter/material.dart';

import '../../core/constants.dart';

class SectionCard extends StatelessWidget {
  final Widget child;

  const SectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppPaddings.card),
        child: child,
      ),
    );
  }
}