import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../cubit/itinerary/itinerary_cubit.dart';
import '../widgets/day_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/safe_network_image.dart';

class ItineraryResultScreen extends StatelessWidget {
  const ItineraryResultScreen({super.key});

  static const String _fallbackImageUrl =
      'https://picsum.photos/seed/personapath/800/600';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Itinerary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPaddings.screen),
        child: BlocBuilder<ItineraryCubit, ItineraryState>(
          builder: (context, state) {
            final itinerary = state.itinerary;
            if (itinerary == null) {
              return const Center(child: Text('No itinerary generated.'));
            }

            final coverUrls = itinerary.imageUrls.isNotEmpty
                ? itinerary.imageUrls
                : const [_fallbackImageUrl];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(itinerary.title, style: AppTextStyles.title),
                const SizedBox(height: 8),
                Text(itinerary.description, style: AppTextStyles.bodyGrey),
                if (state.error != null) ...[
                  const SizedBox(height: 10),
                  Text(state.error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: coverUrls.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.large),
                        child: SafeNetworkImage(
                          url: coverUrls[index],
                          width: 200,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: itinerary.days.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return DayCard(title: itinerary.days[index]);
                    },
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
            );
          },
        ),
      ),
    );
  }
}