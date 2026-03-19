import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'dashboard_controller.dart';
import '../rooms/rooms_tab.dart';
import '../activity/activity_tab.dart';
import '../balances/balances_tab.dart';
import '../profile/profile_tab.dart';

/// Main dashboard — Scaffold with BottomNavigationBar and IndexedStack.
///
/// Uses IndexedStack to preserve tab state when switching.
class MainDashboard extends GetView<DashboardController> {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: controller.selectedIndex.value,
            children: const [
              RoomsTab(),
              ActivityTab(),
              BalancesTab(),
              ProfileTab(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.grey400,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            elevation: 8,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: AppStrings.rooms,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded),
                label: AppStrings.activity,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                label: AppStrings.balances,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                label: AppStrings.profile,
              ),
            ],
          ),
        ));
  }
}
