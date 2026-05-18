import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
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
      home: const LoginScreen(),
    );
  }
}