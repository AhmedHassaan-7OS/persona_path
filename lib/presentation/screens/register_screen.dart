import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../cubit/auth/auth_session_cubit.dart';
import '../cubit/auth/sign_up_cubit.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.register)),
      body: Padding(
        padding: const EdgeInsets.all(AppPaddings.screen),
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthSessionCubit, AuthSessionState>(
              listener: (context, state) {
                if (state.user != null) {
                  context.go(AppRoutes.quizIntro);
                }
              },
            ),
            BlocListener<SignUpCubit, SignUpState>(
              listener: (context, state) {
                if (state is SignUpFailure) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
            ),
          ],
          child: BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              final isLoading = state is SignUpLoading;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(controller: _nameController, label: 'Display Name'),
                  const SizedBox(height: 12),
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
                    label: AppStrings.register,
                    isLoading: isLoading,
                    onPressed: () {
                      context.read<SignUpCubit>().registerWithEmail(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _nameController.text.trim(),
                          );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}