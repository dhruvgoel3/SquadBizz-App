import 'package:get/get.dart';

/// Manages the selected tab index in the bottom navigation bar.
class DashboardController extends GetxController {
  final selectedIndex = 0.obs;

  /// Change the currently visible tab.
  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
