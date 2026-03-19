import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/supabase_service.dart';

/// Controls the splash screen lifecycle.
///
/// On init: waits 3 seconds, checks Supabase session, then navigates
/// to either the main dashboard or the onboarding screen.
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateAfterDelay();
  }

  /// Wait for the splash animation, then decide where to go.
  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));

    if (SupabaseService.isLoggedIn) {
      // User has an active Supabase session → go to home
      Get.offNamed(AppRoutes.home);
    } else {
      // No session → show onboarding
      Get.offNamed(AppRoutes.onboarding);
    }
  }
}
