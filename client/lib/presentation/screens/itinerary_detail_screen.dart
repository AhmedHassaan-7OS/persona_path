import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/models/itinerary.dart';
import '../../data/services/api_service.dart';
import '../widgets/day_card.dart';

class ItineraryDetailScreen extends StatelessWidget {
  const ItineraryDetailScreen({required this.itineraryId, super.key});

  final String itineraryId;

  @override
  Widget build(BuildContext context) {
    if (itineraryId.isEmpty) {
      return const Scaffold(body: Center(child: Text('Invalid itinerary.')));
    }

    final tid = int.tryParse(itineraryId);
    if (tid == null) {
      return const Scaffold(body: Center(child: Text('Invalid itinerary ID.')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Itinerary Details')),
      body: FutureBuilder<Itinerary>(
        future: ApiService().getItinerary(tid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final itinerary = snapshot.data;
          if (itinerary == null) {
            return const Center(child: Text('Itinerary not found.'));
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
              ],
            ),
          );
        },
      ),
    );
  }
}