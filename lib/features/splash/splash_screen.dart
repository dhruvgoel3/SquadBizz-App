import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import 'splash_controller.dart';

/// Splash screen — shows the SquadBizz logo and app name while the
/// [SplashController] decides where to navigate next.
class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the controller is registered (via GetView)
    // ignore: unnecessary_statements
    controller;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── App Icon ──
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.groups_rounded,
                size: 52,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 28),

            // ── App Name ──
            Text(
              AppStrings.appName,
              style: AppTextStyles.heading1.copyWith(
                color: Colors.white,
                fontSize: 34,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // ── Tagline ──
            Text(
              AppStrings.appTagline,
              style: AppTextStyles.subtitle.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
