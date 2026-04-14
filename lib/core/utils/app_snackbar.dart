import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

/// Centralized snackbar/flushbar helper for consistent, pretty notifications.
///
/// Usage:
/// ```dart
/// AppSnackbar.success(context, message: 'Room created!');
/// AppSnackbar.error(context, message: 'Something went wrong.');
/// AppSnackbar.info(context, message: 'OTP sent.');
/// ```
class AppSnackbar {
  AppSnackbar._();

  /// ✅ Success flushbar — green accent.
  static void success(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
  }) {
    _show(
      context,
      message: message,
      title: title ?? 'Success',
      icon: Icons.check_circle_rounded,
      backgroundColor: AppColors.success,
      duration: duration,
    );
  }

  /// ❌ Error flushbar — red accent.
  static void error(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
  }) {
    _show(
      context,
      message: message,
      title: title ?? 'Error',
      icon: Icons.error_rounded,
      backgroundColor: AppColors.error,
      duration: duration,
    );
  }

  /// ℹ️ Info flushbar — blue accent.
  static void info(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
  }) {
    _show(
      context,
      message: message,
      title: title ?? 'Info',
      icon: Icons.info_rounded,
      backgroundColor: AppColors.info,
      duration: duration,
    );
  }

  /// ⚠️ Warning flushbar — amber accent.
  static void warning(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
  }) {
    _show(
      context,
      message: message,
      title: title ?? 'Warning',
      icon: Icons.warning_rounded,
      backgroundColor: AppColors.warning,
      duration: duration,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required String title,
    required IconData icon,
    required Color backgroundColor,
    Duration? duration,
  }) {
    Flushbar(
      title: title,
      message: message,
      duration: duration ?? AppConstants.snackDuration,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.screenPaddingH,
        vertical: AppConstants.spacingSm,
      ),
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      backgroundColor: backgroundColor,
      icon: Icon(icon, color: Colors.white, size: AppConstants.iconSizeMedium),
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: AppConstants.animNormal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
      boxShadows: [
        BoxShadow(
          color: backgroundColor.withValues(alpha: 0.3),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 13,
        ),
      ),
    ).show(context);
  }
}
