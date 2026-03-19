import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import 'register_controller.dart';

/// Registration screen — email/password + OR + phone OTP.
class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── Header ──
              Text(AppStrings.createAccount, style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                'Join ${AppStrings.appName} and start collaborating with your squad.',
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: 32),

              // ═══════════════════════════════════
              //  SECTION A: Email & Password
              // ═══════════════════════════════════
              _sectionLabel(AppStrings.registerWithEmail),
              const SizedBox(height: 16),

              // Full Name
              Obx(() => CustomTextField(
                    label: AppStrings.fullName,
                    hint: AppStrings.fullNameHint,
                    controller: controller.fullNameController,
                    errorText: controller.fullNameError.value,
                    prefixIcon: const Icon(Icons.person_outline_rounded,
                        color: AppColors.grey400),
                  )),

              // Email
              Obx(() => CustomTextField(
                    label: AppStrings.email,
                    hint: AppStrings.emailHint,
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: controller.emailError.value,
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: AppColors.grey400),
                  )),

              // Password
              Obx(() => CustomTextField(
                    label: AppStrings.password,
                    hint: AppStrings.passwordHint,
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    errorText: controller.passwordError.value,
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: AppColors.grey400),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppColors.grey400,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  )),

              // Confirm Password
              Obx(() => CustomTextField(
                    label: AppStrings.confirmPassword,
                    hint: AppStrings.confirmPasswordHint,
                    controller: controller.confirmPasswordController,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    errorText: controller.confirmPasswordError.value,
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: AppColors.grey400),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppColors.grey400,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  )),

              // Create Account button
              Obx(() => CustomButton(
                    label: AppStrings.createAccount,
                    isLoading: controller.isEmailLoading.value,
                    onTap: controller.registerWithEmail,
                  )),
              const SizedBox(height: 32),

              // ═══════════════════════════════════
              //  OR Divider
              // ═══════════════════════════════════
              _orDivider(),
              const SizedBox(height: 32),

              // ═══════════════════════════════════
              //  SECTION B: Phone Number
              // ═══════════════════════════════════
              _sectionLabel(AppStrings.registerWithPhone),
              const SizedBox(height: 16),

              // Phone Full Name
              Obx(() => CustomTextField(
                    label: AppStrings.fullName,
                    hint: AppStrings.fullNameHint,
                    controller: controller.phoneFullNameController,
                    errorText: controller.phoneFullNameError.value,
                    prefixIcon: const Icon(Icons.person_outline_rounded,
                        color: AppColors.grey400),
                  )),

              // Phone Number with country code picker
              Text(
                AppStrings.phoneNumber,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntlPhoneField(
                        decoration: InputDecoration(
                          hintText: 'Enter phone number',
                          hintStyle: AppTextStyles.caption,
                          filled: true,
                          fillColor: AppColors.inputFill,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          controller.onPhoneChanged(phone.completeNumber);
                        },
                        style: AppTextStyles.body,
                      ),
                      if (controller.phoneError.value != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 4),
                          child: Text(
                            controller.phoneError.value!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                    ],
                  )),
              const SizedBox(height: 16),

              // Send OTP button
              Obx(() => CustomButton(
                    label: AppStrings.sendOtp,
                    isLoading: controller.isPhoneLoading.value,
                    onTap: controller.sendOtp,
                  )),
              const SizedBox(height: 32),

              // ═══════════════════════════════════
              //  Already have an account?
              // ═══════════════════════════════════
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount,
                      style: AppTextStyles.body,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.login),
                      child: Text(
                        AppStrings.login,
                        style: AppTextStyles.link,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper: Section label ──
  Widget _sectionLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            text.contains('Email')
                ? Icons.email_rounded
                : Icons.phone_android_rounded,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper: OR divider ──
  Widget _orDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.grey300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppStrings.orDivider,
            style: AppTextStyles.body.copyWith(
              color: AppColors.grey400,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.grey300)),
      ],
    );
  }
}
