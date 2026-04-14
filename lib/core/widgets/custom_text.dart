import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable text widget with theme-aware styling and Plus Jakarta Sans font.
///
/// Usage:
/// ```dart
/// const CustomText('Hello World', variant: TextVariant.heading1);
/// const CustomText('Subtitle', variant: TextVariant.subtitle, color: Colors.grey);
/// ```
enum TextVariant {
  heading1,
  heading2,
  heading3,
  subtitle,
  body,
  bodySmall,
  caption,
  button,
  link,
}

class CustomText extends StatelessWidget {
  final String text;
  final TextVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? letterSpacing;
  final TextDecoration? decoration;

  const CustomText(
    this.text, {
    super.key,
    this.variant = TextVariant.body,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = _resolveStyle(context);
    return Text(
      text,
      style: baseStyle.copyWith(
        color: color ?? baseStyle.color,
        fontWeight: fontWeight ?? baseStyle.fontWeight,
        fontSize: fontSize ?? baseStyle.fontSize,
        letterSpacing: letterSpacing,
        decoration: decoration,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _resolveStyle(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final onSurfaceDim = onSurface.withValues(alpha: 0.6);
    final onSurfaceHint = onSurface.withValues(alpha: 0.45);
    final primary = Theme.of(context).colorScheme.primary;

    switch (variant) {
      case TextVariant.heading1:
        return GoogleFonts.plusJakartaSans(
          fontSize: 28, fontWeight: FontWeight.w700, color: onSurface, height: 1.3,
        );
      case TextVariant.heading2:
        return GoogleFonts.plusJakartaSans(
          fontSize: 24, fontWeight: FontWeight.w600, color: onSurface, height: 1.3,
        );
      case TextVariant.heading3:
        return GoogleFonts.plusJakartaSans(
          fontSize: 20, fontWeight: FontWeight.w600, color: onSurface, height: 1.3,
        );
      case TextVariant.subtitle:
        return GoogleFonts.plusJakartaSans(
          fontSize: 16, fontWeight: FontWeight.w400, color: onSurfaceDim, height: 1.5,
        );
      case TextVariant.body:
        return GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w400, color: onSurface, height: 1.5,
        );
      case TextVariant.bodySmall:
        return GoogleFonts.plusJakartaSans(
          fontSize: 12, fontWeight: FontWeight.w400, color: onSurfaceDim, height: 1.5,
        );
      case TextVariant.caption:
        return GoogleFonts.plusJakartaSans(
          fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceHint,
        );
      case TextVariant.button:
        return GoogleFonts.plusJakartaSans(
          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5,
        );
      case TextVariant.link:
        return GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w600, color: primary,
        );
    }
  }
}
