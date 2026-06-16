import 'package:flutter/material.dart';
import 'detail_destinasi_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOKEMAS - MOBILE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto', // Menggunakan font bawaan yang bersih dan modern
      ),
      home: const DetailDestinasiScreen(),
    );
  }
}