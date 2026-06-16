import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Halaman Profil Pengguna
/// Menampilkan biografi ringkas pengguna, menu akun, aktivitas, pengaturan, dan dukungan.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State untuk switch tombol interaktif
  bool _isNotificationEnabled = true;
  bool _isDarkModeEnabled = false;

  // Method untuk menampilkan dialog konfirmasi keluar
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
        ),
        title: const Text(
          'Konfirmasi Keluar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari akun DOKEMAS?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Anda telah keluar dari akun'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
              );
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=11', // Profile pic kustom
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            RichText(
              text: TextSpan(
                style: AppTextStyles.title,
                children: const [
                  TextSpan(text: 'Halo, '),
                  TextSpan(
                    text: 'Saputra ',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '👋'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Membuka Notifikasi (Placeholder)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. KARTU PROFIL UTAMA
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    // Avatar dengan bingkai premium
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 46,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200&auto=format&fit=crop',
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Nama
                    Text(
                      'Saputra',
                      style: AppTextStyles.heading2.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // Lokasi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Banyumas, Jawa Tengah',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // 2. SEKSI AKUN SAYA
            _SettingsSection(
              title: 'AKUN SAYA',
              tiles: [
                _SettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profil',
                  onTap: () => _showPlaceholderSnackBar('Edit Profil'),
                ),
                _SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Ganti Password',
                  onTap: () => _showPlaceholderSnackBar('Ganti Password'),
                ),
              ],
            ),

            // 3. SEKSI AKTIVITAS
            _SettingsSection(
              title: 'AKTIVITAS',
              tiles: [
                _SettingsTile(
                  icon: Icons.history_rounded,
                  title: 'Riwayat Itinerary',
                  onTap: () => _showPlaceholderSnackBar('Riwayat Itinerary'),
                ),
                _SettingsTile(
                  icon: Icons.star_border_rounded,
                  title: 'Ulasan Saya',
                  onTap: () => _showPlaceholderSnackBar('Ulasan Saya'),
                ),
              ],
            ),

            // 4. SEKSI PENGATURAN
            _SettingsSection(
              title: 'PENGATURAN',
              tiles: [
                _SettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifikasi',
                  trailing: Switch(
                    value: _isNotificationEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _isNotificationEnabled = val;
                      });
                    },
                  ),
                ),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Bahasa',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Indonesia',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                    ],
                  ),
                  onTap: () => _showPlaceholderSnackBar('Ubah Bahasa'),
                ),
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Mode Gelap',
                  trailing: Switch(
                    value: _isDarkModeEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _isDarkModeEnabled = val;
                      });
                    },
                  ),
                ),
              ],
            ),

            // 5. SEKSI DUKUNGAN
            _SettingsSection(
              title: 'DUKUNGAN',
              tiles: [
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Pusat Bantuan',
                  onTap: () => _showPlaceholderSnackBar('Pusat Bantuan'),
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Kebijakan Privasi',
                  onTap: () => _showPlaceholderSnackBar('Kebijakan Privasi'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // 6. TOMBOL KELUAR (LOGOUT)
            InkWell(
              onTap: _showLogoutDialog,
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2), // Merah transparan kustom
                  border: Border.all(
                    color: const Color(0xFFFEE2E2),
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.logout_rounded,
                      color: AppColors.danger,
                      size: 20,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      'Keluar',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
      // Navbar disediakan oleh shell (MainScreen).
    );
  }

  void _showPlaceholderSnackBar(String featureName) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka $featureName (Placeholder)'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Widget Kustom Seksi Pengaturan (Seksi Berisi Settings Tiles)
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> tiles;

  const _SettingsSection({
    required this.title,
    required this.tiles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.sm,
            bottom: AppSpacing.sm,
            top: AppSpacing.lg,
          ),
          child: Text(
            title,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.5),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tiles.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => tiles[index],
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget Kustom Baris Pilihan Menu Pengaturan
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        child: Row(
          children: [
            // Kontainer Ikon Kiri (Warna Latar Primary Transparan)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Judul Menu
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // Widget Trailing (default Chevron Kanan)
            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }
}
