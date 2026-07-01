import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import 'reset_password_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final error = await authProvider.verifyOtp(widget.email, _otpController.text.trim());

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (error == null) {
        // Berhasil, pindah ke halaman Reset Password
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(email: widget.email, otp: _otpController.text.trim()),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _handleResendOtp() async {
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final error = await authProvider.forgotPassword(widget.email);
    setState(() => _isLoading = false);
    
    if (!mounted) return;
    
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP telah dikirim ulang ke email Anda.'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.danger,
        ),
      );
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
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                          onPressed: () => Navigator.pop(context),
                        ),
                        
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.pin_outlined,
                              color: AppColors.primary,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        Center(
                          child: Text(
                            'Verifikasi OTP',
                            style: AppTextStyles.heading1.copyWith(color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                            child: Text(
                              'Masukkan 6 digit kode OTP yang telah dikirim ke ${widget.email}',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.caption.copyWith(fontSize: 13),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        Text(
                          'Kode OTP',
                          style: AppTextStyles.title.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading1.copyWith(letterSpacing: 8),
                          decoration: const InputDecoration(
                            hintText: '000000',
                            counterText: '',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'OTP tidak boleh kosong';
                            }
                            if (value.length != 6) {
                              return 'OTP harus 6 digit';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleVerifyOtp,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                            ),
                            child: _isLoading 
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Verifikasi',
                                        style: AppTextStyles.button.copyWith(fontSize: 15),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        Center(
                          child: GestureDetector(
                            onTap: _isLoading ? null : _handleResendOtp,
                            child: Text(
                              'Kirim Ulang OTP',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
