import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/supabase_service.dart';

/// Controls OTP verification flow for both registration and login.
///
/// Pass `source: 'login'` or `source: 'register'` via Get.arguments
/// to control post-verification navigation.
class OtpController extends GetxController {
  // ── OTP input controllers (6 digits) ──
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  // ── Reactive state ──
  final isLoading = false.obs;
  final otpError = RxnString();
  final resendCountdown = 0.obs;
  Timer? _countdownTimer;

  // ── Data from previous screen ──
  late final String phoneNumber;
  late final String fullName;
  late final String source; // 'login' or 'register'

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    phoneNumber = args?['phone'] ?? '';
    fullName = args?['fullName'] ?? '';
    source = args?['source'] ?? 'register';
    _startResendCountdown();
  }

  /// Combine all 6 OTP fields into a single string.
  String get otpCode => otpControllers.map((c) => c.text).join();

  /// Verify the OTP against Supabase.
  Future<void> verifyOtp() async {
    final code = otpCode;
    if (code.length != 6) {
      otpError.value = 'Please enter all 6 digits';
      return;
    }

    otpError.value = null;
    isLoading.value = true;

    try {
      final response = await SupabaseService.auth.verifyOTP(
        phone: phoneNumber,
        token: code,
        type: OtpType.sms,
      );

      // If verification succeeded and user exists, we get a session
      if (response.session != null) {
        Get.snackbar(
          'Success',
          AppStrings.otpVerified,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF22C55E),
          colorText: Colors.white,
        );

        // Navigate based on source
        Get.offAllNamed(AppRoutes.home);
      } else {}
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('expired')) {
        otpError.value = AppStrings.otpExpired;
      } else {
        otpError.value = AppStrings.invalidOtp;
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Resend OTP to the same phone number.
  Future<void> resendOtp() async {
    if (resendCountdown.value > 0) return;

    try {
      await SupabaseService.auth.signInWithOtp(phone: phoneNumber);
      Get.snackbar(
        'OTP Sent',
        AppStrings.otpSent,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF22C55E),
        colorText: Colors.white,
      );
      _startResendCountdown();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }

  /// 60-second cooldown for resend.
  void _startResendCountdown() {
    resendCountdown.value = 60;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value <= 1) {
        timer.cancel();
        resendCountdown.value = 0;
      } else {
        resendCountdown.value--;
      }
    });
  }

  /// Handle digit input — auto-advance focus.
  void onOtpDigitChanged(String value, int index) {
    otpError.value = null;
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
