import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';
import 'themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiService.loadSession();

  runApp(const MindStepApp());
}

class MindStepApp extends StatelessWidget {
  const MindStepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindStep',
      theme: AppTheme.lightTheme,
      home: ApiService.token != null
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}