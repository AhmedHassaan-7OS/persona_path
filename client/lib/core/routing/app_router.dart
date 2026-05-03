/// PersonaPath — App Router
///
/// Uses GoRouter with auth redirect. Checks AuthSessionCubit instead
/// of FirebaseAuth.instance for authentication state.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../../presentation/cubit/auth/auth_session_cubit.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/app_shell.dart';
import '../../presentation/screens/itinerary_detail_screen.dart';
import '../../presentation/screens/itinerary_result_screen.dart';
import '../../presentation/screens/loading_itinerary_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/my_itineraries_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/quiz_intro_screen.dart';
import '../../presentation/screens/quiz_result_screen.dart';
import '../../presentation/screens/quiz_screen.dart';
import '../../presentation/screens/quiz_text_screen.dart';
import '../../presentation/screens/register_screen.dart';
import '../../presentation/screens/welcome_screen.dart';

class AppRouter {
  static GoRouter createRouter(AuthSessionCubit authCubit) {
    return GoRouter(
      initialLocation: AppRoutes.welcome,
      refreshListenable: _AuthNotifier(authCubit),
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.welcome,
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.quizIntro,
          builder: (context, state) => const QuizIntroScreen(),
        ),
        GoRoute(
          path: AppRoutes.quiz,
          builder: (context, state) => const QuizScreen(),
        ),
        GoRoute(
          path: AppRoutes.quizText,
          builder: (context, state) => const QuizTextScreen(),
        ),
        GoRoute(
          path: AppRoutes.quizResult,
          builder: (context, state) {
            return const QuizResultScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.loading,
          builder: (context, state) => const LoadingItineraryScreen(),
        ),
        GoRoute(
          path: AppRoutes.itineraryResult,
          builder: (context, state) => const ItineraryResultScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShell(navigationShell: navigationShell);
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.home,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.myItineraries,
                  builder: (context, state) => const MyItinerariesScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.profile,
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.itineraryDetail,
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return ItineraryDetailScreen(itineraryId: id);
          },
        ),
      ],
      redirect: (context, state) {
        final auth = context.read<AuthSessionCubit>().state;
        final isPublic =
            state.matchedLocation == AppRoutes.login ||
            state.matchedLocation == AppRoutes.register ||
            state.matchedLocation == AppRoutes.welcome;

        if (!auth.isAuthenticated && !isPublic) return AppRoutes.welcome;
        if (auth.isAuthenticated && isPublic) return AppRoutes.home;
        return null;
      },
    );
  }
}

/// Notifier that listens to AuthSessionCubit state changes
/// and tells GoRouter to re-evaluate redirects.
class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(AuthSessionCubit cubit) {
    cubit.stream.listen((_) => notifyListeners());
  }
}
