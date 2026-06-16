import 'package:flutter/material.dart';
import 'package:mobile/pages/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dokemas Mobile',
      debugShowCheckedModeBanner:
          false, // Menghilangkan banner debug merah di kanan atas
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const MainScreen(), // Memanggil HomePage dari beranda.dart
    );
  }
}
