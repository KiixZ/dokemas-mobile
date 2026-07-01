import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../models/destination.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../providers/auth_provider.dart';
import '../../../service/api_service.dart';
import '../../../config/api_config.dart';
import '../../../models/category.dart';
import '../../../models/facility.dart';

/// Form tambah/edit destinasi (UI only, belum simpan ke backend).
/// Kirim [existing] buat mode edit (field ter-isi).
class TambahDestinasiPage extends StatefulWidget {
  final Destination? existing;
  const TambahDestinasiPage({super.key, this.existing});

  @override
  State<TambahDestinasiPage> createState() => _TambahDestinasiPageState();
}

class _TambahDestinasiPageState extends State<TambahDestinasiPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nama = TextEditingController(text: widget.existing?.name ?? '');
  late final _area = TextEditingController(text: widget.existing?.area ?? '');
  late final _harga = TextEditingController(
    text: widget.existing?.price.toString() ?? '',
  );
  final _deskripsi = TextEditingController();
  late final _lat = TextEditingController(
    text: widget.existing?.lat?.toString() ?? '',
  );
  late final _lng = TextEditingController(
    text: widget.existing?.lng?.toString() ?? '',
  );

  int? _categoryId;
  late bool _active = widget.existing?.active ?? true;
  late TimeOfDay _openHour =
      _parseTime(widget.existing?.openHour) ??
      const TimeOfDay(hour: 8, minute: 0);
  late TimeOfDay _closeHour =
      _parseTime(widget.existing?.closeHour) ??
      const TimeOfDay(hour: 17, minute: 0);

  late final Set<int> _selectedFacilities = {
    ...?widget.existing?.facilities.map((f) => f.id!),
  };

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  List<Category> _categories = [];
  List<Facility> _facilitiesOptions = [];
  bool _isLoadingData = true;
  bool _isSaving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _deskripsi.text = widget.existing?.description ?? '';
    _categoryId = widget.existing?.categoryId;
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      _categories = await ApiService().fetchCategories();
      _facilitiesOptions = await ApiService().fetchFacilities();
    } catch (e) {
      debugPrint('Error fetch cat/fac: $e');
    } finally {
      if (mounted) setState(() => _isLoadingData = false);
    }
  }

  /// "08:30" -> TimeOfDay. null kalau gagal.
  TimeOfDay? _parseTime(String? s) {
    if (s == null) return null;
    final parts = s.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

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

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _images.addAll(pickedFiles);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $e')));
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _deleteExistingImage(DestinationImage img) async {
    final token = context.read<AuthProvider>().token;
    try {
      final res = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/admin/destination-images/${img.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        setState(() {
          widget.existing!.images.removeWhere((e) => e.id == img.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Gambar dihapus')));
        }
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final token = context.read<AuthProvider>().token;

    final uri = Uri.parse(
      _isEdit
          ? '${ApiConfig.adminDestinations}/${widget.existing!.id}'
          : ApiConfig.adminDestinations,
    );

    final request = http.MultipartRequest('POST', uri);

    if (_isEdit) {
      request.fields['_method'] = 'PUT';
    }

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields['name'] = _nama.text.trim();
    request.fields['address'] = _area.text.trim();
    if (_categoryId != null)
      request.fields['category_id'] = _categoryId.toString();
    request.fields['price'] = _harga.text.trim();
    request.fields['description'] = _deskripsi.text.trim();
    request.fields['opening_hours'] =
        '${_fmtTime(_openHour)} - ${_fmtTime(_closeHour)}';
    request.fields['latitude'] = _lat.text.trim();
    request.fields['longitude'] = _lng.text.trim();
    request.fields['is_popular'] = _active ? '1' : '0';

    int i = 0;
    for (final facId in _selectedFacilities) {
      request.fields['facility_ids[$i]'] = facId.toString();
      i++;
    }

    if (_images.isNotEmpty) {
      // Image pertama jadi thumbnail jika create. Jika edit, akan mengganti thumbnail lama (dan menambah galeri).
      final thumbnailBytes = await _images[0].readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'thumbnail',
          thumbnailBytes,
          filename: _images[0].name,
        ),
      );
      // Semua gambar yang dipilih akan masuk ke galeri (termasuk gambar pertama).
      for (int j = 0; j < _images.length; j++) {
        final imageBytes = await _images[j].readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'images[$j]',
            imageBytes,
            filename: _images[j].name,
          ),
        );
      }
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (mounted) setState(() => _isSaving = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEdit ? 'Destinasi diperbarui' : 'Destinasi ditambah',
            ),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? 'Edit Destinasi' : 'Tambah Destinasi',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // Upload gambar
                  _Label('Foto Destinasi'),
                  if (_images.isEmpty)
                    InkWell(
                      onTap: _pickImages,
                      borderRadius: BorderRadius.circular(AppSpacing.radius),
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radius,
                          ),
                          border: Border.all(
                            color: AppColors.border,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 40,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              'Tap untuk unggah gambar',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _images.length) {
                            // Tombol tambah lagi
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: InkWell(
                                onTap: _pickImages,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radius,
                                ),
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radius,
                                    ),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: AppColors.textMuted,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return Stack(
                            children: [
                              Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radius,
                                  ),
                                  image: DecorationImage(
                                    image: kIsWeb
                                        ? NetworkImage(_images[index].path)
                                        : FileImage(File(_images[index].path))
                                              as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 12,
                                child: InkWell(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),

                  if (widget.existing != null &&
                      widget.existing!.thumbnailUrl.isNotEmpty) ...[
                    _Label('Thumbnail Saat Ini'),
                    Container(
                      height: 160,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.radius),
                        image: DecorationImage(
                          image: NetworkImage(widget.existing!.thumbnailUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],

                  if (widget.existing != null &&
                      widget.existing!.images.isNotEmpty) ...[
                    _Label('Galeri Saat Ini'),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.existing!.images.length,
                        itemBuilder: (context, index) {
                          final img = widget.existing!.images[index];
                          return Stack(
                            children: [
                              Container(
                                width: 120,
                                margin: const EdgeInsets.only(
                                  right: 8,
                                  bottom: AppSpacing.md,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radius,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(img.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 12,
                                child: InkWell(
                                  onTap: () => _deleteExistingImage(img),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],

                  _Label('Nama Destinasi'),
                  TextFormField(
                    controller: _nama,
                    decoration: _dec('mis. Curug Bayan Baturraden'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nama wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _Label('Kategori'),
                  DropdownButtonFormField<int>(
                    value: _categoryId,
                    decoration: _dec('Pilih kategori'),
                    items: _categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _categoryId = v),
                    validator: (v) => v == null ? 'Pilih kategori' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _Label('Lokasi'),
                  TextFormField(
                    controller: _area,
                    decoration: _dec('mis. Baturraden, Banyumas'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Lokasi wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _Label('Harga Tiket (Rp)'),
                  TextFormField(
                    controller: _harga,
                    keyboardType: TextInputType.number,
                    decoration: _dec('mis. 15000'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Harga wajib diisi';
                      if (int.tryParse(v.trim()) == null)
                        return 'Harga harus angka';
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
                            decimal: true,
                            signed: true,
                          ),
                          decoration: _dec('Latitude (-7.31)'),
                          validator: _validCoord,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextFormField(
                          controller: _lng,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: _dec('Longitude (109.22)'),
                          validator: _validCoord,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _Label('Fasilitas'),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: _facilitiesOptions.map((f) {
                      final selected = _selectedFacilities.contains(f.id);
                      return FilterChip(
                        label: Text(f.name),
                        selected: selected,
                        showCheckmark: false,
                        onSelected: (on) => setState(
                          () => on
                              ? _selectedFacilities.add(f.id!)
                              : _selectedFacilities.remove(f.id!),
                        ),
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
                          color: selected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radius),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: AppColors.primary,
                      title: const Text(
                        'Status Aktif',
                        style: AppTextStyles.title,
                      ),
                      subtitle: Text(
                        _active ? 'Tampil ke pengunjung' : 'Disembunyikan',
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
                      onPressed: _isSaving ? null : _save,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        _isEdit ? 'Simpan Perubahan' : 'Simpan Destinasi',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        textStyle: AppTextStyles.button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radius,
                          ),
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
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 18, color: AppColors.textMuted),
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
