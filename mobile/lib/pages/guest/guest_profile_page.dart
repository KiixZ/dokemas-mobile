import 'package:flutter/material.dart';
import '../../widgets/guest_login_required_page.dart';

class GuestProfilePage extends StatelessWidget {
  const GuestProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GuestLoginRequiredPage(
      icon: Icons.person_outline,
      title: 'Profile Saya',
      description:
          'Kelola akun dan aktivitas wisatamu\ndengan mudah.',
      selectedIndex: 4,
    );
  }
}