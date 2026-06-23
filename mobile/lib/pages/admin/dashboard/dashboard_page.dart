import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/admin/stat_card.dart';
import '../../../providers/admin/dashboard_provider.dart';
import '../../../models/review.dart';
import '../../../models/destination.dart';

/// Body dashboard admin DOKEMAS (UI connected to backend).
/// Dibungkus AppBar + bottom navbar oleh [AdminShell].
class AdminDashboardPage extends StatefulWidget {
  final VoidCallback? onNavigateToReviews;
  final VoidCallback? onNavigateToDestinations;

  const AdminDashboardPage({
    super.key,
    this.onNavigateToReviews,
    this.onNavigateToDestinations,
  });

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(provider.error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchDashboardStats(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final stats = provider.stats;
        if (stats == null) {
          return const Center(child: Text('Tidak ada data'));
        }

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            const _Greeting(),
            const SizedBox(height: AppSpacing.lg),

            // Kartu statistik
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.35,
              children: [
                StatCard(
                  label: 'TOTAL DESTINASI',
                  value: '${stats.totalDestinations}',
                  icon: Icons.terrain_outlined,
                  color: AppColors.statBlue,
                ),
                StatCard(
                  label: 'TOTAL KATEGORI',
                  value: '${stats.totalCategories}',
                  icon: Icons.category_outlined,
                  color: AppColors.statGreen,
                ),
                StatCard(
                  label: 'TOTAL USER',
                  value: '${stats.totalUsers}',
                  icon: Icons.people_outline,
                  color: AppColors.statOrange,
                ),
                StatCard(
                  label: 'TOTAL REVIEW',
                  value: '${stats.totalReviews}',
                  icon: Icons.rate_review_outlined,
                  color: AppColors.statPurple,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Review terbaru
            _Card(
              child: Column(
                children: [
              _SectionHeader(
                title: 'Review Terbaru',
                onTap: widget.onNavigateToReviews ?? () {},
              ),
                  const SizedBox(height: AppSpacing.sm),
                  if (stats.latestReviews.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Text('Belum ada review'),
                    ),
                  for (int i = 0; i < stats.latestReviews.length; i++) ...[
                    if (i > 0) const Divider(height: AppSpacing.lg),
                    _ReviewTile(review: stats.latestReviews[i]),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Destinasi populer
            _Card(
              child: Column(
                children: [
              _SectionHeader(
                title: 'Destinasi Populer',
                onTap: widget.onNavigateToDestinations ?? () {},
              ),
                  const SizedBox(height: AppSpacing.sm),
                  if (stats.topDestinations.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Text('Belum ada destinasi'),
                    ),
                  for (final d in stats.topDestinations) _DestinationTile(dest: d),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        );
      },
    );
  }
}



class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Dashboard Overview', style: AppTextStyles.heading1),
        SizedBox(height: AppSpacing.xs),
        Text(
          'Selamat datang kembali, Admin. Berikut data terbaru.',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

/// Kartu putih pembungkus section.
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _SectionHeader({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.title),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Lihat Semua',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Review review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primaryLight.withValues(alpha: 0.3),
          child: Text(
            review.initial,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(review.userName, style: AppTextStyles.title),
                  ),
                  _Stars(rating: review.rating),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '"${review.comment}"',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 4),
              Text(
                '${review.destinationName} • ${review.date}',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stars extends StatelessWidget {
  final double rating;
  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star : Icons.star_border,
          size: 14,
          color: AppColors.accent,
        );
      }),
    );
  }
}

class _DestinationTile extends StatelessWidget {
  final Destination dest;
  const _DestinationTile({required this.dest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.image_outlined, color: AppColors.textMuted),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dest.name, style: AppTextStyles.title),
                const SizedBox(height: 2),
                Text('${dest.reviews} reviews', style: AppTextStyles.caption),
              ],
            ),
          ),
          const Icon(Icons.trending_up, color: AppColors.success, size: 20),
        ],
      ),
    );
  }
}


