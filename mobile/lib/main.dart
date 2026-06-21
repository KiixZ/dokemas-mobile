import 'package:flutter/material.dart';
import 'pages/guest_main_screen.dart';
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
      // Shell BELUM login (guest).
      // Preview versi login: import 'pages/main_screen.dart' lalu
      // home: const MainScreen().
      home: const GuestMainScreen(),
    );
  }
}
