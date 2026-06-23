import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/date_selector.dart';
import '../widgets/timeline_item.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  final List<DateTime> _dates = List.generate(
    7,
    (index) => DateTime.now()
        .subtract(const Duration(days: 2))
        .add(Duration(days: index)),
  );

  final List<Map<String, dynamic>> _itineraryData = [
    {
      'date': DateTime(2026, 6, 21),
      'titleHeader': 'Liburan ke Baturraden',
      'dateRangeHeader': '21 jun 2026',
      'items': [
        {
          'time': '08:00',
          'title': 'Lokawisata Baturraden',
          'category': 'Wisata Alam',
          'categoryIcon': Icons.park_outlined,
          'distanceText': '45 mnt (15 km) dari pusat kota',
          'imageUrl':
              'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=2070&auto=format&fit=crop',
        },
        {
          'time': '12:00',
          'title': 'Soto Sokaraja H. Loso',
          'category': 'Makan Siang',
          'categoryIcon': Icons.restaurant_outlined,
          'distanceText': '20 mnt (8 km) perjalanan',
          'imageUrl':
              'https://images.unsplash.com/photo-1548943487-a2e4f43b4850?q=80&w=2070&auto=format&fit=crop',
        },
        {
          'time': '15:00',
          'title': 'Menara Pandang Teratai',
          'category': 'Ikon Kota',
          'categoryIcon': Icons.location_city_outlined,
          'distanceText': '10 mnt (1.5 km) dari restoran',
          'imageUrl':
              'https://images.unsplash.com/photo-1555899434-94d1368aa7af?q=80&w=2070&auto=format&fit=crop',
        },
        {
          'time': '19:00',
          'title': 'Alun-alun Purwokerto',
          'category': 'Kuliner Malam',
          'categoryIcon': Icons.nightlight_round_outlined,
          'distanceText': 'Jalan kaki (Dekat area menara)',
          'imageUrl':
              'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1974&auto=format&fit=crop',
        },
      ],
    },
    {
      'date': DateTime(2026, 6, 22),
      'titleHeader': 'Keliling Pusat Kota',
      'dateRangeHeader': '22 jun 2026',
      'items': [
        {
          'time': '09:00',
          'title': 'Museum Bank Rakyat Indonesia',
          'category': 'Sejarah',
          'categoryIcon': Icons.museum_outlined,
          'distanceText': '15 mnt (5 km) dari hotel',
          'imageUrl':
              'https://plus.unsplash.com/premium_photo-1678125424564-9694e82f50d9?q=80&w=2070&auto=format&fit=crop',
        },
        {
          'time': '12:00',
          'title': 'Makan Siang di Niki Eco',
          'category': 'Kuliner Lokal',
          'categoryIcon': Icons.flatware_outlined,
          'distanceText': '10 mnt (3 km) perjalanan',
          'imageUrl':
              'https://images.unsplash.com/photo-1547928576-a4a33237bec3?q=80&w=2070&auto=format&fit=crop',
        },
      ],
    },
  ];

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _selectedDate = _itineraryData.isNotEmpty
        ? _itineraryData.first['date'] as DateTime
        : DateTime.now();
  }

  int _getItineraryIndex(DateTime date) {
    return _itineraryData.indexWhere((element) {
      final DateTime itineraryDate = element['date'] as DateTime;
      return itineraryDate.year == date.year &&
          itineraryDate.month == date.month &&
          itineraryDate.day == date.day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final userName = user?.name ?? '';

    final int activeIndex = _getItineraryIndex(_selectedDate);
    // Cari data induk itinerary berdasarkan tanggal yang dipilih user
    final Map<String, dynamic> activeItinerary = activeIndex != -1
        ? _itineraryData[activeIndex]
        : {
            'titleHeader': 'Tambahkan Judul Perjalanan',
            'dateRangeHeader': 'Tanggal Tidak Tersedia',
            'items': [],
          };

    // Ambil data list items/kegiatan yang sudah difilter
    final List<dynamic> activeActivityItems = activeItinerary['items'] ?? [];

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
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
            const SizedBox(width: AppSpacing.sm),
            RichText(
              text: TextSpan(
                style: AppTextStyles.title,
                children: [
                  TextSpan(
                    text: userName.isNotEmpty ? 'Halo, ' : 'Halo!',
                  ),
                  TextSpan(
                    text: userName.isNotEmpty ? '$userName ' : '',
                    style: const TextStyle(color: AppColors.primary),
                  ),
                  const TextSpan(text: '👋'),
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
                          activeItinerary['titleHeader'], // Ganti dengan variabel title nantinya jika sudah dinamis
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

                  // 3. Rentang Tanggal (Menggantikan Teks Lokasi Statis)
                  Text(
                    activeItinerary['dateRangeHeader'],
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
                                ), // Menyesuaikan gap antar item
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
                                  barrierDismissible:
                                      false, // User wajib klik tombol, tidak bisa klik luar layar
                                  builder: (BuildContext context) {
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
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text(
                                            'Batal',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
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
                                final deletedItem = activeActivityItems[index];
                                final int deletedIndex = index;

                                setState(() {
                                  final int itineraryIndex = _getItineraryIndex(
                                    _selectedDate,
                                  );
                                  if (itineraryIndex != -1) {
                                    _itineraryData[itineraryIndex]['items']
                                        .removeAt(index);
                                  }
                                });

                                ScaffoldMessenger.of(
                                  context,
                                ).hideCurrentSnackBar();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${activity['title']} berhasil dihapus',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                    action: SnackBarAction(
                                      label: 'Batal',
                                      textColor: Colors.amber,
                                      onPressed: () {
                                        setState(() {
                                          final int itineraryIndex =
                                              _getItineraryIndex(_selectedDate);
                                          if (itineraryIndex != -1) {
                                            final List itemsList =
                                                _itineraryData[itineraryIndex]['items'];

                                            // Perbaikan 2: Mencegah error Index Out of Bounds saat Undo
                                            if (deletedIndex <=
                                                itemsList.length) {
                                              itemsList.insert(
                                                deletedIndex,
                                                deletedItem,
                                              );
                                            } else {
                                              itemsList.add(deletedItem);
                                            }
                                          }
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).hideCurrentSnackBar();
                                      },
                                    ),
                                  ),
                                );
                              },

                              // Widget asli yang dibungkus gestur swipe
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.md,
                                ), // Memberi space bawah untuk background Dismissible
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
