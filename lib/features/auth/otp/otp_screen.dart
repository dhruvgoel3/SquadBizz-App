import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import 'otp_controller.dart';

/// OTP verification screen — 6 digit input with resend timer.
class OtpScreen extends GetView<OtpController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // ── Lock icon ──
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phonelink_lock_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 28),

              // ── Title ──
              Text(
                AppStrings.otpVerification,
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 12),

              // ── Subtitle with phone number ──
              Text(
                '${AppStrings.otpSubtitle}\n${controller.phoneNumber}',
                style: AppTextStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // ── 6-digit OTP input boxes ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    height: 56,
                    child: TextField(
                      controller: controller.otpControllers[index],
                      focusNode: controller.focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTextStyles.heading3.copyWith(fontSize: 22),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.inputFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 2),
                        ),
                      ),
                      onChanged: (value) =>
                          controller.onOtpDigitChanged(value, index),
                    ),
                  );
                }),
              ),

              // ── Error text ──
              Obx(() {
                if (controller.otpError.value != null) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      controller.otpError.value!,
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.error),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 36),

              // ── Verify button ──
              Obx(() => CustomButton(
                    label: AppStrings.verifyOtp,
                    isLoading: controller.isLoading.value,
                    onTap: controller.verifyOtp,
                  )),
              const SizedBox(height: 28),

              // ── Resend OTP ──
              Obx(() {
                final countdown = controller.resendCountdown.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.didntReceiveCode,
                      style: AppTextStyles.body,
                    ),
                    GestureDetector(
                      onTap:
                          countdown == 0 ? controller.resendOtp : null,
                      child: Text(
                        countdown > 0
                            ? '${AppStrings.resendIn} ${countdown}s'
                            : AppStrings.resendOtp,
                        style: AppTextStyles.link.copyWith(
                          color: countdown > 0
                              ? AppColors.grey400
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
