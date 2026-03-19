import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/supabase_service.dart';
import '../../core/theme/app_colors.dart';

/// Controller for the Profile tab.
class ProfileController extends GetxController {
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  final notificationsEnabled = true.obs;

  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
    notificationsEnabled.value =
        _storage.read('notifications_enabled') ?? true;
  }

  void _loadProfile() {
    final user = SupabaseService.currentUser;
    if (user != null) {
      userName.value =
          user.userMetadata?['full_name'] as String? ?? 'User';
      userEmail.value = user.email ?? '';
      userPhone.value = user.phone ?? '';
    }
  }

  /// Toggle notification preference.
  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    _storage.write('notifications_enabled', value);
  }

  /// Sign out and navigate to login.
  Future<void> logout() async {
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
      Get.deleteAll(); // Clear all GetX controllers
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
