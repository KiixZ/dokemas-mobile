import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data tiruan notifikasi agar layout terlihat realistis
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Promo Spesial Liburan!',
        'description':
            'Diskon tiket masuk Lokawisata Baturraden 20% khusus minggu ini. Cek sekarang!',
        'time': '10 mnt yang lalu',
        'icon': Icons.discount_outlined,
        'isRead': false, // Menandakan belum dibaca (ada indikator warna)
      },
      {
        'title': 'Destinasi Baru di Purwokerto',
        'description':
            'Menara Pandang Teratai menambahkan wahana lampu baru di malam hari. Yuk agendakan!',
        'time': '2 jam yang lalu',
        'icon': Icons.place_outlined,
        'isRead': true,
      },
      {
        'title': 'Tips Liburan Aman',
        'description':
            'Tetap jaga barang bawaan Anda selama berkunjung ke tempat wisata alam ya.',
        'time': '1 hari yang lalu',
        'icon': Icons.security_outlined,
        'isRead': true,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background, // Konsisten dengan warna beranda
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => Navigator.pop(context), // Kembali ke beranda
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? _buildEmptyState() // Jika kosong, tampilkan info kosong
          : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15,
              ),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _buildNotificationItem(item);
              },
            ),
    );
  }

  // WIDGET UNTUK MERENDER TIAP ITEM NOTIFIKASI
  Widget _buildNotificationItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          16,
        ), // Sesuai dengan radius card beranda
        border: Border.all(
          color: item['isRead']
              ? Colors.grey.withValues(alpha: 0.1)
              : AppColors.primary.withValues(
                  alpha: 0.2,
                ), // Border agak biru/hijau kalau belum dibaca
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.03),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lingkaran Icon Notifikasi
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item['isRead']
                    ? Colors.grey.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item['icon'] as IconData,
                color: item['isRead'] ? Colors.grey : AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),

            // Konten Teks Notifikasi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      // Titik indikator jika notifikasi belum dibaca
                      if (!item['isRead'])
                        Container(
                          height: 8,
                          width: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['description'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['time'] as String,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAMPILAN JIKA NOTIFIKASI KOSONG
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada notifikasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Semua info promo dan aktivitasmu akan muncul di sini.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
