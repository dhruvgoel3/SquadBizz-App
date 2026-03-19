import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/shimmer_loading.dart';
import 'home_controller.dart';
import 'widgets/room_card.dart';
import 'widgets/empty_home_state.dart';
import 'widgets/profile_sheet.dart';

/// Home screen — shows the user's rooms with create/join actions.
///
/// No bottom navigation bar. This is a simple, WhatsApp-style room list.
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          AppStrings.appName,
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          // ── User avatar → profile sheet ──
          GestureDetector(
            onTap: () => Get.bottomSheet(
              const ProfileSheet(),
              isScrollControlled: true,
            ),
            child: _buildUserAvatar(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshRooms,
        color: AppColors.primary,
        child: Obx(() {
          // Loading state
          if (controller.isLoading.value) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ShimmerLoading.list(count: 4, height: 90),
                ],
              ),
            );
          }

          // Empty state
          if (controller.rooms.isEmpty) {
            return ListView(
              children: [
                const SizedBox(height: 100),
                EmptyHomeState(
                  onCreateRoom: () => Get.toNamed(AppRoutes.createRoom),
                ),
              ],
            );
          }

          // ── Rooms list ──
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 8),

              // Greeting
              Text(
                'Hey ${controller.firstName} 👋',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 4),
              Text(
                "What's your squad up to?",
                style: AppTextStyles.subtitle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 20),

              // ── Action buttons ──
              Row(
                children: [
                  Expanded(
                    child: _primaryActionButton(
                      icon: Icons.add_rounded,
                      label: '+ Create Room',
                      onTap: () => Get.toNamed(AppRoutes.createRoom),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _outlinedActionButton(
                      icon: Icons.login_rounded,
                      label: 'Join Room',
                      onTap: () => Get.toNamed(AppRoutes.joinRoom),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Section title ──
              Row(
                children: [
                  Text('Your Rooms', style: AppTextStyles.heading3),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${controller.rooms.length}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Room cards ──
              ...controller.rooms.map((room) => RoomCard(
                    room: room,
                    onTap: () => Get.toNamed(
                      AppRoutes.roomDashboard,
                      arguments: {'roomId': room.id},
                    ),
                  )),
              const SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }

  /// User initial avatar in app bar.
  Widget _buildUserAvatar() {
    final name = controller.firstName;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: AppTextStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  /// Primary filled action button.
  Widget _primaryActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Outlined action button.
  Widget _outlinedActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
