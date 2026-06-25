import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/date_selector.dart';
import '../../../widgets/timeline_item.dart';

class ItineraryDetailPage extends StatefulWidget {
  final String titleHeader;
  final List<Map<String, dynamic>> itineraryItems;

  const ItineraryDetailPage({
    super.key,
    required this.titleHeader,
    required this.itineraryItems,
  });

  @override
  State<ItineraryDetailPage> createState() => _ItineraryDetailPageState();
}

class _ItineraryDetailPageState extends State<ItineraryDetailPage> {
  late List<Map<String, dynamic>> _itineraryItems;
  late List<DateTime> _dates;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    // Deep copy data agar perubahan lokal tidak mempengaruhi data asli
    _itineraryItems = widget.itineraryItems.map((item) {
      return {
        'date': item['date'],
        'activities': List<Map<String, dynamic>>.from(
          (item['activities'] as List).map((a) => Map<String, dynamic>.from(a)),
        ),
      };
    }).toList();

    // Ambil semua tanggal dari items lalu sort
    _dates = _itineraryItems.map((item) => item['date'] as DateTime).toList()
      ..sort();

    _selectedDate = _dates.isNotEmpty ? _dates.first : DateTime.now();
  }

  /// Mendapatkan rentang tanggal dalam format "21 - 22 Jun 2026"
  String _getDateRangeText() {
    if (_dates.isEmpty) return 'Tanggal Tidak Tersedia';

    const List<String> bulanNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final DateTime first = _dates.first;
    final DateTime last = _dates.last;

    if (first.year == last.year &&
        first.month == last.month &&
        first.day == last.day) {
      return '${first.day} ${bulanNames[first.month - 1]} ${first.year}';
    }

    if (first.month == last.month && first.year == last.year) {
      return '${first.day} - ${last.day} ${bulanNames[first.month - 1]} ${first.year}';
    }

    return '${first.day} ${bulanNames[first.month - 1]} - ${last.day} ${bulanNames[last.month - 1]} ${last.year}';
  }

  /// Cari index itinerary berdasarkan tanggal terpilih
  int _getItineraryIndex(DateTime date) {
    return _itineraryItems.indexWhere((element) {
      final DateTime itineraryDate = element['date'] as DateTime;
      return itineraryDate.year == date.year &&
          itineraryDate.month == date.month &&
          itineraryDate.day == date.day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int activeIndex = _getItineraryIndex(_selectedDate);
    final Map<String, dynamic> activeDay = activeIndex != -1
        ? _itineraryItems[activeIndex]
        : {'activities': []};
    final List<dynamic> activeActivityItems = activeDay['activities'] ?? [];

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Itinerary',
          style: AppTextStyles.title.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),

                  // 1. Label Kecil di Atas (Caption Style)
                  Text(
                    'Rencana Perjalanan',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 2. Title Itinerary Utama (Heading Besar & Bold) + Icon Edit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.titleHeader,
                          style: AppTextStyles.heading1.copyWith(
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Tombol Edit Opsional agar User Bisa Rename Title
                      IconButton(
                        onPressed: () {
                          // Aksi edit title itinerary
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // 3. Rentang Tanggal Dinamis
                  Text(
                    _getDateRangeText(),
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
            DateSelector(
              dates: _dates,
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  // 1. Cek apakah ada kegiatan di tanggal ini
                  activeActivityItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Text(
                              'Ayo tambahkan kegiatan untuk tanggal ini!',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                      // 2. Jika ada, loop data dinamis untuk menampilkan TimelineItems
                      : Column(
                          children: List.generate(activeActivityItems.length, (
                            index,
                          ) {
                            final Map<String, dynamic> activity =
                                Map<String, dynamic>.from(
                                  activeActivityItems[index],
                                );
                            final bool isLastItem =
                                index == activeActivityItems.length - 1;

                            return Dismissible(
                              // Key unik gabungan judul dan jam agar state widget tidak tertukar saat dihapus
                              key: ValueKey(
                                '${activity['title']}_${activity['time']}',
                              ),

                              // Mengizinkan swipe ke arah horizontal (Kanan & Kiri)
                              direction: DismissDirection.horizontal,

                              // Background merah saat di-swipe ke KANAN
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                  left: AppSpacing.md,
                                ),
                                margin: const EdgeInsets.only(
                                  bottom: AppSpacing.md,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),

                              // Background merah saat di-swipe ke KIRI
                              secondaryBackground: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(
                                  right: AppSpacing.md,
                                ),
                                margin: const EdgeInsets.only(
                                  bottom: AppSpacing.md,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),

                              // 1. Validasi konfirmasi sebelum benar-benar terhapus
                              confirmDismiss: (direction) async {
                                final bool? konfirmasi = await showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Text(
                                        'Hapus Kegiatan?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        'Apakah kamu yakin ingin menghapus "${activity['title']}" dari rencana perjalanan?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(
                                            dialogContext,
                                          ).pop(false),
                                          child: const Text(
                                            'Batal',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.of(
                                            dialogContext,
                                          ).pop(true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return konfirmasi ?? false;
                              },

                              // 2. Aksi setelah user menekan tombol 'Hapus' di dialog konfirmasi
                              onDismissed: (direction) {
                                setState(() {
                                  final int itineraryIndex = _getItineraryIndex(
                                    _selectedDate,
                                  );
                                  if (itineraryIndex != -1) {
                                    _itineraryItems[itineraryIndex]['activities']
                                        .removeAt(index);
                                  }
                                });
                              },

                              // Widget asli yang dibungkus gestur swipe
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.md,
                                ),
                                child: TimelineItem(
                                  key: ValueKey(activity['title']),
                                  time: activity['time'],
                                  title: activity['title'],
                                  category: activity['category'],
                                  categoryIcon: activity['categoryIcon'],
                                  distanceText: activity['distanceText'],
                                  imageUrl: activity['imageUrl'],
                                  isLast: isLastItem,
                                ),
                              ),
                            );
                          }),
                        ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
