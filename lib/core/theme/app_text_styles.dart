import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized text styles for SquadBizz.
/// Uses Google Fonts "Plus Jakarta Sans" matching the Stitch design system.
class AppTextStyles {
  AppTextStyles._();

  // ── Headings ──
  static TextStyle heading1 = GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimaryLight,
    height: 1.3,
  );

  static TextStyle heading2 = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    height: 1.3,
  );

  static TextStyle heading3 = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    height: 1.3,
  );

  // ── Subtitle ──
  static TextStyle subtitle = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryLight,
    height: 1.5,
  );

  // ── Body ──
  static TextStyle body = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimaryLight,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryLight,
    height: 1.5,
  );

  // ── Button ──
  static TextStyle button = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.5,
  );

  // ── Caption ──
  static TextStyle caption = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textHintLight,
  );

  // ── Link ──
  static TextStyle link = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  /// Returns the Plus Jakarta Sans TextTheme for ThemeData integration.
  static TextTheme get textTheme => GoogleFonts.plusJakartaSansTextTheme();
}
