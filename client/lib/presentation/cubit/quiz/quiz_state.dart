class QuizState {
  final Map<String, dynamic> answers;

  const QuizState({this.answers = const {}});

  QuizState copyWith({Map<String, dynamic>? answers}) {
    return QuizState(
      answers: answers ?? this.answers,
    );
  }
}
