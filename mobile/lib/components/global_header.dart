import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../pages/notification_page.dart';

class GlobalHeader extends StatelessWidget implements PreferredSizeWidget {
  const GlobalHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final userName = user?.name ?? '';
    final avatarUrl = user?.avatarUrl;

    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      titleSpacing: AppSpacing.md,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              avatarUrl ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200&auto=format&fit=crop',
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          RichText(
            text: TextSpan(
              style: AppTextStyles.title,
              children: [
                TextSpan(text: userName.isNotEmpty ? 'Halo, ' : 'Halo! '),
                if (userName.isNotEmpty)
                  TextSpan(
                    text: userName,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (userName.isNotEmpty) const TextSpan(text: ' '),
                const TextSpan(text: '👋'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
          },
          icon: const Icon(
            Icons.notifications_none,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }
}
