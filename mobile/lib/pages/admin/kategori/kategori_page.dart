import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import 'tambah_kategori_page.dart';

/// Halaman penuh kelola kategori (dibuka dari hub Kelola).
/// UI only.
class AdminKategoriPage extends StatefulWidget {
  const AdminKategoriPage({super.key});

  @override
  State<AdminKategoriPage> createState() => _AdminKategoriPageState();
}

class _AdminKategoriPageState extends State<AdminKategoriPage> {
  // Salin ke list mutable biar toggle bisa ubah state.
  late final List<Category> _items = List.of(dummyCategories);

  void _openTambah() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TambahKategoriPage()),
    );
  }

  void _openEdit(Category cat) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TambahKategoriPage(existing: cat)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Kategori',
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
        child: const Icon(Icons.add, color: AppColors.onPrimary),
      ),
      body: ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const Text('Category Management', style: AppTextStyles.heading1),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Organize and manage destination classifications.',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppSpacing.lg),
        for (int i = 0; i < _items.length; i++) ...[
          _CategoryCard(
            cat: _items[i],
            onToggle: (v) =>
                setState(() => _items[i] = _items[i].copyWith(active: v)),
            onEdit: () => _openEdit(_items[i]),
            onDelete: () => _confirmDelete(_items[i]),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
      ),
    );
  }

  Future<void> _confirmDelete(Category c) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus kategori?'),
        content: Text('Yakin hapus "${c.name}"?'),
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
    if (yes == true) {
      setState(() => _items.remove(c));
    }
  }
}

/// Kartu satu kategori: icon + toggle + nama + jumlah + aksi.
class _CategoryCard extends StatelessWidget {
  final Category cat;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.cat,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final muted = !cat.active;
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
          // Icon + toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: muted
                      ? AppColors.background
                      : AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  cat.icon,
                  color: muted ? AppColors.textMuted : AppColors.primary,
                ),
              ),
              Switch(
                value: cat.active,
                onChanged: onToggle,
                activeThumbColor: AppColors.onPrimary,
                activeTrackColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(cat.name, style: AppTextStyles.heading2),
          const SizedBox(height: 2),
          Text(
            muted
                ? '${cat.count} Destinations (Inactive)'
                : '${cat.count} Destinations',
            style: AppTextStyles.caption,
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
