import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/models/itinerary.dart';
import '../../data/services/api_service.dart';
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
  List<Itinerary> _itineraries = [];
  bool _isLoading = true;
  final _api = ApiService();

  @override
  void initState() {
    super.initState();
    _loadItineraries();
  }

  Future<void> _loadItineraries() async {
    setState(() => _isLoading = true);
    try {
      final items = await _api.getMyItineraries();
      items.sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
      if (mounted) setState(() { _itineraries = items; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthSessionCubit>().state;
    if (!authState.isAuthenticated) {
      return const Scaffold(body: Center(child: Text('Please login.')));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: RefreshIndicator(
        onRefresh: _loadItineraries,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppPaddings.screen, 8, AppPaddings.screen, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ItinerariesTabsSection(index: _tab, onChanged: (v) => setState(() => _tab = v)),
                  const SizedBox(height: 18),
                  ItinerariesContentSection(
                    itineraries: _itineraries,
                    showItineraries: _tab == 0 || _tab == 2,
                    showQuizzes: _tab == 0 || _tab == 1,
                    isLoading: _isLoading,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
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
              itineraries: _itineraries,
              onSelected: (it) => context.push('/itinerary-detail/${it.id}'),
            ),
          ),
        ),
      ],
    );
  }
}