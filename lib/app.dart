import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/auth/auth_gate.dart';

class TheSixerFactoryApp extends StatelessWidget {
  const TheSixerFactoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "The Sixer Factory",
      theme: AppTheme.darkTheme,

      home: const AuthGate(),
    );
  }
}