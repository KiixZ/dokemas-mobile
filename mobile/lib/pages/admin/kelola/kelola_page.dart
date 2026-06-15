import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../fasilitas/fasilitas_page.dart';
import '../kategori/kategori_page.dart';
import '../user/user_page.dart';

/// Hub "Kelola": pintu masuk ke master data (Kategori, Fasilitas, User).
/// Body tab di [AdminShell]. UI only.
class AdminKelolaPage extends StatelessWidget {
  const AdminKelolaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const Text('Kelola Data', style: AppTextStyles.heading1),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Atur master data aplikasi.',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppSpacing.lg),
        _MenuCard(
          icon: Icons.category_outlined,
          title: 'Kategori',
          subtitle: 'Klasifikasi destinasi',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AdminKategoriPage()),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _MenuCard(
          icon: Icons.add_business_outlined,
          title: 'Fasilitas',
          subtitle: 'Fasilitas yang tersedia di destinasi',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AdminFasilitasPage()),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _MenuCard(
          icon: Icons.people_outline,
          title: 'User',
          subtitle: 'Kelola akun pengguna',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AdminUserPage()),
          ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.title),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
