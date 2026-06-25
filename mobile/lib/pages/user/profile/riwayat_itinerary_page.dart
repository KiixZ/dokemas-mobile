import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';

class RiwayatItineraryPage extends StatelessWidget {
  const RiwayatItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> riwayatItinerary = [
      {
        'judul': 'Liburan ke Baturraden',
        'tanggal': '12 Ags - 14 Ags 2026',
        'jumlah': '4 destinasi',
        'detail': [
          {
            'jam': '08:00',
            'judul': 'Berangkat dari pusat kota',
            'deskripsi': 'Persiapan perjalanan menuju kawasan Baturraden.',
          },
          {
            'jam': '09:00',
            'judul': 'Lokawisata Baturraden',
            'deskripsi': 'Menikmati suasana alam dan area wisata utama.',
          },
          {
            'jam': '12:00',
            'judul': 'Makan siang',
            'deskripsi': 'Istirahat dan makan siang di sekitar kawasan wisata.',
          },
          {
            'jam': '14:00',
            'judul': 'Curug Bayan',
            'deskripsi': 'Mengunjungi area air terjun dan berfoto.',
          },
        ],
      },
      {
        'judul': 'Wisata Kuliner Purwokerto',
        'tanggal': '05 Jul - 07 Jul 2026',
        'jumlah': '3 destinasi',
        'detail': [
          {
            'jam': '10:00',
            'judul': 'Soto Sokaraja H. Loso',
            'deskripsi': 'Mencoba kuliner khas Banyumas.',
          },
          {
            'jam': '13:00',
            'judul': 'Mendoan Purwokerto',
            'deskripsi': 'Mencicipi makanan ringan khas daerah.',
          },
          {
            'jam': '19:00',
            'judul': 'Alun-alun Purwokerto',
            'deskripsi':
                'Menikmati suasana malam dan kuliner sekitar alun-alun.',
          },
        ],
      },
      {
        'judul': 'Jelajah Kota Banyumas',
        'tanggal': '20 Jun 2026',
        'jumlah': '5 destinasi',
        'detail': [
          {
            'jam': '08:30',
            'judul': 'Museum Bank Rakyat Indonesia',
            'deskripsi': 'Melihat sejarah dan koleksi museum.',
          },
          {
            'jam': '10:30',
            'judul': 'Menara Pandang Teratai',
            'deskripsi': 'Melihat pemandangan kota dari area menara.',
          },
          {
            'jam': '13:00',
            'judul': 'Taman Kota',
            'deskripsi': 'Istirahat dan menikmati suasana kota.',
          },
          {
            'jam': '15:00',
            'judul': 'Pusat Oleh-oleh',
            'deskripsi': 'Membeli buah tangan khas Banyumas.',
          },
          {
            'jam': '17:00',
            'judul': 'Kembali',
            'deskripsi': 'Perjalanan pulang setelah kegiatan selesai.',
          },
        ],
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Riwayat Itinerary',
          style: AppTextStyles.title.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Riwayat rencana perjalanan yang pernah dibuat.',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),

          ...riwayatItinerary.map((item) {
            return _RiwayatCard(
              judul: item['judul'],
              tanggal: item['tanggal'],
              jumlah: item['jumlah'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailRiwayatItineraryPage(
                      judul: item['judul'],
                      tanggal: item['tanggal'],
                      jumlah: item['jumlah'],
                      detail: List<Map<String, String>>.from(item['detail']),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  final String judul;
  final String tanggal;
  final String jumlah;
  final VoidCallback onTap;

  const _RiwayatCard({
    required this.judul,
    required this.tanggal,
    required this.jumlah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.folder_outlined,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  judul,
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoRow(
                            icon: Icons.calendar_month_rounded,
                            text: tanggal,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _InfoRow(
                            icon: Icons.description_outlined,
                            text: jumlah,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'tap untuk lihat detail',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailRiwayatItineraryPage extends StatelessWidget {
  final String judul;
  final String tanggal;
  final String jumlah;
  final List<Map<String, String>> detail;

  const DetailRiwayatItineraryPage({
    super.key,
    required this.judul,
    required this.tanggal,
    required this.jumlah,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Detail Itinerary',
          style: AppTextStyles.title.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _InfoRow(icon: Icons.calendar_month_rounded, text: tanggal),
                const SizedBox(height: AppSpacing.sm),
                _InfoRow(icon: Icons.description_outlined, text: jumlah),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Jadwal Perjalanan',
            style: AppTextStyles.title.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...detail.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return _TimelineDetailItem(
              jam: item['jam'] ?? '',
              judul: item['judul'] ?? '',
              deskripsi: item['deskripsi'] ?? '',
              isLast: index == detail.length - 1,
            );
          }),
        ],
      ),
    );
  }
}

class _TimelineDetailItem extends StatelessWidget {
  final String jam;
  final String judul;
  final String deskripsi;
  final bool isLast;

  const _TimelineDetailItem({
    required this.jam,
    required this.judul,
    required this.deskripsi,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 54,
            child: Text(
              jam,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 13,
                height: 13,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          judul,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    deskripsi,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
