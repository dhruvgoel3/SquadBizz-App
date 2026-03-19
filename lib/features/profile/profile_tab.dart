import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import 'profile_controller.dart';

/// Profile tab — user info, settings, logout.
class ProfileTab extends GetView<ProfileController> {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.profile, style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ── Avatar ──
            Obx(() => _buildAvatar(controller.userName.value)),
            const SizedBox(height: 14),

            // ── Name ──
            Obx(() => Text(
                  controller.userName.value,
                  style: AppTextStyles.heading3,
                )),
            const SizedBox(height: 4),

            // ── Email / Phone ──
            Obx(() => Text(
                  controller.userEmail.value.isNotEmpty
                      ? controller.userEmail.value
                      : controller.userPhone.value,
                  style: AppTextStyles.subtitle,
                )),
            const SizedBox(height: 24),

            // ── Edit Profile ──
            _settingsTile(
              icon: Icons.edit_outlined,
              title: AppStrings.editProfile,
              onTap: () {}, // To be built in next phase
            ),
            const Divider(height: 1, color: AppColors.grey200),

            // ── Notifications ──
            Obx(() => _settingsTileWithSwitch(
                  icon: Icons.notifications_outlined,
                  title: AppStrings.notifications,
                  value: controller.notificationsEnabled.value,
                  onChanged: controller.toggleNotifications,
                )),
            const Divider(height: 1, color: AppColors.grey200),

            // ── Invite a Friend ──
            _settingsTile(
              icon: Icons.person_add_outlined,
              title: AppStrings.inviteAFriend,
              onTap: () {
                Share.share(
                    'Hey! Check out SquadBizz — the best app for group chat, polls, and expense splitting! 🎉');
              },
            ),
            const Divider(height: 1, color: AppColors.grey200),

            // ── About ──
            _settingsTile(
              icon: Icons.info_outline_rounded,
              title: AppStrings.aboutSquadBizz,
              onTap: () {
                Get.dialog(
                  AboutDialog(
                    applicationName: AppStrings.appName,
                    applicationVersion: '1.0.0',
                    applicationIcon: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.groups_rounded,
                          color: Colors.white, size: 28),
                    ),
                    children: const [
                      Text('SquadBizz is a group utility app for rooms, '
                          'polls, chat, and expense splitting.'),
                    ],
                  ),
                );
              },
            ),
            const Divider(height: 1, color: AppColors.grey200),

            // ── Logout ──
            _settingsTile(
              icon: Icons.logout_rounded,
              title: AppStrings.logout,
              titleColor: AppColors.error,
              iconColor: AppColors.error,
              onTap: controller.logout,
            ),

            const SizedBox(height: 32),

            // ── App Version ──
            Text(
              AppStrings.appVersion,
              style: AppTextStyles.caption.copyWith(color: AppColors.grey400),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Initials-based colored circle avatar.
  Widget _buildAvatar(String name) {
    final initial =
        name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initial,
          style: AppTextStyles.heading1
              .copyWith(color: Colors.white, fontSize: 32),
        ),
      ),
    );
  }

  /// Standard settings row.
  Widget _settingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Icon(icon, color: iconColor ?? AppColors.textPrimary),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      trailing:
          Icon(Icons.chevron_right_rounded, color: iconColor ?? AppColors.grey400),
      onTap: onTap,
    );
  }

  /// Settings row with a switch toggle.
  Widget _settingsTileWithSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title, style: AppTextStyles.body),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primary,
      ),
    );
  }
}
