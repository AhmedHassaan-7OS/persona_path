import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/cubit/auth/auth_session_cubit.dart';
import '../../presentation/cubit/auth/google_sign_in_cubit.dart';
import '../../presentation/cubit/auth/sign_in_cubit.dart';
import '../../presentation/cubit/auth/sign_up_cubit.dart';
import '../../presentation/cubit/itinerary/itinerary_cubit.dart';
import '../../presentation/cubit/quiz/quiz_cubit.dart';

class AppBlocScope extends StatelessWidget {
  const AppBlocScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthSessionCubit>(create: (_) => AuthSessionCubit()),
        BlocProvider<SignInCubit>(create: (_) => SignInCubit()),
        BlocProvider<SignUpCubit>(create: (_) => SignUpCubit()),
        BlocProvider<GoogleSignInCubit>(create: (_) => GoogleSignInCubit()),
        BlocProvider<QuizCubit>(create: (_) => QuizCubit()),
        BlocProvider<ItineraryCubit>(create: (_) => ItineraryCubit()),
      ],
      child: child,
    );
  }
}
