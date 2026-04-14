import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/create_room_page.dart';

/// Named route constants for SquadBizz.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String register = '/register';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String createRoom = '/create-room';
  static const String joinRoom = '/join-room';
  static const String roomDashboard = '/room-dashboard';
  static const String profileSetup = '/profile-setup';
}

/// GoRouter configuration for the entire app.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    // ── Splash ──
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),

    // ── Onboarding ──
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),

    // ── Register ──
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),

    // ── Login ──
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),

    // ── OTP Verification ──
    GoRoute(
      path: AppRoutes.otp,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return OtpPage(
          phoneNumber: extra['phone'] as String? ?? '',
          fullName: extra['fullName'] as String? ?? '',
          source: extra['source'] as String? ?? 'register',
        );
      },
    ),

    // ── Home (Rooms List) ──
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),

    // ── Create Room ──
    GoRoute(
      path: AppRoutes.createRoom,
      builder: (context, state) => const CreateRoomPage(),
    ),
  ],
);
