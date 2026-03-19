import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';

/// Empty state shown when user has no rooms.
class EmptyHomeState extends StatelessWidget {
  final VoidCallback onCreateRoom;

  const EmptyHomeState({super.key, required this.onCreateRoom});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon ──
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.groups_rounded,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'No rooms yet',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a room and invite your squad',
              style: AppTextStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            CustomButton(
              label: 'Create Your First Room',
              onTap: onCreateRoom,
            ),
          ],
        ),
      ),
    );
  }
}
