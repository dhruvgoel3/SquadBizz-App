import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/theme/app_colors.dart';

/// Handles email login, phone OTP login, and validation.
class LoginController extends GetxController {
  // ── Text Controllers ──
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ── Reactive State ──
  final isPasswordVisible = false.obs;
  final isEmailLoading = false.obs;
  final isPhoneLoading = false.obs;

  // ── Inline errors ──
  final emailError = RxnString();
  final passwordError = RxnString();
  final phoneError = RxnString();

  // ── Phone data ──
  String _completePhoneNumber = '';

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void onPhoneChanged(String completeNumber) {
    _completePhoneNumber = completeNumber;
    phoneError.value = null;
  }

  // ──────────────────────────────────────────────
  //  EMAIL & PASSWORD LOGIN
  // ──────────────────────────────────────────────

  Future<void> loginWithEmail() async {
    // Validate
    bool valid = true;
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      emailError.value = AppStrings.requiredField;
      valid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = AppStrings.invalidEmail;
      valid = false;
    } else {
      emailError.value = null;
    }

    if (password.isEmpty) {
      passwordError.value = AppStrings.requiredField;
      valid = false;
    } else {
      passwordError.value = null;
    }

    if (!valid) return;

    isEmailLoading.value = true;
    try {
      await SupabaseService.auth.signInWithPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('invalid') || msg.contains('credentials')) {
        Get.snackbar(
          'Login Failed',
          AppStrings.incorrectCredentials,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      } else if (msg.contains('not found') || msg.contains('no user')) {
        Get.snackbar(
          'Login Failed',
          AppStrings.userNotFound,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      } else if (msg.contains('network') || msg.contains('socket')) {
        Get.snackbar(
          'Error',
          AppStrings.networkError,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Login Failed',
          AppStrings.genericError,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      }
    } finally {
      isEmailLoading.value = false;
    }
  }

  // ──────────────────────────────────────────────
  //  PHONE OTP LOGIN
  // ──────────────────────────────────────────────

  Future<void> sendLoginOtp() async {
    if (_completePhoneNumber.isEmpty) {
      phoneError.value = AppStrings.invalidPhone;
      return;
    }
    phoneError.value = null;

    isPhoneLoading.value = true;
    try {
      await SupabaseService.auth.signInWithOtp(
        phone: _completePhoneNumber,
      );

      Get.snackbar(
        'OTP Sent',
        AppStrings.otpSent,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF22C55E),
        colorText: Colors.white,
      );

      // Navigate to OTP screen with source = 'login'
      Get.toNamed(
        AppRoutes.otp,
        arguments: {
          'phone': _completePhoneNumber,
          'fullName': '',
          'source': 'login',
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        _friendlyError(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isPhoneLoading.value = false;
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('network') || raw.contains('SocketException')) {
      return AppStrings.networkError;
    }
    if (raw.contains('rate limit') || raw.contains('too many requests')) {
      return 'Too many attempts. Please wait a minute and try again.';
    }
    if (raw.contains('Phone') && raw.contains('not supported')) {
      return 'Phone authentication is not enabled.';
    }
    final cleaned = raw.replaceAll(RegExp(r'^.*?:\s*'), '');
    return cleaned.isNotEmpty ? cleaned : AppStrings.genericError;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
