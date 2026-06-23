import 'package:flutter/material.dart';
import '../../../models/facility.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../config/api_config.dart';
import 'tambah_fasilitas_page.dart';

/// Halaman penuh kelola fasilitas (dibuka dari hub Kelola).
/// UI only.
class AdminFasilitasPage extends StatefulWidget {
  const AdminFasilitasPage({super.key});

  @override
  State<AdminFasilitasPage> createState() => _AdminFasilitasPageState();
}

class _AdminFasilitasPageState extends State<AdminFasilitasPage> {
  List<Facility> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFacilities();
  }

  Future<void> _fetchFacilities() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(ApiConfig.facilities));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _items = data.map((e) => Facility.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openTambah() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TambahFasilitasPage()),
    );
    if (result == true) {
      _fetchFacilities();
    }
  }

  Future<void> _openEdit(Facility fac) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TambahFasilitasPage(existing: fac)),
    );
    if (result == true) {
      _fetchFacilities();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Fasilitas',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('Belum ada fasilitas', style: AppTextStyles.caption))
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    const Text('Facility Management', style: AppTextStyles.heading1),
                    const SizedBox(height: AppSpacing.xs),
                    const Text(
                      'Kelola fasilitas yang tersedia di destinasi.',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    for (int i = 0; i < _items.length; i++) ...[
                      _FacilityCard(
                        fac: _items[i],
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

  Future<void> _confirmDelete(Facility f) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus fasilitas?'),
        content: Text('Yakin hapus "${f.name}"?'),
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
    if (yes == true && f.id != null) {
      if (!mounted) return;
      final token = context.read<AuthProvider>().token;
      try {
        final res = await http.delete(
          Uri.parse('${ApiConfig.adminFacilities}/${f.id}'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
        if (res.statusCode == 200) {
          _fetchFacilities();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fasilitas dihapus')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal menghapus fasilitas')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}

/// Kartu satu fasilitas: icon + toggle + nama + jumlah + aksi.
class _FacilityCard extends StatelessWidget {
  final Facility fac;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FacilityCard({
    required this.fac,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final muted = !fac.active;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
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
              fac.icon,
              color: muted ? AppColors.textMuted : AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fac.name, style: AppTextStyles.title),
                const SizedBox(height: 2),
                Text(
                  muted
                      ? '${fac.count} destinasi (nonaktif)'
                      : '${fac.count} destinasi',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Switch(
            value: fac.active,
            onChanged: onToggle,
            activeThumbColor: AppColors.onPrimary,
            activeTrackColor: AppColors.primary,
          ),
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
    );
  }
}
