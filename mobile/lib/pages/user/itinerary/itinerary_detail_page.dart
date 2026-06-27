import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/date_selector.dart';
import '../../../widgets/timeline_item.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/itinerary_provider.dart';
import '../../../models/itinerary_model.dart';

class ItineraryDetailPage extends StatefulWidget {
  final int itineraryId;
  final bool isReadOnly;

  const ItineraryDetailPage({
    super.key,
    required this.itineraryId,
    this.isReadOnly = false,
  });

  @override
  State<ItineraryDetailPage> createState() => _ItineraryDetailPageState();
}

class _ItineraryDetailPageState extends State<ItineraryDetailPage> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    // Fetch detail itinerary dari API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
    });
  }

  @override
  void dispose() {
    // Bersihkan selected itinerary saat keluar halaman
    context.read<ItineraryProvider>().clearSelectedItinerary();
    super.dispose();
  }

  /// Memuat detail itinerary dari API
  void _loadDetail() {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      context
          .read<ItineraryProvider>()
          .fetchItineraryDetail(token, widget.itineraryId);
    }
  }

  /// Format tanggal ke string yang mudah dibaca
  String _formatDate(DateTime date) {
    const List<String> bulanNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${bulanNames[date.month - 1]} ${date.year}';
  }

  /// Menampilkan modal edit itinerary
  void _showEditItineraryModal(BuildContext context, ItineraryModel itinerary) {
    final titleController = TextEditingController(text: itinerary.title);
    final noteController = TextEditingController(text: itinerary.note ?? '');
    DateTime? startDate = itinerary.startDate;
    DateTime? endDate = itinerary.endDate;
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

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
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                          'Edit Itinerary',
                          style: AppTextStyles.heading2.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ubah detail rencana perjalananmu',
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
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.border),
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
                                      final DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: startDate ?? DateTime.now(),
                                        firstDate: DateTime(2024),
                                        lastDate: DateTime(2030),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: const ColorScheme.light(
                                                primary: AppColors.primary,
                                                onPrimary: AppColors.onPrimary,
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
                                          if (endDate != null && endDate!.isBefore(picked)) {
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
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.border),
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
                                              style: AppTextStyles.body.copyWith(
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
                                      final DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: endDate ?? startDate ?? DateTime.now(),
                                        firstDate: startDate ?? DateTime(2024),
                                        lastDate: DateTime(2030),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: const ColorScheme.light(
                                                primary: AppColors.primary,
                                                onPrimary: AppColors.onPrimary,
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
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.border),
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
                                              style: AppTextStyles.body.copyWith(
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
                            hintText: 'Tambahkan catatan untuk perjalananmu...',
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
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.border),
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
                            onPressed: isSaving
                                ? null
                                : () async {
                                    if (formKey.currentState!.validate()) {
                                      setModalState(() => isSaving = true);

                                      final token = context.read<AuthProvider>().token;
                                      if (token == null) return;

                                      final error = await context
                                          .read<ItineraryProvider>()
                                          .updateItinerary(
                                            token,
                                            widget.itineraryId,
                                            title: titleController.text.trim(),
                                            startDate: startDate,
                                            endDate: endDate,
                                            note: noteController.text.trim(),
                                          );

                                      if (!context.mounted) return;

                                      if (error == null) {
                                        Navigator.pop(context);
                                        // Refresh detail setelah edit berhasil
                                        _loadDetail();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Itinerary berhasil diperbarui!'),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: AppColors.success,
                                          ),
                                        );
                                      } else {
                                        setModalState(() => isSaving = false);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(error),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
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
                            child: isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppColors.onPrimary,
                                    ),
                                  )
                                : const Text(
                                    'Simpan Perubahan',
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

  /// Mendapatkan list tanggal unik dari items, di-sort.
  List<DateTime> _getUniqueDates(List<ItineraryItemModel> items) {
    final Set<String> seen = {};
    final List<DateTime> dates = [];

    for (final item in items) {
      if (item.visitDate != null) {
        final key =
            '${item.visitDate!.year}-${item.visitDate!.month}-${item.visitDate!.day}';
        if (!seen.contains(key)) {
          seen.add(key);
          dates.add(
            DateTime(
              item.visitDate!.year,
              item.visitDate!.month,
              item.visitDate!.day,
            ),
          );
        }
      }
    }

    dates.sort();
    return dates;
  }

  /// Mendapatkan items untuk tanggal tertentu.
  List<ItineraryItemModel> _getItemsForDate(
    List<ItineraryItemModel> allItems,
    DateTime date,
  ) {
    return allItems.where((item) {
      if (item.visitDate == null) return false;
      return item.visitDate!.year == date.year &&
          item.visitDate!.month == date.month &&
          item.visitDate!.day == date.day;
    }).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  @override
  Widget build(BuildContext context) {
    final itineraryProvider = context.watch<ItineraryProvider>();
    final itinerary = itineraryProvider.selectedItinerary;
    final isLoading = itineraryProvider.isLoading;
    final errorMessage = itineraryProvider.errorMessage;

    // Hitung tanggal-tanggal & items aktif
    final List<DateTime> dates =
        itinerary != null ? _getUniqueDates(itinerary.items) : [];

    // Set selected date jika belum ada atau tidak valid
    if (_selectedDate == null && dates.isNotEmpty) {
      _selectedDate = dates.first;
    }

    final List<ItineraryItemModel> activeItems = _selectedDate != null &&
            itinerary != null
        ? _getItemsForDate(itinerary.items, _selectedDate!)
        : [];

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
      body: _buildBody(
        itinerary: itinerary,
        isLoading: isLoading,
        errorMessage: errorMessage,
        dates: dates,
        activeItems: activeItems,
      ),
    );
  }

  Widget _buildBody({
    required ItineraryModel? itinerary,
    required bool isLoading,
    required String? errorMessage,
    required List<DateTime> dates,
    required List<ItineraryItemModel> activeItems,
  }) {
    // Loading state
    if (isLoading && itinerary == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    // Error state
    if (errorMessage != null && itinerary == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 64,
                color: AppColors.textMuted.withValues(alpha: 0.5),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                errorMessage,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton.icon(
                onPressed: _loadDetail,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Data loaded
    if (itinerary == null) {
      return const Center(child: Text('Data tidak ditemukan'));
    }

    return SingleChildScrollView(
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
                        itinerary.title,
                        style: AppTextStyles.heading1.copyWith(
                          color: const Color(0xFF0F172A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Tombol Edit untuk mengubah judul, tanggal, catatan
                    if (!widget.isReadOnly)
                      IconButton(
                        onPressed: () {
                          _showEditItineraryModal(context, itinerary);
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
                  itinerary.dateRangeText,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // 4. Catatan (jika ada)
                if (itinerary.note != null && itinerary.note!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.notes_outlined,
                          size: 18,
                          color: AppColors.primary.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Catatan',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                itinerary.note!,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),

          // Date Selector — hanya tampil jika ada tanggal
          if (dates.isNotEmpty)
            DateSelector(
              dates: dates,
              selectedDate: _selectedDate!,
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
                // Cek apakah ada kegiatan di tanggal ini
                if (dates.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_note_outlined,
                            size: 64,
                            color: AppColors.textMuted.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Belum ada kegiatan dalam itinerary ini',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (activeItems.isEmpty)
                  Center(
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
                else
                  // Loop data dari API untuk menampilkan TimelineItems
                  Column(
                    children: List.generate(activeItems.length, (index) {
                      final item = activeItems[index];
                      final bool isLastItem = index == activeItems.length - 1;

                      return Dismissible(
                        // Key unik berdasarkan ID item dari database
                        key: ValueKey('item_${item.id}'),

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
                                  'Apakah kamu yakin ingin menghapus "${item.destinationName}" dari rencana perjalanan?',
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

                        // 2. Aksi setelah user menekan tombol 'Hapus'
                        onDismissed: (direction) async {
                          final token = context.read<AuthProvider>().token;
                          if (token == null) return;

                          final error = await context
                              .read<ItineraryProvider>()
                              .removeItem(
                                token,
                                widget.itineraryId,
                                item.id,
                              );

                          if (!context.mounted) return;

                          if (error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                              ),
                            );
                            // Refresh jika gagal
                            _loadDetail();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '"${item.destinationName}" berhasil dihapus',
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        },

                        // Widget asli yang dibungkus gestur swipe
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.md,
                          ),
                          child: TimelineItem(
                            key: ValueKey('timeline_${item.id}'),
                            time: item.visitTime ?? '--:--',
                            title: item.destinationName,
                            category: item.destinationCategory,
                            categoryIcon: item.categoryIcon,
                            distanceText: item.destinationAddress,
                            imageUrl: item.destinationThumbnail.isNotEmpty
                                ? item.destinationThumbnail
                                : 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=300',
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
    );
  }
}
