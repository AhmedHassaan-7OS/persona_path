import 'package:flutter_bloc/flutter_bloc.dart';

import 'quiz_state.dart';

export 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(const QuizState());

  void selectAnswer(String question, dynamic answer) {
    final updated = Map<String, dynamic>.from(state.answers);
    updated[question] = answer;
    emit(state.copyWith(answers: updated));
  }

  void reset() {
    emit(const QuizState());
  }
}
