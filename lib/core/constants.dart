import 'package:flutter/material.dart';

// Core app-wide constants. Keep everything here only.

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF616161);
  static const Color transparent = Colors.transparent;
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.darkGrey,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const TextStyle bodyGrey = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.darkGrey,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}

class AppPaddings {
  static const double screen = 20;
  static const double card = 16;
  static const double small = 8;
  static const double medium = 12;
  static const double large = 24;
}

class AppRadius {
  static const double small = 8;
  static const double medium = 12;
  static const double large = 20;
  static const double pill = 30;
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 600);
}

class AppAssets {
  static const String appIcon = 'assets/icons/personapathicon.png';
  static const String background = 'assets/images/background.png';
}

class AppStrings {
  static const String appName = 'PersonaPath';
  static const String tagline = 'Discover your travel soulmate.';

  static const String startJourney = 'Start My Journey';
  static const String login = 'Login';
  static const String register = 'Register';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String signInWithGoogle = 'Sign in with Google';

  static const String quizIntroTitle = 'Your Travel Personality';
  static const String quizIntroSubtitle =
      'Answer 5 quick questions to build your itinerary.';
  static const String beginQuiz = 'Begin Quiz';

  static const String loadingTitle = 'Building your itinerary...';
  static const String saveItinerary = 'Save Itinerary';

  static const String home = 'Home';
  static const String myItineraries = 'My Itineraries';
  static const String profile = 'Profile';
}

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String quizIntro = '/quiz-intro';
  static const String quiz = '/quiz';
  static const String quizText = '/quiz-text';
  static const String quizResult = '/quiz-result';
  static const String loading = '/loading';
  static const String itineraryResult = '/itinerary-result';
  static const String home = '/home';
  static const String myItineraries = '/my-itineraries';
  static const String itineraryDetail = '/itinerary-detail/:id';
  static const String profile = '/profile';
}

class AppPrompts {
  static const String itineraryPrompt =
      'You are a professional travel expert. Use the quiz answers to create a 5-day personalized itinerary. Return ONLY valid JSON with this exact shape: {"title": "...", "description": "...", "days": ["Day 1..."], "activities": [{"day":"Day 1","time":"09:00","title":"...","note":"..."}], "imageUrls": ["https://...", "https://..."]}. Do not include any extra text, markdown, or explanations. IMPORTANT: imageUrls must be real, publicly accessible https URLs (prefer images.unsplash.com). Never use example.com or placeholder domains. Answers: [answers]';
}

class AppQuiz {
  static const List<QuizQuestionData> questions = [
    QuizQuestionData(
      title: 'What kind of morning feels perfect to you?',
      options: [
        QuizOptionData(
          title: 'Quiet Sunrise Hike',
          imageUrl:
              'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
        ),
        QuizOptionData(
          title: 'Bustling Local Market',
          imageUrl:
              'https://images.unsplash.com/photo-1489515217757-5fd1be406fef',
        ),
      ],
    ),
    QuizQuestionData(
      title: 'Your ideal afternoon is...',
      options: [
        QuizOptionData(
          title: 'Museum & History',
          imageUrl:
              'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429',
        ),
        QuizOptionData(
          title: 'Food Tasting',
          imageUrl:
              'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
        ),
      ],
    ),
    QuizQuestionData(
      title: 'Pick your travel pace',
      options: [
        QuizOptionData(
          title: 'Relaxed & Slow',
          imageUrl:
              'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
        ),
        QuizOptionData(
          title: 'Active & Packed',
          imageUrl:
              'https://images.unsplash.com/photo-1473625247510-8ceb1760943f',
        ),
      ],
    ),
    QuizQuestionData(
      title: 'Choose your favorite scenery',
      options: [
        QuizOptionData(
          title: 'Mountains',
          imageUrl:
              'https://images.unsplash.com/photo-1469474968028-56623f02e42e',
        ),
        QuizOptionData(
          title: 'Coast & Sea',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
        ),
      ],
    ),
    QuizQuestionData(
      title: 'Your evening vibe',
      options: [
        QuizOptionData(
          title: 'Quiet Cafe',
          imageUrl:
              'https://images.unsplash.com/photo-1445116572660-236099ec97a0',
        ),
        QuizOptionData(
          title: 'Live Music',
          imageUrl:
              'https://images.unsplash.com/photo-1506157786151-b8491531f063',
        ),
      ],
    ),
  ];
}

class QuizQuestionData {
  final String title;
  final List<QuizOptionData> options;

  const QuizQuestionData({
    required this.title,
    required this.options,
  });
}

class QuizOptionData {
  final String title;
  final String imageUrl;

  const QuizOptionData({
    required this.title,
    required this.imageUrl,
  });
}