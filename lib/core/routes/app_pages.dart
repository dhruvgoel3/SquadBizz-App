import 'package:get/get.dart';
import 'app_routes.dart';

// ── Feature screens ──
import '../../features/splash/splash_screen.dart';
import '../../features/splash/splash_controller.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/onboarding_controller.dart';
import '../../features/auth/register/register_screen.dart';
import '../../features/auth/register/register_controller.dart';
import '../../features/auth/otp/otp_screen.dart';
import '../../features/auth/otp/otp_controller.dart';
import '../../features/auth/login/login_screen.dart';
import '../../features/auth/login/login_controller.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/home_controller.dart';
import '../../features/create_room/create_room_screen.dart';
import '../../features/create_room/create_room_controller.dart';

/// GetX page-route definitions for the entire app.
class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final pages = <GetPage>[
    // ── Splash ──
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
      transition: Transition.fadeIn,
    ),

    // ── Onboarding ──
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.put(OnboardingController());
      }),
      transition: Transition.rightToLeft,
    ),

    // ── Register ──
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: BindingsBuilder(() {
        Get.put(RegisterController());
      }),
      transition: Transition.rightToLeft,
    ),

    // ── OTP Verification ──
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpScreen(),
      binding: BindingsBuilder(() {
        Get.put(OtpController());
      }),
      transition: Transition.rightToLeft,
    ),

    // ── Login ──
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.put(LoginController());
      }),
      transition: Transition.rightToLeft,
    ),

    // ── Home (Rooms List) ──
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
      transition: Transition.fadeIn,
    ),

    // ── Create Room ──
    GetPage(
      name: AppRoutes.createRoom,
      page: () => const CreateRoomScreen(),
      binding: BindingsBuilder(() {
        Get.put(CreateRoomController());
      }),
      transition: Transition.rightToLeft,
    ),
  ];
}
