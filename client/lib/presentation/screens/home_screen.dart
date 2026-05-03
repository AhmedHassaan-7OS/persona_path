import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../cubit/auth/auth_session_cubit.dart';
import '../cubit/home/home_cubit.dart';
import '../sections/home/home_header_section.dart';
import '../sections/home/home_last_quiz_section.dart';
import '../sections/home/home_latest_itinerary_section.dart';
import '../sections/home/home_quiz_card_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..init(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthSessionCubit>().state;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final displayName = authState.displayName;
            return ListView(
              padding: const EdgeInsets.all(AppPaddings.screen),
              children: [
                HomeHeaderSection(
                  displayName: displayName,
                  itineraries: state.itineraries,
                ),
                const SizedBox(height: 18),
                const HomeQuizCardSection(),
                if (state.lastQuiz != null) ...[
                  const SizedBox(height: 14),
                  HomeLastQuizSection(
                    quizData: state.lastQuiz!,
                    onTap: () => context.push(AppRoutes.quizResult),
                  ),
                ],
                if (state.itineraries.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  HomeLatestItinerarySection(
                    itinerary: state.itineraries.first,
                    onTap: () => context.push(
                      AppRoutes.itineraryDetail.replaceFirst(':id', state.itineraries.first.id),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }
}
