import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../models/review.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/review_provider.dart';

class UlasanSayaPage extends StatefulWidget {
  const UlasanSayaPage({super.key});

  @override
  State<UlasanSayaPage> createState() => _UlasanSayaPageState();
}

class _UlasanSayaPageState extends State<UlasanSayaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReviews();
    });
  }

  void _loadReviews() {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      context.read<ReviewProvider>().fetchReviews(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data user yang sedang login
    final user = context.watch<AuthProvider>().user;
    final currentUserId = user?.id ?? -1;

    // Ambil data dari provider
    final reviewProvider = context.watch<ReviewProvider>();
    final allReviews = reviewProvider.reviews;
    final isLoading = reviewProvider.isLoading;
    final errorMessage = reviewProvider.errorMessage;

    // Filter agar hanya memunculkan ulasan milik user yang sedang login
    final ulasanSaya = allReviews.where((r) => r.userId == currentUserId).toList();

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
          'Ulasan Saya',
          style: AppTextStyles.title.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadReviews();
        },
        color: AppColors.primary,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text(
              'Daftar ulasan yang pernah kamu berikan pada destinasi wisata.',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),

            if (isLoading && ulasanSaya.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),

            if (errorMessage != null && ulasanSaya.isEmpty)
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
                        onPressed: _loadReviews,
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

            if (!isLoading && ulasanSaya.isEmpty && errorMessage == null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_border_rounded,
                        size: 64,
                        color: AppColors.textMuted.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Kamu belum pernah memberikan ulasan.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (!isLoading || ulasanSaya.isNotEmpty)
              ...ulasanSaya.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.star_border_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.destinationName,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: Color(0xFFFBBF24),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.rating.toStringAsFixed(1),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.date,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.comment,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
