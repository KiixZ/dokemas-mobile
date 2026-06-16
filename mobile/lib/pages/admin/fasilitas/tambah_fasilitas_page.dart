import 'package:flutter/material.dart';
import '../../../models/facility.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';

/// Form tambah/edit fasilitas (UI only, belum simpan ke backend).
/// Kirim [existing] buat mode edit (field ter-isi).
class TambahFasilitasPage extends StatefulWidget {
  final Facility? existing;
  const TambahFasilitasPage({super.key, this.existing});

  @override
  State<TambahFasilitasPage> createState() => _TambahFasilitasPageState();
}

class _TambahFasilitasPageState extends State<TambahFasilitasPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nama =
      TextEditingController(text: widget.existing?.name ?? '');
  late IconData _icon = widget.existing?.icon ?? facilityIconOptions.first;
  late bool _active = widget.existing?.active ?? true;

  bool get _isEdit => widget.existing != null;

  @override
  void dispose() {
    _nama.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEdit
            ? 'Fasilitas "${_nama.text}" diperbarui (dummy)'
            : 'Fasilitas "${_nama.text}" ditambah (dummy)'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? 'Edit Fasilitas' : 'Tambah Fasilitas',
          style: const TextStyle(
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
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                ),
                child: Icon(_icon, size: 36, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            _Label('Nama Fasilitas'),
            TextFormField(
              controller: _nama,
              decoration: _dec('mis. Toilet, Parkir, Mushola'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            _Label('Icon'),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radius),
                border: Border.all(color: AppColors.border),
              ),
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: facilityIconOptions.map((ic) {
                  final selected = ic == _icon;
                  return InkWell(
                    onTap: () => setState(() => _icon = ic),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary
                            : AppColors.background,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                        border: Border.all(
                          color:
                              selected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Icon(
                        ic,
                        color: selected
                            ? AppColors.onPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

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
                  _active ? 'Bisa dipilih di destinasi' : 'Disembunyikan',
                  style: AppTextStyles.caption,
                ),
                value: _active,
                onChanged: (v) => setState(() => _active = v),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan Fasilitas'),
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
