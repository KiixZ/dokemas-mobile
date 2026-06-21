import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {

  final List<Map<String, dynamic>> _itineraries = [
    {
      'title': 'Liburan ke Baturraden',
      'date': '12 Ags - 14 Ags 2026',
      'destinationCount': '4 destinasi',
      'items': [
        {
          'time': '08:00',
          'title': 'Berangkat dari pusat kota',
          'description': 'Persiapan perjalanan menuju kawasan Baturraden.',
        },
        {
          'time': '09:00',
          'title': 'Lokawisata Baturraden',
          'description': 'Menikmati suasana alam dan area wisata utama.',
        },
        {
          'time': '12:00',
          'title': 'Makan siang',
          'description': 'Istirahat dan makan siang di sekitar kawasan wisata.',
        },
        {
          'time': '14:00',
          'title': 'Curug Bayan',
          'description': 'Mengunjungi area air terjun dan berfoto.',
        },
      ],
    },
    {
      'title': 'Wisata Kuliner Purwokerto',
      'date': '05 Jul - 07 Jul 2026',
      'destinationCount': '3 destinasi',
      'items': [
        {
          'time': '10:00',
          'title': 'Soto Sokaraja',
          'description': 'Mencoba kuliner khas Banyumas.',
        },
        {
          'time': '13:00',
          'title': 'Mendoan Purwokerto',
          'description': 'Mencicipi makanan ringan khas daerah.',
        },
        {
          'time': '19:00',
          'title': 'Alun-alun Purwokerto',
          'description': 'Menikmati suasana malam dan kuliner sekitar alun-alun.',
        },
      ],
    },
    {
      'title': 'Jelajah Kota Banyumas',
      'date': '20 Jun 2026',
      'destinationCount': '5 destinasi',
      'items': [
        {
          'time': '08:30',
          'title': 'Museum Bank Rakyat Indonesia',
          'description': 'Melihat sejarah dan koleksi museum.',
        },
        {
          'time': '10:30',
          'title': 'Menara Pandang Teratai',
          'description': 'Melihat pemandangan kota dari area menara.',
        },
        {
          'time': '13:00',
          'title': 'Taman Kota',
          'description': 'Istirahat dan menikmati suasana kota.',
        },
        {
          'time': '15:00',
          'title': 'Pusat Oleh-oleh',
          'description': 'Membeli buah tangan khas Banyumas.',
        },
        {
          'time': '17:00',
          'title': 'Kembali',
          'description': 'Perjalanan pulang setelah kegiatan selesai.',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: AppSpacing.md,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=11',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            RichText(
              text: TextSpan(
                style: AppTextStyles.title,
                children: const [
                  TextSpan(text: 'Halo, '),
                  TextSpan(
                    text: 'Saputra ',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  TextSpan(text: '👋'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Text(
              'Riwayat Itinerary',
              style: AppTextStyles.heading1.copyWith(
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Lihat kembali rencana perjalanan yang sudah dibuat.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _itineraries.length,
              itemBuilder: (context, index) {
                final itinerary = _itineraries[index];

                return _ItineraryCard(
                  title: itinerary['title'],
                  date: itinerary['date'],
                  destinationCount: itinerary['destinationCount'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItineraryDetailPage(
                          title: itinerary['title'],
                          date: itinerary['date'],
                          destinationCount: itinerary['destinationCount'],
                          items: List<Map<String, String>>.from(
                            itinerary['items'],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _ItineraryCard extends StatelessWidget {
  final String title;
  final String date;
  final String destinationCount;
  final VoidCallback onTap;

  const _ItineraryCard({
    required this.title,
    required this.date,
    required this.destinationCount,
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
                  title,
                  style: AppTextStyles.title.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
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
                            icon: Icons.calendar_today_outlined,
                            text: date,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _InfoRow(
                            icon: Icons.description_outlined,
                            text: destinationCount,
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.textSecondary,
          size: 18,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          text,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class ItineraryDetailPage extends StatelessWidget {
  final String title;
  final String date;
  final String destinationCount;
  final List<Map<String, String>> items;

  const ItineraryDetailPage({
    super.key,
    required this.title,
    required this.date,
    required this.destinationCount,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detail Itinerary',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radius),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: date,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(
                    icon: Icons.description_outlined,
                    text: destinationCount,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Jadwal Perjalanan',
              style: AppTextStyles.title.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return _DetailTimelineItem(
                  time: item['time'] ?? '',
                  title: item['title'] ?? '',
                  description: item['description'] ?? '',
                  isLast: index == items.length - 1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTimelineItem extends StatelessWidget {
  final String time;
  final String title;
  final String description;
  final bool isLast;

  const _DetailTimelineItem({
    required this.time,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 58,
            child: Text(
              time,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
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
                borderRadius: BorderRadius.circular(AppSpacing.radius),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        title,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
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