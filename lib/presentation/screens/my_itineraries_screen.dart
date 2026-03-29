import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/models/itinerary.dart';
import '../../data/services/firestore_service.dart';
import '../cubit/auth/auth_session_cubit.dart';
import '../widgets/safe_network_image.dart';
import '../search/history_search_delegate.dart';

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
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please login.')));
    }

    final firestore = FirestoreService();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: StreamBuilder<List<Itinerary>>(
        stream: firestore.watchUserItineraries(user.uid),
        builder: (context, snapshot) {
          final itineraries = (snapshot.data ?? [])..sort(
              (a, b) => b.generatedAt.compareTo(a.generatedAt),
            );

          final showItineraries = _tab == 0 || _tab == 2;
          final showQuizzes = _tab == 0 || _tab == 1;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xFFF7F8FA),
                surfaceTintColor: const Color(0xFFF7F8FA),
                scrolledUnderElevation: 0,
                shadowColor: Colors.transparent,
                elevation: 0,
                floating: false,
                pinned: true,
                title: const Text('Your Journey'),
                actions: [
                  IconButton(
                    onPressed: () {
                      showSearch<Itinerary?>(
                        context: context,
                        delegate: HistorySearchDelegate(
                          itineraries: itineraries,
                          onSelected: (it) =>
                              context.push('/itinerary-detail/${it.id}'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppPaddings.screen,
                  8,
                  AppPaddings.screen,
                  24,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _SegmentedTabs(
                        index: _tab,
                        onChanged: (v) => setState(() => _tab = v),
                      ),
                      const SizedBox(height: 18),
                      if (showItineraries) ...[
                        const _SectionLabel('RECENT'),
                        const SizedBox(height: 10),
                        ..._buildItinerarySection(
                          context,
                          items: itineraries.take(2).toList(),
                        ),
                        const SizedBox(height: 18),
                        const _SectionLabel('EARLIER THIS MONTH'),
                        const SizedBox(height: 10),
                        ..._buildItinerarySection(
                          context,
                          items: itineraries.skip(2).take(3).toList(),
                        ),
                      ],
                      if (showQuizzes) ...[
                        if (showItineraries) const SizedBox(height: 18),
                        const _SectionLabel('QUIZZES'),
                        const SizedBox(height: 10),
                        _HistoryCard(
                          leading: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE9D6),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.quiz, color: AppColors.primaryOrange),
                          ),
                          badgeText: 'QUIZ RESULT',
                          title: 'Personality Archetype Quiz',
                          subtitle: 'Completed',
                          onTap: () {},
                        ),
                      ],
                      if ((itineraries.isEmpty && showItineraries) &&
                          snapshot.connectionState != ConnectionState.waiting)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Center(
                            child: Text(
                              'Keep exploring to see more here',
                              style: AppTextStyles.bodyGrey,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildItinerarySection(
    BuildContext context, {
    required List<Itinerary> items,
  }) {
    if (items.isEmpty) {
      return [
        Text('No itineraries yet.', style: AppTextStyles.bodyGrey),
      ];
    }
    return items
        .map(
          (it) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _HistoryCard(
              leading: SafeNetworkImage(
                url: it.imageUrls.isNotEmpty ? it.imageUrls.first : null,
                width: 52,
                height: 52,
                borderRadius: BorderRadius.circular(14),
                fit: BoxFit.cover,
              ),
              badgeText: 'ITINERARY',
              title: it.title,
              subtitle: 'Completed ${_formatDate(it.generatedAt)}',
              onTap: () => context.push('/itinerary-detail/${it.id}'),
            ),
          ),
        )
        .toList();
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final m = months[(dt.month - 1).clamp(0, 11)];
    return '$m ${dt.day}, ${dt.year}';
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget tab(String text, int i) {
      final selected = index == i;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(i),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.black : AppColors.darkGrey,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          tab('All Activity', 0),
          tab('Quizzes', 1),
          tab('Itineraries', 2),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF9AA3AF),
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.leading,
    required this.badgeText,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget leading;
  final String badgeText;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8EDF2)),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bookmark, size: 14, color: AppColors.primaryOrange),
                      const SizedBox(width: 6),
                      Text(
                        badgeText,
                        style: const TextStyle(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9AA3AF)),
          ],
        ),
      ),
    );
  }
}