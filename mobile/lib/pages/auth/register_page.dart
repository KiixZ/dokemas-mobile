import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../main_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      // Tampilkan Loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final errorMessage = await authProvider.register(name, email, password, confirmPassword);

      if (!mounted) return;
      Navigator.pop(context); // Tutup Loading

      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran sukses!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage), // Tampilkan pesan error asli dari API
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.lg),
                // Card Utama
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo Bulat Minimalis
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.terrain,
                              color: AppColors.primary,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Judul & Sub-judul
                        Center(
                          child: Text(
                            'Daftar Akun',
                            style: AppTextStyles.heading1.copyWith(color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Center(
                          child: Text(
                            'Mulai petualangan Anda di Purwokerto',
                            style: AppTextStyles.caption.copyWith(fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Input Nama Lengkap
                        Text(
                          'Nama Lengkap',
                          style: AppTextStyles.title.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan nama lengkap Anda',
                            prefixIcon: Icon(Icons.person_outline, size: 20, color: AppColors.textSecondary),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama lengkap tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Input Alamat Email
                        Text(
                          'Alamat Email',
                          style: AppTextStyles.title.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'contoh@email.com',
                            prefixIcon: Icon(Icons.email_outlined, size: 20, color: AppColors.textSecondary),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Format email tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Input Kata Sandi
                        Text(
                          'Kata Sandi',
                          style: AppTextStyles.title.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Minimal 8 karakter',
                            prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textSecondary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kata sandi tidak boleh kosong';
                            }
                            if (value.length < 8) {
                              return 'Kata sandi minimal 8 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Input Konfirmasi Kata Sandi
                        Text(
                          'Konfirmasi Kata Sandi',
                          style: AppTextStyles.title.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscurePassword,
                          decoration: const InputDecoration(
                            hintText: 'Ulangi kata sandi Anda',
                            prefixIcon: Icon(Icons.lock_clock, size: 20, color: AppColors.textSecondary),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Konfirmasi kata sandi tidak boleh kosong';
                            }
                            if (value != _passwordController.text) {
                              return 'Kata sandi tidak cocok';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Tombol Daftar Sekarang
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleRegister,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                            ),
                            child: Text(
                              'Daftar Sekarang',
                              style: AppTextStyles.button.copyWith(fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Divider ATAU
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                              child: Text(
                                'ATAU',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Tombol Daftar dengan Google
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Simulasi Registrasi via Google...')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Google Logo G colored letter
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                    children: [
                                      TextSpan(text: 'G', style: TextStyle(color: Color(0xFF4285F4))),
                                      TextSpan(text: 'o', style: TextStyle(color: Color(0xFFEA4335))),
                                      TextSpan(text: 'o', style: TextStyle(color: Color(0xFFFBBC05))),
                                      TextSpan(text: 'g', style: TextStyle(color: Color(0xFF4285F4))),
                                      TextSpan(text: 'l', style: TextStyle(color: Color(0xFF34A853))),
                                      TextSpan(text: 'e', style: TextStyle(color: Color(0xFFEA4335))),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Daftar dengan Google',
                                  style: AppTextStyles.title.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sudah punya akun? ",
                              style: AppTextStyles.caption,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context); // Kembali ke halaman Login
                              },
                              child: Text(
                                'Masuk',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.bold,
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
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
