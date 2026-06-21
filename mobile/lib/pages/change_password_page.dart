import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk menangkap teks input
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State untuk menyembunyikan/menampilkan password (obscureText)
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    // Bersihkan memori controller saat halaman ditutup
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _processChangePassword() {
    // Validasi form sebelum memproses data
    if (_formKey.currentState!.validate()) {
      // Di sini nanti kamu bisa memasukkan logika API atau Firebase backend kamu

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password berhasil diperbarui!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Tutup halaman dan kembali ke profil
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ganti Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey, // Hubungkan form key untuk validasi
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- PASSWORD LAMA ---
                      Text('Password Lama', style: AppTextStyles.title),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _oldPasswordController,
                        obscureText: _obscureOldPassword,
                        style: AppTextStyles.body,
                        decoration: InputDecoration(
                          hintText: 'Masukkan password saat ini',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.textSecondary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureOldPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureOldPassword = !_obscureOldPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password lama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // --- PASSWORD BARU ---
                      Text('Password Baru', style: AppTextStyles.title),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
                        style: AppTextStyles.body,
                        decoration: InputDecoration(
                          hintText: 'Masukkan password baru',
                          prefixIcon: const Icon(
                            Icons.lock_reset_outlined,
                            color: AppColors.textSecondary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNewPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password baru tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal terdiri dari 6 karakter';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // --- KONFIRMASI PASSWORD BARU ---
                      Text(
                        'Konfirmasi Password Baru',
                        style: AppTextStyles.title,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        style: AppTextStyles.body,
                        decoration: InputDecoration(
                          hintText: 'Ulangi password baru',
                          prefixIcon: const Icon(
                            Icons.gpp_good_outlined,
                            color: AppColors.textSecondary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password tidak boleh kosong';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Password konfirmasi tidak cocok';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // --- TOMBOL SIMPAN ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processChangePassword,
                  child: const Text('Perbarui Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
