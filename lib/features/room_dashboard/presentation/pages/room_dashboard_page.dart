import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

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
    _pages = [
      const _PlaceholderRoomTab(title: 'Feed', icon: Icons.dynamic_feed_rounded),
      const _PlaceholderRoomTab(title: 'Polls', icon: Icons.how_to_vote_rounded),
      const _PlaceholderRoomTab(title: 'Expenses', icon: Icons.attach_money_rounded),
      const _PlaceholderRoomTab(title: 'Settings', icon: Icons.settings_rounded),
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
              icon: Icon(Icons.money_off_csred_outlined),
              selectedIcon: Icon(Icons.attach_money_rounded),
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

class _PlaceholderRoomTab extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderRoomTab({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 60,
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '$title coming soon',
            style: AppTextStyles.subtitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
