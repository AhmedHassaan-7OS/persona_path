import 'package:flutter/material.dart';

import '../sections/quiz/quiz_screen_body.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PersonaPath Quiz')),
      body: const QuizScreenBody(),
    );
  }
}