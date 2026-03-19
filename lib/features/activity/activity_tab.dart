import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/shimmer_loading.dart';
import 'activity_controller.dart';
import 'widgets/activity_item.dart';

/// Activity tab — chronological feed of recent events.
class ActivityTab extends GetView<ActivityController> {
  const ActivityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.activity, style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshActivity,
        color: AppColors.primary,
        child: Obx(() {
          if (controller.isLoading.value) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ShimmerLoading.list(count: 5, height: 70),
            );
          }

          if (controller.activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.history_rounded,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.noActivityYet,
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.activities.length,
            itemBuilder: (context, index) {
              final item = controller.activities[index];
              return ActivityItem(
                icon: _getIcon(item['type'] ?? ''),
                iconColor: _getColor(item['type'] ?? ''),
                text: item['message'] ?? '',
                roomName: item['room_name'] ?? '',
                timeAgo: item['time_ago'] ?? '',
              );
            },
          );
        }),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'poll':
        return Icons.poll_outlined;
      case 'expense':
        return Icons.receipt_long_outlined;
      case 'chat':
        return Icons.chat_bubble_outline_rounded;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case 'poll':
        return AppColors.primary;
      case 'expense':
        return AppColors.warning;
      case 'chat':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }
}
