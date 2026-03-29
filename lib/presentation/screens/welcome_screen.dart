import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../widgets/primary_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_index >= 2) {
      context.go(AppRoutes.login);
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Widget _dot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 18 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: active ? AppColors.primaryOrange : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }

  Widget _page({required String title, required String body, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(AppPaddings.screen),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: AppColors.primaryOrange, size: 38),
          ),
          const SizedBox(height: 18),
          Text(title, style: AppTextStyles.title, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(body, style: AppTextStyles.bodyGrey, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.background, fit: BoxFit.cover),
          Container(color: Colors.white.withValues(alpha: 0.85)),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text('Skip'),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (v) => setState(() => _index = v),
                    children: [
                      _page(
                        title: 'Find your travel personality',
                        body: 'Answer a quick quiz and we’ll tailor an itinerary for you.',
                        icon: Icons.auto_awesome,
                      ),
                      _page(
                        title: 'Smart itineraries',
                        body: 'Get day-by-day activities with times and notes you can follow.',
                        icon: Icons.map_outlined,
                      ),
                      _page(
                        title: 'Save your journey',
                        body: 'Keep your itineraries in one place and revisit them anytime.',
                        icon: Icons.bookmark_border,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_dot(_index == 0), _dot(_index == 1), _dot(_index == 2)],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppPaddings.screen,
                    0,
                    AppPaddings.screen,
                    AppPaddings.screen,
                  ),
                  child: PrimaryButton(
                    label: _index == 2 ? AppStrings.startJourney : 'Next',
                    onPressed: _goNext,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}