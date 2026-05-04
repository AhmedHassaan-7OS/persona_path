import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../cubit/quiz/quiz_cubit.dart';
import '../../widgets/primary_button.dart';
import 'sections/quiz_free_text_section.dart';
import 'sections/quiz_drive_section.dart';
import 'sections/quiz_image_choice_section.dart';
import 'sections/quiz_landscape_section.dart';
import 'sections/quiz_nightlife_section.dart';
import 'sections/quiz_progress_header.dart';
import 'sections/quiz_trip_details_section.dart';

class QuizScreenBody extends StatelessWidget {
  const QuizScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      builder: (context, state) {
        final answers = state.answers;

        const totalSteps = 6;
        final filled = <String>{
          'place',
          'landscape',
          'nightlife',
          'drive',
          'priceRange', // durationDays is usually always set, priceRange is the second part
          'freeText',
        }.where((k) => (answers[k] ?? '').toString().trim().isNotEmpty).length;
        final progress = (filled / totalSteps).clamp(0.0, 1.0);

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.screen),
            children: [
              QuizProgressHeader(progress: progress),
              const SizedBox(height: 18),
              QuizImageChoiceSection(
                selected: (answers['place'] ?? '').toString(),
                onSelected: (v) => context.read<QuizCubit>().selectAnswer('place', v),
              ),
              const SizedBox(height: 20),
              QuizLandscapeSection(
                selected: (answers['landscape'] ?? '').toString(),
                onSelected: (v) => context.read<QuizCubit>().selectAnswer('landscape', v),
              ),
              const SizedBox(height: 20),
              QuizNightlifeSection(
                selected: (answers['nightlife'] ?? '').toString(),
                onSelected: (v) => context.read<QuizCubit>().selectAnswer('nightlife', v),
              ),
              const SizedBox(height: 20),
              QuizDriveSection(
                selected: (answers['drive'] ?? '').toString(),
                onSelected: (v) => context.read<QuizCubit>().selectAnswer('drive', v),
              ),
              const SizedBox(height: 22),
              QuizTripDetailsSection(
                durationDays: (answers['durationDays'] is num)
                    ? (answers['durationDays'] as num).toInt()
                    : 7,
                priceRange: (answers['priceRange'] ?? '').toString(),
                onDurationChanged: (v) => context.read<QuizCubit>().selectAnswer('durationDays', v),
                onPriceChanged: (v) => context.read<QuizCubit>().selectAnswer('priceRange', v),
              ),
              const SizedBox(height: 20),
              QuizFreeTextSection(
                initialValue: (answers['freeText'] ?? '').toString(),
                onChanged: (v) => context.read<QuizCubit>().selectAnswer('freeText', v.trim()),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Generate My Itinerary',
                onPressed: () => context.go(AppRoutes.loading),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
