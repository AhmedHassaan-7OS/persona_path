import 'package:flutter/material.dart';

import '../../data/models/itinerary.dart';

class HistorySearchDelegate extends SearchDelegate<Itinerary?> {
  HistorySearchDelegate({required this.itineraries, required this.onSelected});

  final List<Itinerary> itineraries;
  final ValueChanged<Itinerary> onSelected;

  List<Itinerary> _filtered() {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return itineraries;
    return itineraries.where((it) {
      final t = it.title.toLowerCase();
      final d = it.description.toLowerCase();
      return t.contains(q) || d.contains(q);
    }).toList();
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
      ];

  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) => _Results(
        items: _filtered(),
        onTap: (it) {
          onSelected(it);
          close(context, it);
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}

class _Results extends StatelessWidget {
  const _Results({required this.items, required this.onTap});

  final List<Itinerary> items;
  final ValueChanged<Itinerary> onTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No results'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final it = items[i];
        return ListTile(
          title: Text(it.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(it.description, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onTap(it),
        );
      },
    );
  }
}
