import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GuestLoginRequiredPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int selectedIndex;

  const GuestLoginRequiredPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.selectedIndex,
  });

  // Halaman login/register belum ada di branch ini.
  // Sementara kasih feedback; ganti ke Navigator pas page-nya siap.
  void _comingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Halaman $label belum tersedia')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Icon(
                          icon,
                          size: 43,
                          color: AppColors.primary,
                        ),
                        Positioned(
                          top: 5,
                          right: 4,
                          child: Container(
                            width: 19,
                            height: 19,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.star,
                              color: AppColors.onPrimary,
                              size: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.55,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () => _comingSoon(context, 'Login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          elevation: 5,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 17),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum punya akun? ',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _comingSoon(context, 'Daftar'),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ],
                  ),
                ),
              ),
            ),
            _GuestBottomNav(selectedIndex: selectedIndex),
          ],
        ),
      ),
    );
  }
}

class _GuestBottomNav extends StatelessWidget {
  final int selectedIndex;

  const _GuestBottomNav({
    required this.selectedIndex,
  });

  void _navigate(BuildContext context, int index) {
    if (index == selectedIndex) return;

    if (index == 2) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/guest-wishlist',
        (route) => false,
      );
    } else if (index == 3) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/guest-itinerary',
        (route) => false,
      );
    } else if (index == 4) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/guest-profile',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final menus = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.search, 'label': 'Search'},
      {'icon': Icons.favorite_border, 'label': 'Wishlist'},
      {'icon': Icons.calendar_month_outlined, 'label': 'Itinerary'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];

    return Container(
      height: 61,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(menus.length, (index) {
          final isActive = index == selectedIndex;

          return GestureDetector(
            onTap: () => _navigate(context, index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  menus[index]['icon'] as IconData,
                  size: 20,
                  color: isActive ? AppColors.primary : AppColors.textMuted,
                ),
                const SizedBox(height: 3),
                Text(
                  menus[index]['label'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                    color: isActive ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}