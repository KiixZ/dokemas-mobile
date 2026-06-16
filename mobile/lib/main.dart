import 'package:flutter/material.dart';
import 'pages/main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const DokemasApp());
}

class DokemasApp extends StatelessWidget {
  const DokemasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOKEMAS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Preview shell SUDAH login.
      // Balik ke guest: import 'pages/guest_main_screen.dart' lalu
      // home: const GuestMainScreen().
      home: const MainScreen(),
    );
  }
}
