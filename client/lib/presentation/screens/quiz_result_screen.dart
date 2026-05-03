import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/services/api_service.dart';

class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  List<Map<String, dynamic>> _quizzes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    try {
      final quizzes = await ApiService().getMyQuizzes();
      if (mounted) setState(() { _quizzes = quizzes; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top + kToolbarHeight + 12;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Quiz Results'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _quizzes.isEmpty
              ? const Center(child: Text('No quiz results yet.'))
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(AppPaddings.screen, topPad, AppPaddings.screen, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ..._quizzes.map((quiz) => _buildQuizCard(quiz)),
                    ],
                  ),
                ),
    );
  }

  Widget _buildQuizCard(Map<String, dynamic> quiz) {
    final answers = {
      'Morning': quiz['peace_ans'] ?? '',
      'Scenery': quiz['landscape_ans'] ?? '',
      'Evening': quiz['nightlife_ans'] ?? '',
      'Afternoon': quiz['motv_ans'] ?? '',
      'Duration': '${quiz['duration'] ?? 0} days',
      'Budget': quiz['price_range'] ?? '',
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(AppPaddings.card),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(color: const Color(0xFFECECEC)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quiz['name'] ?? 'Quiz', style: AppTextStyles.subtitle),
            if (quiz['trip_desc'] != null && (quiz['trip_desc'] as String).isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(quiz['trip_desc'] as String, style: AppTextStyles.bodyGrey),
            ],
            const SizedBox(height: 12),
            ...answers.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(e.key, style: AppTextStyles.bodyGrey),
                    ),
                    Expanded(
                      child: Text(e.value.toString(), style: AppTextStyles.body),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
