import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/itinerary_provider.dart';
import '../itinerary/itinerary_detail_page.dart';

class RiwayatItineraryPage extends StatefulWidget {
  const RiwayatItineraryPage({super.key});

  @override
  State<RiwayatItineraryPage> createState() => _RiwayatItineraryPageState();
}

class _RiwayatItineraryPageState extends State<RiwayatItineraryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadItineraries();
    });
  }

  void _loadItineraries() {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      context.read<ItineraryProvider>().fetchItineraries(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itineraryProvider = context.watch<ItineraryProvider>();
    final riwayatItinerary = itineraryProvider.historyItineraries;
    final isLoading = itineraryProvider.isLoading;
    final errorMessage = itineraryProvider.errorMessage;

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
      body: RefreshIndicator(
        onRefresh: () async {
          _loadItineraries();
        },
        color: AppColors.primary,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text(
              'Riwayat rencana perjalanan yang pernah dibuat.',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),

            if (isLoading && riwayatItinerary.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),

            if (errorMessage != null && riwayatItinerary.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
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
                        onPressed: _loadItineraries,
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
              ),

            if (!isLoading && riwayatItinerary.isEmpty && errorMessage == null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    children: [
                      Icon(
                        Icons.history_outlined,
                        size: 64,
                        color: AppColors.textMuted.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Belum ada riwayat perjalanan.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (!isLoading || riwayatItinerary.isNotEmpty)
              ...riwayatItinerary.map((item) {
                return Dismissible(
                  key: ValueKey('riwayat_${item.id}'),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: AppSpacing.md),
                    margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
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
                            'Hapus Riwayat?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            'Apakah kamu yakin ingin menghapus "${item.title}" beserta seluruh kegiatan di dalamnya?',
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
                  onDismissed: (direction) async {
                    final token = context.read<AuthProvider>().token;
                    if (token == null) return;

                    final error = await context
                        .read<ItineraryProvider>()
                        .deleteItinerary(token, item.id);

                    if (!context.mounted) return;

                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red,
                        ),
                      );
                      _loadItineraries();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '"${item.title}" berhasil dihapus dari riwayat',
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  child: _RiwayatCard(
                    judul: item.title,
                    tanggal: item.dateRangeText,
                    jumlah: '${item.itemsCount} destinasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItineraryDetailPage(
                            itineraryId: item.id,
                            isReadOnly: true,
                          ),
                        ),
                      ).then((_) {
                        _loadItineraries();
                      });
                    },
                  ),
                );
              }),
          ],
        ),
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
                      color: Colors.black.withValues(alpha: 0.04),
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
