import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/shimmer_loading.dart';
import 'balances_controller.dart';
import 'widgets/balance_room_group.dart';

/// Balances tab — summary card + room-grouped balance entries.
class BalancesTab extends GetView<BalancesController> {
  const BalancesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.myBalances, style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshBalances,
        color: AppColors.primary,
        child: Obx(() {
          if (controller.isLoading.value) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ShimmerLoading.list(count: 4, height: 60),
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Summary Card ──
                _summaryCard(),
                const SizedBox(height: 24),

                // ── Balance list ──
                if (controller.balances.isEmpty)
                  _emptyState()
                else
                  ..._buildGroupedBalances(),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Summary card showing owed, owe, and net balance.
  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  AppStrings.youAreOwed,
                  '₹ ${controller.youAreOwed.value.toStringAsFixed(0)}',
                  const Color(0xFF86EFAC),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _summaryItem(
                  AppStrings.youOwe,
                  '₹ ${controller.youOwe.value.toStringAsFixed(0)}',
                  const Color(0xFFFCA5A5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${AppStrings.netBalance}: ',
                  style: AppTextStyles.body.copyWith(color: Colors.white70),
                ),
                Text(
                  '₹ ${controller.netBalance.toStringAsFixed(0)}',
                  style: AppTextStyles.heading3.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label,
            style: AppTextStyles.caption.copyWith(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(value,
            style: AppTextStyles.heading3.copyWith(color: valueColor)),
      ],
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_wallet_outlined,
                  size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(AppStrings.noBalancesYet, style: AppTextStyles.subtitle),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGroupedBalances() {
    // Group balances by room_name
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final b in controller.balances) {
      final room = b['room_name'] ?? 'Unknown Room';
      grouped.putIfAbsent(room, () => []);
      grouped[room]!.add(b);
    }

    return grouped.entries.map((entry) {
      return BalanceRoomGroup(
        roomName: entry.key,
        entries: entry.value,
      );
    }).toList();
  }
}
