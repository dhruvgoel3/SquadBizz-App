import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';

/// Bottom sheet shown after room creation — displays room code and share options.
class InviteSheet extends StatelessWidget {
  final String roomCode;
  final VoidCallback onContinue;

  const InviteSheet({
    super.key,
    required this.roomCode,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
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

          // Title
          Text(
            'Your room is ready! 🎉',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            'Share this code with your squad to join.',
            style: AppTextStyles.subtitle.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 24),

          // ── Room Code display ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  roomCode,
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: roomCode));
                    Get.snackbar(
                      'Copied!',
                      'Room code copied to clipboard',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.success,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.copy_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Share Invite Link ──
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Share.share(
                  'Join my room on SquadBizz! Use code: $roomCode\n'
                  'or join here: squadbizz.app/join/$roomCode',
                );
              },
              icon: const Icon(Icons.share_rounded, size: 18),
              label: const Text('Share Invite Link'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Continue to Room ──
          CustomButton(
            label: 'Continue to Room',
            onTap: onContinue,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
