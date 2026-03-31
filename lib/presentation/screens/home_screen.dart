import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/utils/string_utils.dart';
import '../../data/services/firestore_service.dart';
import '../../data/models/itinerary.dart';
import '../../data/models/user_profile.dart';
import '../cubit/auth/auth_session_cubit.dart';
import '../search/history_search_delegate.dart';
import '../widgets/primary_button.dart';
import '../widgets/safe_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.firestoreService,
  });

  final FirestoreRepository? firestoreService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FirestoreRepository _firestore;
  String? _lastEnsuredUid;

  @override
  void initState() {
    super.initState();
    _firestore = widget.firestoreService ?? FirestoreService();
    _ensureUserDoc();
  }

  Future<void> _ensureUserDoc() async {
    final user = context.read<AuthSessionCubit>().state.user;
    if (user == null) return;
    if (_lastEnsuredUid == user.uid) return;
    _lastEnsuredUid = user.uid;
    await _firestore.upsertUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? resolveFallbackName(user.email),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthSessionCubit>().state.user;
    final displayName = user?.displayName ?? resolveFallbackName(user?.email);
    final uid = user?.uid ?? '';
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Itinerary>>(
          stream: uid.isNotEmpty ? _firestore.watchUserItineraries(uid) : const Stream.empty(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _buildStreamError(snapshot.error);
            }
            final itineraries = snapshot.data ?? const <Itinerary>[];
            return ListView(
              padding: const EdgeInsets.all(AppPaddings.screen),
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: const Icon(Icons.auto_awesome, color: AppColors.primaryOrange),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Journey', style: AppTextStyles.title),
                          const SizedBox(height: 2),
                          Text(
                            'Welcome, $displayName',
                            style: AppTextStyles.bodyGrey,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: itineraries.isEmpty
                          ? null
                          : () {
                              showSearch<Itinerary?>(
                                context: context,
                                delegate: HistorySearchDelegate(
                                  itineraries: itineraries,
                                  onSelected: (it) => context.push(
                                    AppRoutes.itineraryDetail.replaceFirst(':id', it.id),
                                  ),
                                ),
                              );
                            },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(AppPaddings.card),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    border: Border.all(color: const Color(0xFFECECEC)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Discover your travel personality', style: AppTextStyles.subtitle),
                      const SizedBox(height: 8),
                      Text(
                        'Answer a quick quiz to generate a personalized itinerary.',
                        style: AppTextStyles.bodyGrey,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: 'Take Personality Quiz',
                        onPressed: () => context.push(AppRoutes.quizIntro),
                      ),
                    ],
                  ),
                ),
                if (uid.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  StreamBuilder<UserProfile?>(
                    stream: _firestore.watchUserProfile(uid),
                    builder: (context, snap) {
                      final profile = snap.data;
                      if (profile == null) return const SizedBox.shrink();
                      return _LastQuizCard(
                        profile: profile,
                        onTap: () => context.push(AppRoutes.quizResult, extra: profile),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 14),
                if (itineraries.isNotEmpty)
                  _LatestItineraryCard(
                    title: itineraries.first.title,
                    subtitle: itineraries.first.description,
                    imageUrl: itineraries.first.imageUrls.isNotEmpty
                        ? itineraries.first.imageUrls.first
                        : null,
                    onTap: () => context.push(
                      AppRoutes.itineraryDetail.replaceFirst(':id', itineraries.first.id),
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStreamError(Object? error) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.screen),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Itinerary service unavailable',
              style: AppTextStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Unable to load your plans right now.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyGrey,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => setState(() {}),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastQuizCard extends StatelessWidget {
  const _LastQuizCard({required this.profile, required this.onTap});

  final UserProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = profile.preferredTravelStyle.trim().isEmpty
        ? 'Not completed yet'
        : profile.preferredTravelStyle.trim();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Container(
        padding: const EdgeInsets.all(AppPaddings.card),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(color: const Color(0xFFECECEC)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE9D6),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Icon(Icons.quiz, color: AppColors.primaryOrange),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last Quiz Result', style: AppTextStyles.bodyGrey),
                  const SizedBox(height: 4),
                  Text(title, style: AppTextStyles.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.darkGrey),
          ],
        ),
      ),
    );
  }
}

class _LatestItineraryCard extends StatelessWidget {
  const _LatestItineraryCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  static const String _fallbackImageUrl =
      'https://picsum.photos/seed/personapath/800/600';

  final String title;
  final String subtitle;
  final String? imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final url = (imageUrl == null || imageUrl!.trim().isEmpty)
        ? _fallbackImageUrl
        : imageUrl;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Container(
        padding: const EdgeInsets.all(AppPaddings.card),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(color: const Color(0xFFECECEC)),
        ),
        child: Row(
          children: [
            SafeNetworkImage(
              url: url,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Continue', style: AppTextStyles.bodyGrey),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.darkGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.darkGrey),
          ],
        ),
      ),
    );
  }
}
