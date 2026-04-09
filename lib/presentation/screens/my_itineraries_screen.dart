import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/models/itinerary.dart';
import '../../data/services/firestore_service.dart';
import '../cubit/auth/auth_session_cubit.dart';
import '../search/history_search_delegate.dart';
import '../sections/itineraries/itineraries_tabs_section.dart';
import '../sections/itineraries/itineraries_content_section.dart';

class MyItinerariesScreen extends StatefulWidget {
  const MyItinerariesScreen({super.key});
  @override
  State<MyItinerariesScreen> createState() => _MyItinerariesScreenState();
}

class _MyItinerariesScreenState extends State<MyItinerariesScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthSessionCubit>().state.user;
    if (user == null) return const Scaffold(body: Center(child: Text('Please login.')));

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: StreamBuilder<List<Itinerary>>(
        stream: FirestoreService().watchUserItineraries(user.uid),
        builder: (context, snapshot) {
          final itineraries = (snapshot.data ?? [])
            ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
          return CustomScrollView(
            slivers: [
              _buildAppBar(context, itineraries),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppPaddings.screen, 8, AppPaddings.screen, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    ItinerariesTabsSection(index: _tab, onChanged: (v) => setState(() => _tab = v)),
                    const SizedBox(height: 18),
                    ItinerariesContentSection(
                      itineraries: itineraries,
                      showItineraries: _tab == 0 || _tab == 2,
                      showQuizzes: _tab == 0 || _tab == 1,
                      isLoading: snapshot.connectionState == ConnectionState.waiting,
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, List<Itinerary> itineraries) {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF7F8FA),
      surfaceTintColor: const Color(0xFFF7F8FA),
      scrolledUnderElevation: 0,
      elevation: 0,
      floating: false,
      pinned: true,
      title: const Text('Your Journey'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => showSearch<Itinerary?>(
            context: context,
            delegate: HistorySearchDelegate(
              itineraries: itineraries,
              onSelected: (it) => context.push('/itinerary-detail/${it.id}'),
            ),
          ),
        ),
      ],
    );
  }
}