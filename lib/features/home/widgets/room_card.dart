import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/room_model.dart';

/// Card widget for displaying a room on the home screen.
///
/// Shows emoji, name, description, member count, member avatars,
/// creation date, and an unread activity dot.
class RoomCard extends StatelessWidget {
  final RoomModel room;
  final bool hasUnread;
  final VoidCallback? onTap;

  const RoomCard({
    super.key,
    required this.room,
    this.hasUnread = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Room emoji avatar ──
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  room.emoji,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // ── Room info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + unread dot
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.name,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  // Description
                  if (room.description != null &&
                      room.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      room.description!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),

                  // Member count + creation time
                  Row(
                    children: [
                      Icon(Icons.people_outline_rounded,
                          size: 14, color: AppColors.grey400),
                      const SizedBox(width: 4),
                      Text(
                        '${room.memberCount} members',
                        style: AppTextStyles.caption,
                      ),
                      const Spacer(),
                      Text(
                        'Created ${timeago.format(room.createdAt)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.grey400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Arrow ──
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.grey400, size: 22),
          ],
        ),
      ),
    );
  }
}
