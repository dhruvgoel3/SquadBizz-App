import 'package:flutter/material.dart';

/// SquadBizz brand color palette — supports both light and dark themes.
class AppColors {
  AppColors._();

  // ── Brand Primary ──
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42DB);

  // ── Light Theme Colors ──
  static const Color backgroundLight = Color(0xFFF8F9FD);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF1E1E2C);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textHintLight = Color(0xFF9CA3AF);
  static const Color inputFillLight = Color(0xFFF3F4F6);
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFD1D5DB);

  // ── Dark Theme Colors ──
  static const Color backgroundDark = Color(0xFF0F0F1A);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color surfaceVariantDark = Color(0xFF252540);
  static const Color textPrimaryDark = Color(0xFFF0F0F5);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textHintDark = Color(0xFF6B7280);
  static const Color inputFillDark = Color(0xFF252540);
  static const Color dividerDark = Color(0xFF2E2E48);
  static const Color borderDark = Color(0xFF3A3A5C);

  // ── Text On Primary ──
  static const Color textOnPrimary = Colors.white;

  // ── Accent / Status ──
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ── Grey Shades ──
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);

  // ── Card gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF252540)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Extension on BuildContext for quick color access based on current theme.
extension AppColorsExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get background =>
      isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  Color get surface => isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get textPrimary =>
      isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  Color get textSecondary =>
      isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  Color get textHint =>
      isDark ? AppColors.textHintDark : AppColors.textHintLight;
  Color get inputFill =>
      isDark ? AppColors.inputFillDark : AppColors.inputFillLight;
  Color get dividerColor =>
      isDark ? AppColors.dividerDark : AppColors.dividerLight;
  Color get borderColor =>
      isDark ? AppColors.borderDark : AppColors.borderLight;
}
