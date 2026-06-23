import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'main_screen.dart';
import 'admin/admin_shell.dart' as admin_shell;
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Jalankan timer minimal 2 detik untuk efek splash
    final timer = Future.delayed(const Duration(seconds: 2));

    // Bersamaan dengan itu, cek status login
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkLoginStatus();

    // Tunggu timer selesai
    await timer;

    if (!mounted) return;

    // Cek apakah admin atau user biasa
    if (authProvider.isLoggedIn && authProvider.user?.role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const admin_shell.AdminShell()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7F4),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Transform.scale(
                scale:
                    14.0, // Memperbesar/zoom gambar SVG yang terlalu banyak ruang kosong
                child: SvgPicture.asset(
                  'lib/assets/serayu.svg',
                  width: 50,
                  height: 50,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF008F7A),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'DOKEMAS',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF12233D),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'APLIKASI WISATA AREA BANYUMAS',
              style: TextStyle(fontSize: 13, color: Color(0xFF7B8794)),
            ),
          ],
        ),
      ),
    );
  }
}
