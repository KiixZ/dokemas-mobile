import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/admin/admin_shell.dart';
import 'pages/itinerary_page.dart';

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
      home: const ItineraryPage(),
    );
  }
}