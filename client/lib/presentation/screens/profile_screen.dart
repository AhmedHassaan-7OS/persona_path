import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../cubit/auth/auth_session_cubit.dart';
import '../widgets/primary_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthSessionCubit>().state;
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: Padding(
        padding: const EdgeInsets.all(AppPaddings.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(authState.displayName, style: AppTextStyles.title),
            const SizedBox(height: 8),
            Text(authState.email ?? '', style: AppTextStyles.bodyGrey),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Sign Out',
              onPressed: () async {
                await context.read<AuthSessionCubit>().signOut();
                if (!context.mounted) return;
                context.go(AppRoutes.welcome);
              },
            ),
          ],
        ),
      ),
    );
  }
}