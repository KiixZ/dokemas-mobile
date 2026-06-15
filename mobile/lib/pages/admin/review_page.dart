import 'package:flutter/material.dart';
import '../../models/review.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Body kelola review: header + search + filter + daftar kartu + pagination.
/// UI only. Dibungkus AppBar + navbar oleh [AdminShell].
class AdminReviewPage extends StatefulWidget {
  const AdminReviewPage({super.key});

  @override
  State<AdminReviewPage> createState() => _AdminReviewPageState();
}

class _AdminReviewPageState extends State<AdminReviewPage> {
  late final List<Review> _items = List.of(dummyReviews);
  String _query = '';
  String _filter = 'All Reviews';

  static const _filters = ['All Reviews', 'Pending Review', 'Reported'];

  List<Review> get _visible {
    return _items.where((r) {
      final okFilter = switch (_filter) {
        'Reported' => r.status == ReviewStatus.reported,
        'Pending Review' => r.status == ReviewStatus.hidden,
        _ => true,
      };
      final okQuery = _query.isEmpty ||
          r.name.toLowerCase().contains(_query.toLowerCase()) ||
          r.destination.toLowerCase().contains(_query.toLowerCase());
      return okFilter && okQuery;
    }).toList();
  }

  void _setStatus(Review r, ReviewStatus s) {
    final i = _items.indexOf(r);
    if (i != -1) setState(() => _items[i] = r.copyWith(status: s));
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const Text('Review Management', style: AppTextStyles.heading1),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Monitor and moderate user feedback across all destinations.',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppSpacing.md),

        // Search
        TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Search reviews...',
            prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Filter chip
        Wrap(
          spacing: AppSpacing.sm,
          children: _filters.map((f) {
            final selected = f == _filter;
            return ChoiceChip(
              label: Text(f),
              selected: selected,
              showCheckmark: false,
              onSelected: (_) => setState(() => _filter = f),
              labelStyle: TextStyle(
                color: selected ? AppColors.onPrimary : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary,
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.border,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),

        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: Text('Tidak ada review', style: AppTextStyles.caption),
            ),
          )
        else
          for (int i = 0; i < items.length; i++) ...[
            _ReviewCard(
              review: items[i],
              color: reviewAvatarColors[i % reviewAvatarColors.length],
              onHide: () => _setStatus(items[i], ReviewStatus.hidden),
              onShow: () => _setStatus(items[i], ReviewStatus.public),
              onDelete: () => _confirmDelete(items[i]),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

        const SizedBox(height: AppSpacing.sm),
        const _Pagination(),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Future<void> _confirmDelete(Review r) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus review?'),
        content: Text('Hapus review dari "${r.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Hapus', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (yes == true) setState(() => _items.remove(r));
  }
}

/// Kartu satu review.
class _ReviewCard extends StatelessWidget {
  final Review review;
  final Color color;
  final VoidCallback onHide;
  final VoidCallback onShow;
  final VoidCallback onDelete;

  const _ReviewCard({
    required this.review,
    required this.color,
    required this.onHide,
    required this.onShow,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hidden = review.status == ReviewStatus.hidden;
    final reported = review.status == ReviewStatus.reported;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + nama/tanggal + rating
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color,
                child: Text(
                  review.initial,
                  style: const TextStyle(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.name, style: AppTextStyles.title),
                    Text(review.date, style: AppTextStyles.caption),
                  ],
                ),
              ),
              _RatingBadge(rating: review.rating),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Chip destinasi
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(review.destination, style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Banner flag (reported)
          if (reported && review.flagReason != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flag_outlined,
                      size: 16, color: AppColors.danger),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Flagged by ${review.flagCount} users for ${review.flagReason}.',
                      style: const TextStyle(
                        color: AppColors.danger,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Komentar
          Text(
            hidden ? review.comment : '"${review.comment}"',
            style: hidden
                ? AppTextStyles.caption.copyWith(
                    fontStyle: FontStyle.italic,
                  )
                : AppTextStyles.body,
          ),
          const Divider(height: AppSpacing.lg),

          // Status + aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusLabel(status: review.status),
              Row(
                children: [
                  if (hidden || reported)
                    _ActionBtn(
                      icon: Icons.visibility_outlined,
                      color: AppColors.primary,
                      tooltip: 'Tampilkan',
                      onTap: onShow,
                    )
                  else
                    _ActionBtn(
                      icon: Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                      tooltip: 'Sembunyikan',
                      onTap: onHide,
                    ),
                  const SizedBox(width: AppSpacing.sm),
                  _ActionBtn(
                    icon: Icons.delete_outline,
                    color: AppColors.danger,
                    tooltip: 'Hapus',
                    onTap: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 14, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.title,
          ),
        ],
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final ReviewStatus status;
  const _StatusLabel({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ReviewStatus.public => ('Public', AppColors.primary),
      ReviewStatus.reported => ('Reported', AppColors.danger),
      ReviewStatus.hidden => ('Hidden', AppColors.textMuted),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}

/// Pagination statis (UI only).
class _Pagination extends StatelessWidget {
  const _Pagination();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PageBtn(child: const Icon(Icons.chevron_left, size: 18)),
        const SizedBox(width: AppSpacing.xs),
        _PageBtn(label: '1', active: true),
        const SizedBox(width: AppSpacing.xs),
        _PageBtn(label: '2'),
        const SizedBox(width: AppSpacing.xs),
        _PageBtn(label: '3'),
        const SizedBox(width: AppSpacing.xs),
        _PageBtn(label: '...'),
        const SizedBox(width: AppSpacing.xs),
        _PageBtn(child: const Icon(Icons.chevron_right, size: 18)),
      ],
    );
  }
}

class _PageBtn extends StatelessWidget {
  final String? label;
  final Widget? child;
  final bool active;
  const _PageBtn({this.label, this.child, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: child ??
          Text(
            label ?? '',
            style: TextStyle(
              color: active ? AppColors.onPrimary : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
    );
  }
}
