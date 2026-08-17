import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const EmberAiApp());
}

/// Root widget of the Ember AI app. Launches into the splash screen,
/// which then transitions into the main HomeShell.
class EmberAiApp extends StatelessWidget {
  const EmberAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ember AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const SplashScreen(),
    );
  }
}
