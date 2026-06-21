import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FD),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(
            color: Color(0xFF12233D),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF12233D),
            size: 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _PrivacySection(
            title: 'Pengumpulan Data',
            content:
                'DOKEMAS dapat menggunakan data seperti nama, email, wishlist, itinerary, dan ulasan untuk mendukung penggunaan fitur aplikasi.',
          ),
          _PrivacySection(
            title: 'Penggunaan Data',
            content:
                'Data digunakan untuk menampilkan informasi akun, menyimpan destinasi wishlist, membuat rencana perjalanan, dan mengelola ulasan pengguna.',
          ),
          _PrivacySection(
            title: 'Keamanan Data',
            content:
                'Data pengguna dijaga agar tetap aman dan tidak digunakan di luar kebutuhan aplikasi DOKEMAS.',
          ),
          _PrivacySection(
            title: 'Perubahan Kebijakan',
            content:
                'Kebijakan privasi dapat diperbarui apabila terdapat perubahan fitur atau kebutuhan sistem pada aplikasi.',
          ),
        ],
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  final String title;
  final String content;

  const _PrivacySection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF12233D),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFF7B8794),
              fontSize: 13,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}