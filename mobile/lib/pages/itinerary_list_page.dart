import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'itinerary_detail_page.dart';

class ItineraryListPage extends StatefulWidget {
  final bool autoOpenAddForm;
  const ItineraryListPage({super.key, this.autoOpenAddForm = false});

  @override
  State<ItineraryListPage> createState() => _ItineraryListPageState();
}

class _ItineraryListPageState extends State<ItineraryListPage> {
  final List<Map<String, dynamic>> _allItineraries = [
    {
      'titleHeader': 'Liburan ke Baturraden',
      'items': [
        {
          'date': DateTime(2026, 6, 21),
          'activities': [
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
          'activities': [
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
      ],
    },
    {
      'titleHeader': 'Wisata Kuliner Purwokerto',
      'items': [
        {
          'date': DateTime(2026, 7, 1),
          'activities': [
            {
              'time': '10:00',
              'title': 'Soto Sokaraja H. Loso',
              'category': 'Kuliner Khas',
              'categoryIcon': Icons.restaurant_outlined,
              'distanceText': '15 mnt dari pusat kota',
              'imageUrl':
                  'https://images.unsplash.com/photo-1548943487-a2e4f43b4850?q=80&w=2070&auto=format&fit=crop',
            },
            {
              'time': '13:00',
              'title': 'Mendoan Purwokerto',
              'category': 'Kuliner Lokal',
              'categoryIcon': Icons.flatware_outlined,
              'distanceText': '10 mnt perjalanan',
              'imageUrl':
                  'https://images.unsplash.com/photo-1547928576-a4a33237bec3?q=80&w=2070&auto=format&fit=crop',
            },
          ],
        },
        {
          'date': DateTime(2026, 7, 2),
          'activities': [
            {
              'time': '09:00',
              'title': 'Pasar Wage Purwokerto',
              'category': 'Belanja',
              'categoryIcon': Icons.shopping_bag_outlined,
              'distanceText': '10 mnt dari hotel',
              'imageUrl':
                  'https://images.unsplash.com/photo-1555899434-94d1368aa7af?q=80&w=2070&auto=format&fit=crop',
            },
            {
              'time': '12:00',
              'title': 'Nasi Liwet Bu Wir',
              'category': 'Makan Siang',
              'categoryIcon': Icons.restaurant_outlined,
              'distanceText': '5 mnt perjalanan',
              'imageUrl':
                  'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1974&auto=format&fit=crop',
            },
          ],
        },
        {
          'date': DateTime(2026, 7, 3),
          'activities': [
            {
              'time': '19:00',
              'title': 'Alun-alun Purwokerto',
              'category': 'Kuliner Malam',
              'categoryIcon': Icons.nightlight_round_outlined,
              'distanceText': 'Jalan kaki dari penginapan',
              'imageUrl':
                  'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1974&auto=format&fit=crop',
            },
          ],
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.autoOpenAddForm) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddItineraryModal(context);
      });
    }
  }

  /// Menghitung rentang tanggal dari data items itinerary
  String _getDateRange(List<dynamic> items) {
    if (items.isEmpty) return 'Belum ada tanggal';

    final List<DateTime> dates =
        items.map((item) => item['date'] as DateTime).toList();
    dates.sort();

    final DateTime first = dates.first;
    final DateTime last = dates.last;

    const List<String> bulanNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des',
    ];

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

  /// Menghitung total kegiatan dari semua hari
  int _getTotalActivities(List<dynamic> items) {
    int total = 0;
    for (final item in items) {
      final List<dynamic> activities = item['activities'] ?? [];
      total += activities.length;
    }
    return total;
  }

  /// Format tanggal ke string yang mudah dibaca
  String _formatDate(DateTime date) {
    const List<String> bulanNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${bulanNames[date.month - 1]} ${date.year}';
  }

  /// Menampilkan modal bottom sheet untuk tambah itinerary baru
  void _showAddItineraryModal(BuildContext context) {
    final titleController = TextEditingController();
    final noteController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle bar
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Title modal
                        Text(
                          'Buat Itinerary Baru',
                          style: AppTextStyles.heading2.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Isi detail rencana perjalananmu',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Field: Title
                        Text(
                          'Judul Perjalanan',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: 'Contoh: Liburan ke Baturraden',
                            hintStyle: AppTextStyles.body.copyWith(
                              color: AppColors.textMuted,
                            ),
                            prefixIcon: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Judul perjalanan wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Field: Tanggal Mulai & Selesai (Row)
                        Row(
                          children: [
                            // Start Date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal Mulai',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                        context: context,
                                        initialDate:
                                            startDate ?? DateTime.now(),
                                        firstDate: DateTime(2024),
                                        lastDate: DateTime(2030),
                                        builder: (context, child) {
                                          return Theme(
                                            data:
                                                Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: AppColors.primary,
                                                onPrimary:
                                                    AppColors.onPrimary,
                                                surface: AppColors.surface,
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (picked != null) {
                                        setModalState(() {
                                          startDate = picked;
                                          // Reset end date jika lebih awal
                                          if (endDate != null &&
                                              endDate!.isBefore(picked)) {
                                            endDate = null;
                                          }
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 18,
                                            color: AppColors.textSecondary,
                                          ),
                                          const SizedBox(width: AppSpacing.sm),
                                          Expanded(
                                            child: Text(
                                              startDate != null
                                                  ? _formatDate(startDate!)
                                                  : 'Pilih tanggal',
                                              style: AppTextStyles.body
                                                  .copyWith(
                                                color: startDate != null
                                                    ? AppColors.textPrimary
                                                    : AppColors.textMuted,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            // End Date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal Selesai',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: endDate ??
                                            startDate ??
                                            DateTime.now(),
                                        firstDate:
                                            startDate ?? DateTime(2024),
                                        lastDate: DateTime(2030),
                                        builder: (context, child) {
                                          return Theme(
                                            data:
                                                Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: AppColors.primary,
                                                onPrimary:
                                                    AppColors.onPrimary,
                                                surface: AppColors.surface,
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (picked != null) {
                                        setModalState(() {
                                          endDate = picked;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 18,
                                            color: AppColors.textSecondary,
                                          ),
                                          const SizedBox(width: AppSpacing.sm),
                                          Expanded(
                                            child: Text(
                                              endDate != null
                                                  ? _formatDate(endDate!)
                                                  : 'Pilih tanggal',
                                              style: AppTextStyles.body
                                                  .copyWith(
                                                color: endDate != null
                                                    ? AppColors.textPrimary
                                                    : AppColors.textMuted,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Field: Note
                        Text(
                          'Catatan (Opsional)',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: noteController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText:
                                'Tambahkan catatan untuk perjalananmu...',
                            hintStyle: AppTextStyles.body.copyWith(
                              color: AppColors.textMuted,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 40),
                              child: Icon(
                                Icons.notes_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Tombol Simpan
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (startDate == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Tanggal mulai wajib dipilih',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }

                                final DateTime effectiveEndDate =
                                    endDate ?? startDate!;

                                // Generate list tanggal dari start sampai end
                                final List<Map<String, dynamic>> dateItems =
                                    [];
                                DateTime current = startDate!;
                                while (!current.isAfter(effectiveEndDate)) {
                                  dateItems.add({
                                    'date': DateTime(
                                      current.year,
                                      current.month,
                                      current.day,
                                    ),
                                    'activities': <Map<String, dynamic>>[],
                                  });
                                  current = current.add(
                                    const Duration(days: 1),
                                  );
                                }

                                setState(() {
                                  _allItineraries.add({
                                    'titleHeader':
                                        titleController.text.trim(),
                                    'note': noteController.text.trim(),
                                    'items': dateItems,
                                  });
                                });

                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '"${titleController.text.trim()}" berhasil ditambahkan!',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Buat Itinerary',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        // Tombol Batal
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Batal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final userName = user?.name ?? '';

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
              backgroundImage:
                  NetworkImage('https://i.pravatar.cc/150?img=11'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItineraryModal(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.onPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Header section
          Text(
            'Rencana Perjalanan',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Itinerary Saya',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Kelola dan lihat rencana perjalananmu',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Itinerary cards
          ..._allItineraries.asMap().entries.map((entry) {
            final int itineraryIndex = entry.key;
            final itinerary = entry.value;
            final String title = itinerary['titleHeader'];
            final List<dynamic> items = itinerary['items'] ?? [];
            final String dateRange = _getDateRange(items);
            final int totalActivities = _getTotalActivities(items);
            final int totalDays = items.length;

            return Dismissible(
              key: ValueKey('itinerary_${title}_$itineraryIndex'),
              direction: DismissDirection.horizontal,

              // Background merah saat di-swipe ke KANAN
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: AppSpacing.md),
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),

              // Background merah saat di-swipe ke KIRI
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: AppSpacing.md),
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),

              // Konfirmasi sebelum hapus
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
                        'Hapus Itinerary?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        'Apakah kamu yakin ingin menghapus "$title" beserta seluruh kegiatan di dalamnya?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
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
                              Navigator.of(dialogContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Hapus',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                );
                return konfirmasi ?? false;
              },

              // Aksi setelah user konfirmasi hapus
              onDismissed: (direction) {
                setState(() {
                  _allItineraries.removeAt(itineraryIndex);
                });
              },

              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItineraryDetailPage(
                            titleHeader: title,
                            itineraryItems: List<Map<String, dynamic>>.from(
                              items.map(
                                  (item) => Map<String, dynamic>.from(item)),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.border,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icon container
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.map_outlined,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: AppTextStyles.title.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_rounded,
                                      color: AppColors.textSecondary,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      dateRange,
                                      style:
                                          AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.place_outlined,
                                      color: AppColors.textSecondary,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$totalActivities kegiatan · $totalDays hari',
                                      style:
                                          AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
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
              ),
            );
          }),

          // Empty state hint
          if (_allItineraries.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 64,
                      color: AppColors.textMuted.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Belum ada rencana perjalanan',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tap tombol + untuk mulai membuat itinerary',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
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
