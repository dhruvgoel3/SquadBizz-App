import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../forgot_password/forgot_password_sheet.dart';
import 'login_controller.dart';

/// Login screen — email/password + OR + phone OTP, with forgot password link.
class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

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
              const SizedBox(height: 24),

              // ── Logo / App Name ──
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.groups_rounded,
                        size: 38,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(AppStrings.appName,
                        style: AppTextStyles.heading2
                            .copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Header ──
              Text(AppStrings.login, style: AppTextStyles.heading1),
              const SizedBox(height: 4),
              Text(AppStrings.loginSubtitle, style: AppTextStyles.subtitle),
              const SizedBox(height: 28),

              // ═══════════════════════════════════
              //  SECTION A: Email & Password Login
              // ═══════════════════════════════════
              _sectionLabel(AppStrings.loginWithEmail, Icons.email_rounded),
              const SizedBox(height: 16),

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

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: showForgotPasswordSheet,
                  child: Text(
                    AppStrings.forgotPassword,
                    style: AppTextStyles.link.copyWith(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login button
              Obx(() => CustomButton(
                    label: AppStrings.login,
                    isLoading: controller.isEmailLoading.value,
                    onTap: controller.loginWithEmail,
                  )),
              const SizedBox(height: 28),

              // ═══════════════════════════════════
              //  OR Divider
              // ═══════════════════════════════════
              _orDivider(),
              const SizedBox(height: 28),

              // ═══════════════════════════════════
              //  SECTION B: Phone OTP Login
              // ═══════════════════════════════════
              _sectionLabel(
                  AppStrings.loginWithPhone, Icons.phone_android_rounded),
              const SizedBox(height: 16),

              // Phone Number
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
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.error),
                          ),
                        ),
                    ],
                  )),
              const SizedBox(height: 16),

              // Send OTP button
              Obx(() => CustomButton(
                    label: AppStrings.sendOtp,
                    isLoading: controller.isPhoneLoading.value,
                    onTap: controller.sendLoginOtp,
                  )),
              const SizedBox(height: 32),

              // ═══════════════════════════════════
              //  Don't have an account? Register
              // ═══════════════════════════════════
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppStrings.dontHaveAccount,
                        style: AppTextStyles.body),
                    GestureDetector(
                      onTap: () => Get.offNamed(AppRoutes.register),
                      child:
                          Text(AppStrings.register, style: AppTextStyles.link),
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
  Widget _sectionLabel(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
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
