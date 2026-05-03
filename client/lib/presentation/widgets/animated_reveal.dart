import 'package:flutter/material.dart';

import '../../core/constants.dart';

class AnimatedReveal extends StatefulWidget {
  final Widget child;
  final int index;

  const AnimatedReveal({super.key, required this.child, required this.index});

  @override
  State<AnimatedReveal> createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<AnimatedReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 120 * widget.index), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: AppDurations.slow,
      opacity: _visible ? 1 : 0,
      child: AnimatedSlide(
        duration: AppDurations.slow,
        offset: _visible ? Offset.zero : const Offset(0, 0.05),
        child: widget.child,
      ),
    );
  }
}