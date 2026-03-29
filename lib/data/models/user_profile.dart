class UserProfile {
  const UserProfile({required this.preferredTravelStyle, required this.quizAnswers});

  final String preferredTravelStyle;
  final Map<String, dynamic> quizAnswers;

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final raw = map['quizAnswers'];
    return UserProfile(
      preferredTravelStyle: (map['preferredTravelStyle'] ?? '').toString(),
      quizAnswers: raw is Map<String, dynamic> ? raw : const {},
    );
  }
}
