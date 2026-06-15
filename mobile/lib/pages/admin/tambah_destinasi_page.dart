import 'package:flutter/material.dart';
import '../../models/destination.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Form tambah destinasi baru (UI only, belum simpan ke backend).
class TambahDestinasiPage extends StatefulWidget {
  const TambahDestinasiPage({super.key});

  @override
  State<TambahDestinasiPage> createState() => _TambahDestinasiPageState();
}

class _TambahDestinasiPageState extends State<TambahDestinasiPage> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _area = TextEditingController();
  final _harga = TextEditingController();
  final _deskripsi = TextEditingController();
  final _lat = TextEditingController();
  final _lng = TextEditingController();

  String? _kategori;
  bool _active = true;
  TimeOfDay _openHour = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _closeHour = const TimeOfDay(hour: 17, minute: 0);
  final Set<String> _facilities = {};

  @override
  void dispose() {
    _nama.dispose();
    _area.dispose();
    _harga.dispose();
    _deskripsi.dispose();
    _lat.dispose();
    _lng.dispose();
    super.dispose();
  }

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String? _validCoord(String? v) {
    if (v == null || v.trim().isEmpty) return 'Wajib diisi';
    if (double.tryParse(v.trim()) == null) return 'Harus angka';
    return null;
  }

  Future<void> _pickTime({required bool open}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: open ? _openHour : _closeHour,
    );
    if (picked != null) {
      setState(() => open ? _openHour = picked : _closeHour = picked);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    // UI only: balik ke list, kasih notif sukses.
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Destinasi "${_nama.text}" ditambah (dummy)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Destinasi',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Upload gambar (placeholder)
            _ImagePicker(),
            const SizedBox(height: AppSpacing.lg),

            _Label('Nama Destinasi'),
            TextFormField(
              controller: _nama,
              decoration: _dec('mis. Curug Bayan Baturraden'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            _Label('Kategori'),
            DropdownButtonFormField<String>(
              initialValue: _kategori,
              decoration: _dec('Pilih kategori'),
              items: destinationCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v),
              validator: (v) => v == null ? 'Pilih kategori' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            _Label('Lokasi'),
            TextFormField(
              controller: _area,
              decoration: _dec('mis. Baturraden, Banyumas'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Lokasi wajib diisi' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            _Label('Harga Tiket (Rp)'),
            TextFormField(
              controller: _harga,
              keyboardType: TextInputType.number,
              decoration: _dec('mis. 15000'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Harga wajib diisi';
                if (int.tryParse(v.trim()) == null) return 'Harga harus angka';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Jam operasional (buka - tutup)
            _Label('Jam Operasional'),
            Row(
              children: [
                Expanded(
                  child: _TimeField(
                    label: 'Buka',
                    value: _fmtTime(_openHour),
                    onTap: () => _pickTime(open: true),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _TimeField(
                    label: 'Tutup',
                    value: _fmtTime(_closeHour),
                    onTap: () => _pickTime(open: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Koordinat lokasi
            _Label('Koordinat'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _lat,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    decoration: _dec('Latitude (-7.31)'),
                    validator: _validCoord,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _lng,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    decoration: _dec('Longitude (109.22)'),
                    validator: _validCoord,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Fasilitas (multi-select)
            _Label('Fasilitas'),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: facilityOptions.map((f) {
                final selected = _facilities.contains(f);
                return FilterChip(
                  label: Text(f),
                  selected: selected,
                  showCheckmark: false,
                  onSelected: (on) => setState(
                      () => on ? _facilities.add(f) : _facilities.remove(f)),
                  labelStyle: TextStyle(
                    color: selected
                        ? AppColors.onPrimary
                        : AppColors.textSecondary,
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

            _Label('Deskripsi'),
            TextFormField(
              controller: _deskripsi,
              maxLines: 4,
              decoration: _dec('Ceritakan tentang destinasi ini...'),
            ),
            const SizedBox(height: AppSpacing.md),

            // Status aktif
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radius),
                border: Border.all(color: AppColors.border),
              ),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                title: const Text('Status Aktif', style: AppTextStyles.title),
                subtitle: Text(
                  _active ? 'Tampil ke pengunjung' : 'Disembunyikan',
                  style: AppTextStyles.caption,
                ),
                value: _active,
                onChanged: (v) => setState(() => _active = v),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Tombol simpan
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Simpan Destinasi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  textStyle: AppTextStyles.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
      );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: AppTextStyles.title),
    );
  }
}

/// Field jam: tampil value, tap buka time picker.
class _TimeField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _TimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time,
                size: 18, color: AppColors.textMuted),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                Text(value, style: AppTextStyles.title),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Kotak upload gambar (placeholder, belum konek file picker).
class _ImagePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload gambar (belum dibuat)')),
        );
      },
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          border: Border.all(
            color: AppColors.border,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                size: 40, color: AppColors.textMuted),
            SizedBox(height: AppSpacing.sm),
            Text('Tap untuk unggah gambar',
                style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
