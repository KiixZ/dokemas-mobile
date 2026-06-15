import 'package:flutter/material.dart';
import '../../widgets/guest_login_required_page.dart';

class GuestItineraryPage extends StatelessWidget {
  const GuestItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GuestLoginRequiredPage(
      icon: Icons.calendar_month_outlined,
      title: 'Rencana Perjalanan',
      description:
          'Masuk untuk mulai merencanakan\npetualanganmu di Purwokerto.\nSimpan tempat favorit dan buat\njadwal perjalanan.',
      selectedIndex: 3,
    );
  }
}