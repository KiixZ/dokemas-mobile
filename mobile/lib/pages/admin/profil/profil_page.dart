import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import 'edit_profil_page.dart';
import '../../change_password_page.dart';
import '../../main_screen.dart';

/// Body profil admin: kartu identitas + menu akun + logout.
/// UI only. Dibungkus AppBar + navbar oleh [AdminShell].
class AdminProfilPage extends StatelessWidget {
  const AdminProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Kartu identitas
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(user.name, style: AppTextStyles.heading2),
              const SizedBox(height: 2),
              Text(user.email, style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Text(
                  user.role.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Menu akun
        _MenuSection(
          title: 'Akun',
          items: [
            _MenuItem(
              icon: Icons.edit_outlined,
              label: 'Edit Profil',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => EditProfilPage(user: user)),
              ),
            ),
            _MenuItem(
              icon: Icons.lock_outline,
              label: 'Ubah Password',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        _MenuSection(
          title: 'Aplikasi',
          items: [
            _MenuItem(
              icon: Icons.notifications_outlined,
              label: 'Notifikasi',
              onTap: () => _soon(context),
            ),
            _MenuItem(
              icon: Icons.help_outline,
              label: 'Bantuan',
              onTap: () => _soon(context),
            ),
            _MenuItem(
              icon: Icons.info_outline,
              label: 'Tentang DOKEMAS',
              onTap: () => _soon(context),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Logout
        SizedBox(
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => _confirmLogout(context),
            icon: const Icon(Icons.logout, color: AppColors.danger),
            label: const Text(
              'Logout',
              style: TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.danger),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radius),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Center(
          child: Text('DOKEMAS v1.0.0', style: AppTextStyles.caption),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Fitur belum dibuat')));
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('Yakin mau keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (yes == true && context.mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      }
    }
  }
}

/// Section menu dengan judul + kartu daftar item.
class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.sm,
          ),
          child: Text(title, style: AppTextStyles.caption),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0) const Divider(height: 1, indent: AppSpacing.md),
                items[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: AppTextStyles.body),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
