import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/supabase_service.dart';

/// Bottom sheet showing minimal user profile and a Logout button.
///
/// Show via: `Get.bottomSheet(const ProfileSheet())`
class ProfileSheet extends StatelessWidget {
  const ProfileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SupabaseService.currentUser;
    final fullName =
        user?.userMetadata?['full_name'] as String? ?? 'User';
    final email = user?.email ?? user?.phone ?? '';
    final initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initial,
                style: AppTextStyles.heading2.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(fullName, style: AppTextStyles.heading3),
          const SizedBox(height: 4),
          Text(email, style: AppTextStyles.subtitle),
          const SizedBox(height: 28),

          // Logout button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirmed = await Get.dialog<bool>(
                  AlertDialog(
                    title: Text(AppStrings.logout,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    content: const Text(AppStrings.logoutConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: const Text(AppStrings.cancel),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: Text(
                          AppStrings.confirm,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await SupabaseService.auth.signOut();
                  Get.deleteAll();
                  Get.offAllNamed(AppRoutes.login);
                }
              },
              icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              label: Text(
                AppStrings.logout,
                style: AppTextStyles.body.copyWith(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(
                    color: AppColors.error.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
