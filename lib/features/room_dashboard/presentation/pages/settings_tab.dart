import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';

/// Settings tab — room info, invite, members, and admin controls.
class SettingsTab extends StatefulWidget {
  final Map<String, dynamic> room;
  const SettingsTab({super.key, required this.room});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final SupabaseClient _client = Supabase.instance.client;
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() => _isLoading = true);
    try {
      final roomId = widget.room['id'] as String;
      final members = await _client
          .from('room_members')
          .select('user_id, role, joined_at')
          .eq('room_id', roomId)
          .order('joined_at');
      setState(() {
        _members = (members as List).cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.e('Failed to load members', error: e);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final roomCode = widget.room['room_code'] as String? ?? '------';
    final roomName = widget.room['name'] as String? ?? 'Room';
    final emoji = widget.room['emoji'] as String? ?? '👥';
    final description = widget.room['description'] as String?;
    final currentUserId = _client.auth.currentUser?.id;

    return ListView(
      padding: const EdgeInsets.all(AppConstants.screenPaddingH),
      children: [
        // Room Info Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 10),
              Text(
                roomName,
                style: AppTextStyles.heading2.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (description != null && description.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 14),
              // Room code
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Code: $roomCode',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: roomCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Room code copied!'), duration: Duration(seconds: 1)),
                        );
                      },
                      child: const Icon(Icons.copy_rounded, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.spacingLg),

        // Share invite
        _buildSettingsItem(
          context: context,
          isDark: isDark,
          icon: Icons.share_rounded,
          iconColor: AppColors.primary,
          title: 'Share Invite',
          subtitle: 'Invite friends with the room code',
          onTap: () {
            Share.share(
              'Join my SquadBizz room "$roomName"! 🎉\n\nUse code: $roomCode\n\nDownload SquadBizz to get started!',
            );
          },
        ),

        const SizedBox(height: 10),

        // Members section
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [
              Text(
                'Members',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_members.length}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_isLoading)
          const Center(child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(color: AppColors.primary),
          ))
        else
          ...(_members.map((m) {
            final role = m['role'] as String? ?? 'member';
            final isCurrentUser = m['user_id'] == currentUserId;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.dividerLight,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isCurrentUser ? 'You' : 'Member',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: role == 'admin'
                          ? AppColors.warning.withValues(alpha: 0.12)
                          : AppColors.grey100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      role == 'admin' ? 'Admin' : 'Member',
                      style: AppTextStyles.caption.copyWith(
                        color: role == 'admin' ? AppColors.warning : AppColors.grey500,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            );
          })),

        const SizedBox(height: AppConstants.spacingLg),

        // Leave Room
        _buildSettingsItem(
          context: context,
          isDark: isDark,
          icon: Icons.logout_rounded,
          iconColor: AppColors.error,
          title: 'Leave Room',
          subtitle: 'You will no longer see this room',
          onTap: () => _showLeaveDialog(context),
          isDestructive: true,
        ),

        const SizedBox(height: AppConstants.spacingXl),
      ],
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: isDestructive
                  ? AppColors.error.withValues(alpha: 0.3)
                  : (isDark ? AppColors.borderDark : AppColors.dividerLight),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? AppColors.error : Theme.of(context).colorScheme.onSurface,
                    )),
                    Text(subtitle, style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 11,
                    )),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.grey400, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showLeaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave Room?'),
        content: const Text('You will no longer have access to this room\'s polls and expenses.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final userId = _client.auth.currentUser!.id;
              try {
                await _client
                    .from('room_members')
                    .delete()
                    .eq('room_id', widget.room['id'])
                    .eq('user_id', userId);
                if (context.mounted) {
                  context.go(AppRoutes.home);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to leave room: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: const Text('Leave', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
