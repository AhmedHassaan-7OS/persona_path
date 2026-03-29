import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/models/itinerary.dart';
import '../../data/services/firestore_service.dart';
import '../widgets/day_card.dart';
import '../widgets/safe_network_image.dart';

class ItineraryDetailScreen extends StatelessWidget {
  const ItineraryDetailScreen({required this.itineraryId, super.key});

  static const String _fallbackImageUrl =
      'https://picsum.photos/seed/personapath/800/600';

  final String itineraryId;

  @override
  Widget build(BuildContext context) {
    if (itineraryId.isEmpty) {
      return const Scaffold(body: Center(child: Text('Invalid itinerary.')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Itinerary Details')),
      body: FutureBuilder<Itinerary?>(
        future: FirestoreService().getItineraryById(itineraryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final itinerary = snapshot.data;
          if (itinerary == null) {
            return const Center(child: Text('Itinerary not found.'));
          }

          final coverUrls = itinerary.imageUrls.isNotEmpty
              ? itinerary.imageUrls
              : const [_fallbackImageUrl];
          return Padding(
            padding: const EdgeInsets.all(AppPaddings.screen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(itinerary.title, style: AppTextStyles.title),
                const SizedBox(height: 8),
                Text(itinerary.description, style: AppTextStyles.bodyGrey),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: coverUrls.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return SafeNetworkImage(
                        url: coverUrls[index],
                        width: 200,
                        height: 140,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: itinerary.days.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => DayCard(title: itinerary.days[index]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}