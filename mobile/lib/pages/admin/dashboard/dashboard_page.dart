import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/admin/stat_card.dart';

/// Body dashboard admin DOKEMAS (UI only, data dummy, belum konek backend).
/// Dibungkus AppBar + bottom navbar oleh [AdminShell].
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          children: const [
            StatCard(
              label: 'TOTAL DESTINASI',
              value: '124',
              icon: Icons.terrain_outlined,
              color: AppColors.statBlue,
            ),
            StatCard(
              label: 'TOTAL KATEGORI',
              value: '12',
              icon: Icons.category_outlined,
              color: AppColors.statGreen,
            ),
            StatCard(
              label: 'TOTAL USER',
              value: '3.450',
              icon: Icons.people_outline,
              color: AppColors.statOrange,
            ),
            StatCard(
              label: 'TOTAL REVIEW',
              value: '892',
              icon: Icons.rate_review_outlined,
              color: AppColors.statPurple,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Review terbaru (satu kartu berisi daftar)
        _Card(
          child: Column(
            children: [
              _SectionHeader(title: 'Review Terbaru', onTap: () {}),
              const SizedBox(height: AppSpacing.sm),
              for (int i = 0; i < _dummyReviews.length; i++) ...[
                if (i > 0) const Divider(height: AppSpacing.lg),
                _ReviewTile(review: _dummyReviews[i]),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Destinasi populer (satu kartu berisi daftar)
        _Card(
          child: Column(
            children: [
              _SectionHeader(title: 'Destinasi Populer', onTap: () {}),
              const SizedBox(height: AppSpacing.sm),
              for (final d in _dummyDestinations) _DestinationTile(dest: d),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
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
  final _Review review;
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
            review.name[0],
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
                    child: Text(review.name, style: AppTextStyles.title),
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
                '${review.destination} • ${review.timeAgo}',
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
  final _Destination dest;
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
                Text('${dest.views} views', style: AppTextStyles.caption),
              ],
            ),
          ),
          const Icon(Icons.trending_up, color: AppColors.success, size: 20),
        ],
      ),
    );
  }
}

// ===== Data dummy (UI only) =====

class _Review {
  final String name;
  final String comment;
  final double rating;
  final String destination;
  final String timeAgo;
  const _Review(
    this.name,
    this.comment,
    this.rating,
    this.destination,
    this.timeAgo,
  );
}

class _Destination {
  final String name;
  final String views;
  const _Destination(this.name, this.views);
}

const _dummyReviews = [
  _Review(
    'Siti Aminah',
    'Baturraden sangat indah! Fasilitas sudah membaik tapi tolong perhatikan kebersihan toiletnya.',
    5,
    'Baturraden',
    '2 jam lalu',
  ),
  _Review(
    'Budi Santoso',
    'Curug Jenggala bagus buat foto-foto, jalurnya lumayan menantang.',
    4,
    'Curug Jenggala',
    '5 jam lalu',
  ),
];

const _dummyDestinations = [
  _Destination('Baturraden', '1.240'),
  _Destination('Telaga Sunyi', '985'),
];
