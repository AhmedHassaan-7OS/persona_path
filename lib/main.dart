import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'core/app_theme.dart';
import 'core/constants.dart';
import 'core/routing/app_router.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _runNetworkProbe();
  runApp(const PersonaPathApp());
}

Future<void> _runNetworkProbe() async {
  Future<void> probe(String url) async {
    try {
      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 8));
      debugPrint('NETWORK_PROBE url=$url status=${res.statusCode}');
    } catch (e) {
      debugPrint('NETWORK_PROBE url=$url error=$e');
    }
  }

  await probe('https://www.google.com');
  await probe('https://picsum.photos/200/200');
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
