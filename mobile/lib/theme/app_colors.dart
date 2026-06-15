import 'package:flutter/material.dart';

/// Palet warna universal DOKEMAS.
/// Pakai lewat `AppColors.xxx` biar konsisten di semua halaman.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF0F766E); // teal hijau utama
  static const Color primaryDark = Color(0xFF115E56);
  static const Color primaryLight = Color(0xFF5EAFA6);
  static const Color accent = Color(0xFFF59E0B); // oranye aksen (logo Amikom)

  // Netral / latar
  static const Color background = Color(0xFFF6F8F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);

  // Teks
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // Warna kartu statistik (dashboard)
  static const Color statBlue = Color(0xFF3B82F6);
  static const Color statGreen = Color(0xFF10B981);
  static const Color statOrange = Color(0xFFF59E0B);
  static const Color statPurple = Color(0xFF8B5CF6);
}