import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../cubit/auth/auth_session_cubit.dart';
import '../cubit/auth/google_sign_in_cubit.dart';
import '../cubit/auth/sign_in_cubit.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(AppStrings.login),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.background, fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppPaddings.screen),
              child: MultiBlocListener(
                listeners: [
                  BlocListener<SignInCubit, SignInState>(
                    listener: (context, state) {
                      if (state is SignInSuccess) {
                        context.read<AuthSessionCubit>().setAuthenticated(
                              uid: state.uid,
                              username: state.username,
                              email: state.email,
                            );
                        context.go(AppRoutes.home);
                      } else if (state is SignInFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                  ),
                  BlocListener<GoogleSignInCubit, GoogleSignInState>(
                    listener: (context, state) {
                      if (state is GoogleSignInSuccess) {
                        context.read<AuthSessionCubit>().setAuthenticated(
                              uid: state.uid,
                              username: state.username,
                              email: state.email,
                            );
                        context.go(AppRoutes.home);
                      } else if (state is GoogleSignInFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                  ),
                ],
                child: BlocBuilder<SignInCubit, SignInState>(
                  builder: (context, signInState) {
                    final googleState = context.watch<GoogleSignInCubit>().state;

                    final isLoading =
                        signInState is SignInLoading || googleState is GoogleSignInLoading;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(),
                        AppTextField(
                          controller: _emailController,
                          label: AppStrings.email,
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _passwordController,
                          label: AppStrings.password,
                          obscure: true,
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          label: AppStrings.login,
                          isLoading: isLoading,
                          onPressed: () {
                            if (isLoading) return;
                            context.read<SignInCubit>().signInWithEmail(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                          },
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () =>
                                  context.read<GoogleSignInCubit>().signInWithGoogle(),
                          child: const Text(AppStrings.signInWithGoogle),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.register),
                          child: const Text('No account? Create one'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}