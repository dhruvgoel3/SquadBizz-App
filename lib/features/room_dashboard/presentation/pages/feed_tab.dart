import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';

/// Feed tab — shows recent activity in the room (polls, expenses, member events).
class FeedTab extends StatefulWidget {
  final String roomId;
  final String roomName;
  const FeedTab({super.key, required this.roomId, required this.roomName});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  final SupabaseClient _client = Supabase.instance.client;
  List<_FeedItem> _items = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final items = <_FeedItem>[];

      // 1. Recent polls
      try {
        final polls = await _client
            .from('polls')
            .select('id, question, created_at, created_by')
            .eq('room_id', widget.roomId)
            .order('created_at', ascending: false)
            .limit(10);

        for (final poll in (polls as List)) {
          items.add(_FeedItem(
            icon: Icons.how_to_vote_rounded,
            color: AppColors.primary,
            title: 'New Poll Created',
            subtitle: poll['question'] as String? ?? '',
            timestamp: DateTime.tryParse(poll['created_at']?.toString() ?? ''),
          ));
        }
      } catch (e) {
        AppLogger.w('Feed: Could not load polls: $e');
      }

      // 2. Recent expenses
      try {
        final expenses = await _client
            .from('expenses')
            .select('id, title, amount, created_at, created_by')
            .eq('room_id', widget.roomId)
            .order('created_at', ascending: false)
            .limit(10);

        for (final exp in (expenses as List)) {
          final amount = (exp['amount'] as num?)?.toDouble() ?? 0;
          items.add(_FeedItem(
            icon: Icons.receipt_long_rounded,
            color: AppColors.success,
            title: 'Expense Added',
            subtitle: '${exp['title'] ?? ''} — ₹${amount.toStringAsFixed(0)}',
            timestamp: DateTime.tryParse(exp['created_at']?.toString() ?? ''),
          ));
        }
      } catch (e) {
        AppLogger.w('Feed: Could not load expenses: $e');
      }

      // 3. Recent members
      try {
        final members = await _client
            .from('room_members')
            .select('user_id, role, joined_at')
            .eq('room_id', widget.roomId)
            .order('joined_at', ascending: false)
            .limit(5);

        for (final member in (members as List)) {
          final role = member['role'] as String? ?? 'member';
          items.add(_FeedItem(
            icon: role == 'admin' ? Icons.admin_panel_settings_rounded : Icons.person_add_rounded,
            color: AppColors.info,
            title: role == 'admin' ? 'Room Created' : 'Member Joined',
            subtitle: 'A new member joined the room',
            timestamp: DateTime.tryParse(member['joined_at']?.toString() ?? ''),
          ));
        }
      } catch (e) {
        AppLogger.w('Feed: Could not load members: $e');
      }

      // Sort by timestamp (newest first)
      items.sort((a, b) {
        final aTime = a.timestamp ?? DateTime(2000);
        final bTime = b.timestamp ?? DateTime(2000);
        return bTime.compareTo(aTime);
      });

      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load activity feed';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error.withValues(alpha: 0.6)),
            const SizedBox(height: 12),
            Text(_error!, style: AppTextStyles.bodySmall),
            const SizedBox(height: 12),
            TextButton(onPressed: _loadFeed, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
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
              child: const Icon(Icons.dynamic_feed_rounded, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              'No activity yet',
              style: AppTextStyles.heading3.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Create a poll or add an expense to get started!',
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFeed,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppConstants.screenPaddingH),
        itemCount: _items.length,
        separatorBuilder: (context, i) => const SizedBox(height: 2),
        itemBuilder: (context, index) {
          final item = _items[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: AppTextStyles.caption.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (item.timestamp != null)
                  Text(
                    timeago.format(item.timestamp!, locale: 'en_short'),
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeedItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final DateTime? timestamp;

  _FeedItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.timestamp,
  });
}
