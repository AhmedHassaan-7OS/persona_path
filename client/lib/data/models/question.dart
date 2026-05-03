class Option {
  final String title;
  // imageUrl removed
  const Option({required this.title});
}

class Question {
  final String title;
  final List<Option> options;

  const Question({required this.title, required this.options});
}
