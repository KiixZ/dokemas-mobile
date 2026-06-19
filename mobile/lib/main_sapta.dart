import 'package:flutter/material.dart';
import 'package:mobile/pages/beranda.dart';
import 'package:mobile/pages/main_screen.dart';
import 'theme/app_theme.dart';
import 'pages/profile_page.dart';
import 'pages/edit_profile_page.dart';
import 'pages/notification_page.dart';

void main() {
  runApp(const DokemasApp());
}

class DokemasApp extends StatelessWidget {
  const DokemasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOKEMAS Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}
