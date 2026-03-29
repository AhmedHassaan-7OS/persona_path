import 'package:flutter/material.dart';

import '../../../../core/constants.dart';

class QuizFreeTextSection extends StatefulWidget {
  const QuizFreeTextSection({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<QuizFreeTextSection> createState() => _QuizFreeTextSectionState();
}

class _QuizFreeTextSectionState extends State<QuizFreeTextSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant QuizFreeTextSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text.trim().isEmpty &&
        widget.initialValue.trim().isNotEmpty) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tell us more about your dream trip', style: AppTextStyles.title),
        const SizedBox(height: 10),
        TextField(
          controller: _controller,
          minLines: 4,
          maxLines: 7,
          onChanged: widget.onChanged,
          decoration: const InputDecoration(
            hintText: 'Describe your perfect vacation atmosphere...',
          ),
        ),
      ],
    );
  }
}
