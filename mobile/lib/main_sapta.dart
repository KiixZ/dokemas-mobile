import 'package:flutter/material.dart';
import 'package:mobile/pages/profile_page.dart';
import 'theme/app_theme.dart';

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
      home: const ProfilePage(),
    );
  }
}
