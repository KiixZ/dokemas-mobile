import 'package:flutter/material.dart';
import '../../../models/destination.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import 'tambah_destinasi_page.dart';

/// Body kelola destinasi: search + filter kategori + daftar kartu.
/// UI only. Dibungkus AppBar + navbar oleh [AdminShell]. FAB ada di shell.
class AdminDestinasiPage extends StatefulWidget {
  const AdminDestinasiPage({super.key});

  @override
  State<AdminDestinasiPage> createState() => _AdminDestinasiPageState();
}

class _AdminDestinasiPageState extends State<AdminDestinasiPage> {
  String _query = '';
  String _filter = 'All'; // 'All' atau salah satu kategori

  static const _filters = ['All', ...destinationCategories];

  List<Destination> get _visible {
    return dummyDestinations.where((d) {
      final okFilter = _filter == 'All' || d.category == _filter;
      final okQuery = _query.isEmpty ||
          d.name.toLowerCase().contains(_query.toLowerCase()) ||
          d.area.toLowerCase().contains(_query.toLowerCase());
      return okFilter && okQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Search destinations...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
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

        // Filter chip kategori
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: _filters.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, i) {
              final f = _filters[i];
              final selected = f == _filter;
              return ChoiceChip(
                label: Text(f),
                selected: selected,
                onSelected: (_) => setState(() => _filter = f),
                showCheckmark: false,
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
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Daftar kartu
        Expanded(
          child: items.isEmpty
              ? const Center(
                  child: Text('Tidak ada destinasi',
                      style: AppTextStyles.caption),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0,
                      AppSpacing.md, AppSpacing.xl),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, i) => _DestinationCard(
                    dest: items[i],
                    onEdit: () => _openEdit(items[i]),
                    onDelete: () => _confirmDelete(context, items[i]),
                  ),
                ),
        ),
      ],
    );
  }

  void _openEdit(Destination dest) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TambahDestinasiPage(existing: dest)),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Destination d) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus destinasi?'),
        content: Text('Yakin hapus "${d.name}"? Aksi ini tidak bisa dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (yes == true && context.mounted) {
      // UI only: belum hapus dari sumber data.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hapus "${d.name}" (dummy)')),
      );
    }
  }
}

/// Kartu satu destinasi: banner + status + info + aksi edit/hapus.
class _DestinationCard extends StatelessWidget {
  final Destination dest;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DestinationCard({
    required this.dest,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner + badge status
          Stack(
            children: [
              Container(
                height: 140,
                width: double.infinity,
                color: AppColors.background,
                child: const Icon(Icons.image_outlined,
                    size: 40, color: AppColors.textMuted),
              ),
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: _StatusBadge(active: dest.active),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lokasi • kategori
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${dest.area}  •  ${dest.category}',
                        style: AppTextStyles.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(dest.name, style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.sm),

                // Rating kiri, harga kanan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text(
                          dest.rating.toString(),
                          style: AppTextStyles.title,
                        ),
                        const SizedBox(width: 4),
                        Text('(${dest.reviews})',
                            style: AppTextStyles.caption),
                      ],
                    ),
                    Text(
                      formatRupiah(dest.price),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Divider(height: AppSpacing.lg),

                // Aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.primary),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.danger),
                      tooltip: 'Hapus',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;
  const _StatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: const TextStyle(
          color: AppColors.onPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
