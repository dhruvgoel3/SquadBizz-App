import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/supabase_service.dart';

/// Handles email & phone registration logic.
class RegisterController extends GetxController {
  // ── Form Keys ──
  final emailFormKey = GlobalKey<FormState>();

  // ── Text Controllers ──
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneFullNameController = TextEditingController();

  // ── Reactive State ──
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isEmailLoading = false.obs;
  final isPhoneLoading = false.obs;

  // ── Inline error messages ──
  final fullNameError = RxnString();
  final emailError = RxnString();
  final passwordError = RxnString();
  final confirmPasswordError = RxnString();
  final phoneFullNameError = RxnString();
  final phoneError = RxnString();

  // ── Phone data ──
  String _completePhoneNumber = '';

  /// Toggle password visibility.
  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  /// Store the full international phone number from the phone field.
  void onPhoneChanged(String completeNumber) {
    _completePhoneNumber = completeNumber;
    phoneError.value = null;
  }

  // ──────────────────────────────────────────────
  //  EMAIL REGISTRATION
  // ──────────────────────────────────────────────

  /// Validate all email-form fields. Returns true if valid.
  bool _validateEmailForm() {
    bool valid = true;

    // Full Name
    final name = fullNameController.text.trim();
    if (name.isEmpty) {
      fullNameError.value = AppStrings.requiredField;
      valid = false;
    } else if (name.length < 2) {
      fullNameError.value = AppStrings.nameTooShort;
      valid = false;
    } else {
      fullNameError.value = null;
    }

    // Email
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = AppStrings.requiredField;
      valid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = AppStrings.invalidEmail;
      valid = false;
    } else {
      emailError.value = null;
    }

    // Password
    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = AppStrings.requiredField;
      valid = false;
    } else if (password.length < 8) {
      passwordError.value = AppStrings.passwordTooShort;
      valid = false;
    } else {
      passwordError.value = null;
    }

    // Confirm Password
    final confirm = confirmPasswordController.text;
    if (confirm.isEmpty) {
      confirmPasswordError.value = AppStrings.requiredField;
      valid = false;
    } else if (confirm != password) {
      confirmPasswordError.value = AppStrings.passwordsDoNotMatch;
      valid = false;
    } else {
      confirmPasswordError.value = null;
    }

    return valid;
  }

  /// Register with email & password via Supabase.
  ///
  /// Passes full_name as user metadata so Supabase stores it with the user.
  /// Profile row is created only if a session is immediately available
  /// (i.e. email confirmation is disabled). Otherwise, the profile is
  /// created on first login via the auth state listener in SupabaseService.
  Future<void> registerWithEmail() async {
    if (!_validateEmailForm()) return;

    isEmailLoading.value = true;
    try {
      final response = await SupabaseService.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        data: {
          'full_name': fullNameController.text.trim(),
        },
      );

      if (response.user != null) {
        // Check if we got a session (email confirmation disabled)
        if (response.session != null) {
          Get.snackbar(
            'Success',
            AppStrings.accountCreated,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF22C55E),
            colorText: Colors.white,
          );

          Get.offAllNamed(AppRoutes.home);
        } else {
          // No session yet — email confirmation is required
          // Profile will be created after user confirms email and logs in
          Get.snackbar(
            'Check Your Email 📧',
            'We sent a confirmation link to ${emailController.text.trim()}. '
                'Please verify your email, then come back and log in.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF3B82F6),
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );

          // Go to login screen so they can sign in after confirming
          Get.offNamed(AppRoutes.login);
        }
      }
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('already registered') ||
          msg.contains('already been registered') ||
          msg.contains('already exists')) {
        emailError.value = AppStrings.emailAlreadyInUse;
      } else {
        Get.snackbar(
          'Error',
          _friendlyError(msg),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
        );
      }
    } finally {
      isEmailLoading.value = false;
    }
  }

  // ──────────────────────────────────────────────
  //  PHONE REGISTRATION
  // ──────────────────────────────────────────────

  /// Validate phone-form fields.
  bool _validatePhoneForm() {
    bool valid = true;

    final name = phoneFullNameController.text.trim();
    if (name.isEmpty) {
      phoneFullNameError.value = AppStrings.requiredField;
      valid = false;
    } else if (name.length < 2) {
      phoneFullNameError.value = AppStrings.nameTooShort;
      valid = false;
    } else {
      phoneFullNameError.value = null;
    }

    if (_completePhoneNumber.isEmpty) {
      phoneError.value = AppStrings.invalidPhone;
      valid = false;
    } else {
      phoneError.value = null;
    }

    return valid;
  }

  /// Send OTP to the provided phone number.
  Future<void> sendOtp() async {
    if (!_validatePhoneForm()) return;

    isPhoneLoading.value = true;
    try {
      await SupabaseService.auth.signInWithOtp(
        phone: _completePhoneNumber,
        data: {
          'full_name': phoneFullNameController.text.trim(),
        },
      );

      Get.snackbar(
        'OTP Sent',
        AppStrings.otpSent,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF22C55E),
        colorText: Colors.white,
      );

      // Navigate to OTP screen, passing phone & name
      Get.toNamed(
        AppRoutes.otp,
        arguments: {
          'phone': _completePhoneNumber,
          'fullName': phoneFullNameController.text.trim(),
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        _friendlyError(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } finally {
      isPhoneLoading.value = false;
    }
  }

  /// Convert raw Supabase errors to user-friendly messages.
  String _friendlyError(String raw) {
    if (raw.contains('network') || raw.contains('SocketException')) {
      return AppStrings.networkError;
    }
    if (raw.contains('rate limit') || raw.contains('too many requests')) {
      return 'Too many attempts. Please wait a minute and try again.';
    }
    if (raw.contains('Phone') && raw.contains('not supported')) {
      return 'Phone authentication is not enabled. Please use email registration.';
    }
    // Fallback — show the raw message but trim the class prefix
    final cleaned = raw.replaceAll(RegExp(r'^.*?:\s*'), '');
    return cleaned.isNotEmpty ? cleaned : AppStrings.genericError;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneFullNameController.dispose();
    super.onClose();
  }
}
