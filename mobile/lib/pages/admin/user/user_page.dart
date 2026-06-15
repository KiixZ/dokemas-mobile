import 'package:flutter/material.dart';
import '../../../models/app_user.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import 'tambah_user_page.dart';

/// Halaman penuh kelola user (dibuka dari hub Kelola). UI only.
class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key});

  @override
  State<AdminUserPage> createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  late final List<AppUser> _items = List.of(dummyUsers);
  String _query = '';

  List<AppUser> get _visible {
    if (_query.isEmpty) return _items;
    final q = _query.toLowerCase();
    return _items
        .where((u) =>
            u.name.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q))
        .toList();
  }

  void _openTambah() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TambahUserPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola User',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openTambah,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add_alt, color: AppColors.onPrimary),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Cari user...',
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textMuted),
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
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('Tidak ada user', style: AppTextStyles.caption),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, i) => _UserCard(
                      user: items[i],
                      onToggle: (v) {
                        final idx = _items.indexOf(items[i]);
                        if (idx != -1) {
                          setState(
                              () => _items[idx] = _items[idx].copyWith(active: v));
                        }
                      },
                      onEdit: () {},
                      onDelete: () => _confirmDelete(items[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(AppUser u) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus user?'),
        content: Text('Yakin hapus "${u.name}"?'),
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
    if (yes == true) setState(() => _items.remove(u));
  }
}

/// Kartu satu user: avatar + nama/email + role badge + toggle + aksi.
class _UserCard extends StatelessWidget {
  final AppUser user;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _UserCard({
    required this.user,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final muted = !user.active;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: muted
                    ? AppColors.textMuted
                    : AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  user.initial,
                  style: TextStyle(
                    color: muted ? AppColors.onPrimary : AppColors.primaryDark,
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
                      children: [
                        Flexible(
                          child: Text(
                            user.name,
                            style: AppTextStyles.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _RoleBadge(role: user.role),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: AppTextStyles.caption,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('Gabung ${user.joined}',
                        style: AppTextStyles.caption),
                  ],
                ),
              ),
              Switch(
                value: user.active,
                onChanged: onToggle,
                activeThumbColor: AppColors.onPrimary,
                activeTrackColor: AppColors.primary,
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                tooltip: 'Edit',
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                tooltip: 'Hapus',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final UserRole role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == UserRole.admin;
    final color = isAdmin ? AppColors.primary : AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Text(
        role.label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
