import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/app_theme.dart';
import 'core/constants.dart';
import 'core/routing/app_bloc_scope.dart';
import 'core/routing/app_router.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PersonaPathApp());
}

class PersonaPathApp extends StatelessWidget {
  const PersonaPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter();
    return AppBlocScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );
  }
}
