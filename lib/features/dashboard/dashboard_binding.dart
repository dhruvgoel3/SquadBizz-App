import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../rooms/rooms_controller.dart';
import '../activity/activity_controller.dart';
import '../balances/balances_controller.dart';
import '../profile/profile_controller.dart';

/// Lazily initialises all dashboard tab controllers.
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => RoomsController());
    Get.lazyPut(() => ActivityController());
    Get.lazyPut(() => BalancesController());
    Get.lazyPut(() => ProfileController());
  }
}
