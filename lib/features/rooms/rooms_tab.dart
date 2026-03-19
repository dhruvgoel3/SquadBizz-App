import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../../core/services/supabase_service.dart';
import 'rooms_controller.dart';
import 'widgets/room_card.dart';
import 'widgets/empty_rooms_state.dart';

/// Rooms (Home) tab content.
class RoomsTab extends GetView<RoomsController> {
  const RoomsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the user's display name from profile metadata
    final userName = SupabaseService.currentUser?.userMetadata?['full_name']
            as String? ??
        'there';

    return RefreshIndicator(
      onRefresh: controller.refreshRooms,
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          // ── Custom App Bar ──
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Text(AppStrings.appName,
                style: AppTextStyles.heading2.copyWith(color: AppColors.primary)),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textPrimary),
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // ── Greeting ──
                  Text(
                    'Hey $userName 👋',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 20),

                  // ── Quick action chips ──
                  Row(
                    children: [
                      _actionChip(
                        icon: Icons.add_rounded,
                        label: AppStrings.createRoom,
                        onTap: () {},
                      ),
                      const SizedBox(width: 12),
                      _actionChip(
                        icon: Icons.login_rounded,
                        label: AppStrings.joinRoom,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── Section title ──
                  Text(AppStrings.yourRooms, style: AppTextStyles.heading3),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Rooms list ──
          Obx(() {
            if (controller.isLoading.value) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ShimmerLoading.list(count: 3),
                ),
              );
            }

            if (controller.rooms.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyRoomsState(),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final room = controller.rooms[index];
                    return RoomCard(
                      name: room['name'] ?? 'Room',
                      memberCount: room['member_count'] ?? 0,
                      activePollsCount: room['active_polls'] ?? 0,
                      pendingAmount:
                          (room['pending_amount'] ?? 0).toDouble(),
                    );
                  },
                  childCount: controller.rooms.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _actionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 6),
            Text(label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}
