class Option {
  final String title;
  final String? imageUrl;

  const Option({required this.title, this.imageUrl});
}

class Question {
  final String title;
  final List<Option> options;

  const Question({required this.title, required this.options});
}
