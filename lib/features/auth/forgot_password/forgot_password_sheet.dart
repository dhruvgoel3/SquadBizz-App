import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

/// Controller for the forgot-password bottom sheet.
class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final emailError = RxnString();

  /// Send password reset email via Supabase.
  Future<void> sendResetLink() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = AppStrings.requiredField;
      return;
    }
    if (!GetUtils.isEmail(email)) {
      emailError.value = AppStrings.invalidEmail;
      return;
    }
    emailError.value = null;

    isLoading.value = true;
    try {
      await SupabaseService.auth.resetPasswordForEmail(email);
      Get.back(); // Close the bottom sheet
      Get.snackbar(
        'Email Sent ✉️',
        AppStrings.resetLinkSent,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF22C55E),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        AppStrings.genericError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}

/// Shows the forgot-password bottom sheet.
void showForgotPasswordSheet() {
  final controller = Get.put(ForgotPasswordController());

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle bar ──
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(AppStrings.resetPassword, style: AppTextStyles.heading2),
          const SizedBox(height: 8),
          Text(AppStrings.resetPasswordSubtitle, style: AppTextStyles.subtitle),
          const SizedBox(height: 24),

          Obx(() => CustomTextField(
                label: AppStrings.email,
                hint: AppStrings.emailHint,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: controller.emailError.value,
                prefixIcon: const Icon(Icons.email_outlined,
                    color: AppColors.grey400),
              )),

          Obx(() => CustomButton(
                label: AppStrings.sendResetLink,
                isLoading: controller.isLoading.value,
                onTap: controller.sendResetLink,
              )),
          const SizedBox(height: 16),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
