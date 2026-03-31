import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../cubit/auth/auth_session_cubit.dart';
import '../cubit/itinerary/itinerary_cubit.dart';
import '../cubit/quiz/quiz_cubit.dart';

class LoadingItineraryScreen extends StatefulWidget {
  const LoadingItineraryScreen({super.key});

  @override
  State<LoadingItineraryScreen> createState() => _LoadingItineraryScreenState();
}

class _LoadingItineraryScreenState extends State<LoadingItineraryScreen> {
  bool _cancelled = false;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  Future<void> _generate() async {
    final auth = context.read<AuthSessionCubit>().state.user;
    final quiz = context.read<QuizCubit>().state.answers;
    final itineraryCubit = context.read<ItineraryCubit>();

    if (auth == null) {
      if (!mounted) return;
      context.go(AppRoutes.login);
      return;
    }

    try {
      await itineraryCubit.generateFromQuiz(auth.uid, quiz);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save error: $e')),
        );
      }
    }

    if (!mounted) return;
    if (_cancelled) return;
    if (itineraryCubit.state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AI error, showing sample itinerary.')),
      );
    }
    context.go(AppRoutes.itineraryResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPaddings.screen),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(AppStrings.loadingTitle, style: AppTextStyles.subtitle),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: () {
                    setState(() {
                      _cancelled = true;
                    });
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.quiz);
                    }
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
