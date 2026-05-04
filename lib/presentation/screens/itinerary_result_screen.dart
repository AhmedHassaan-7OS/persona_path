import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../cubit/itinerary/itinerary_cubit.dart';
import '../widgets/day_card.dart';
import '../widgets/primary_button.dart';

class ItineraryResultScreen extends StatelessWidget {
  const ItineraryResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Itinerary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.home),
        ),
      ),
      body: BlocBuilder<ItineraryCubit, ItineraryState>(
        builder: (context, state) {
          final itinerary = state.itinerary;
          if (itinerary == null) {
            return const Center(child: Text('No itinerary generated.'));
          }
          return Padding(
            padding: const EdgeInsets.all(AppPaddings.screen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(itinerary.title, style: AppTextStyles.title),
                const SizedBox(height: 8),
                Text(itinerary.description, style: AppTextStyles.bodyGrey),

                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: itinerary.days.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) => DayCard(title: itinerary.days[index]),
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: AppStrings.saveItinerary,
                  isLoading: state.isSaving,
                  onPressed: () async {
                    try {
                      await context.read<ItineraryCubit>().saveCurrent();
                      if (!context.mounted) return;
                      context.go(AppRoutes.home);
                    } catch (_) {}
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}