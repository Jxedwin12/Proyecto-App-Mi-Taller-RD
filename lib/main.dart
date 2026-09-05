import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MiTallerRDApp());
}

class MiTallerRDApp extends StatelessWidget {
  const MiTallerRDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Taller RD',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const LoginScreen(),
    );
  }
}
