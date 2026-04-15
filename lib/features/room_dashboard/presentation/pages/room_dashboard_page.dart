import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../polls/presentation/pages/polls_tab.dart';
import '../../../expenses/presentation/pages/expenses_tab.dart';
import 'feed_tab.dart';
import 'settings_tab.dart';

/// Inside a Room Dashboard — holds navigation for room-specific features.
class RoomDashboardPage extends StatefulWidget {
  final Map<String, dynamic> room;

  const RoomDashboardPage({super.key, required this.room});

  @override
  State<RoomDashboardPage> createState() => _RoomDashboardPageState();
}

class _RoomDashboardPageState extends State<RoomDashboardPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final roomId = widget.room['id'] as String? ?? '';
    final roomName = widget.room['name'] as String? ?? 'Room';

    _pages = [
      FeedTab(roomId: roomId, roomName: roomName),
      PollsTab(roomId: roomId),
      ExpensesTab(roomId: roomId),
      SettingsTab(room: widget.room),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = widget.room['name'] as String? ?? 'Room';
    final emoji = widget.room['emoji'] as String? ?? '👥';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              name,
              style: AppTextStyles.heading3.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.dividerLight,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dynamic_feed_outlined),
              selectedIcon: Icon(Icons.dynamic_feed_rounded),
              label: 'Feed',
            ),
            NavigationDestination(
              icon: Icon(Icons.how_to_vote_outlined),
              selectedIcon: Icon(Icons.how_to_vote_rounded),
              label: 'Polls',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: 'Expenses',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
          onDestinationSelected: (idx) {
            setState(() => _currentIndex = idx);
          },
          backgroundColor: isDark ? AppColors.surfaceVariantDark : Colors.white,
          indicatorColor: AppColors.primary.withValues(alpha: 0.15),
          elevation: 0,
        ),
      ),
    );
  }
}
