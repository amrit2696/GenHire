import 'package:flutter/material.dart';

abstract final class AppColor {
  AppColor._();

  // ============================================================
  // Brand Colors
  // ============================================================

  static const Color primary = Color(0xFF452DCE);

  static const Color primaryLight = Color(0xFFEEF2FF);

  static const Color primaryDark = Color(0xFF31209B);

  static const Color secondary = Color(0xFF475569);

  static const Color accent = Color(0xFF38BDF8);

  // ============================================================
  // Background
  // ============================================================

  static const Color background = Color(0xFFFFFBFB);

  static const Color scaffold = Color(0xFFF8F9FA);

  static const Color surface = Colors.white;

  // ============================================================
  // Text
  // ============================================================

  static const Color textPrimary = Color(0xFF2D3748);

  static const Color textSecondary = Color(0xFF718096);

  static const Color hint = Color(0xFFA0AEC0);

  // ============================================================
  // Border
  // ============================================================

  static const Color border = Color(0xFFF0DADA);

  static const Color divider = Color(0xFFF5E5E5);

  // ============================================================
  // Status
  // ============================================================

  static const Color success = Color(0xFF2E7D32);

  static const Color warning = Color(0xFFFF9800);

  static const Color error = Color(0xFFD32F2F);

  static const Color info = Color(0xFF0288D1);

  // ============================================================
  // Basic
  // ============================================================

  static const Color white = Colors.white;

  static const Color black = Colors.black;

  // ============================================================
  // Button Colors
  // ============================================================

  static const Color buttonPrimary = primary;

  static const Color buttonText = Colors.white;

  static const Color disabled = Color(0xFFD6D6D6);

  // ============================================================
  // Card
  // ============================================================

  static const Color card = Colors.white;

  static const Color cardShadow = Color(0x18000000);
}
