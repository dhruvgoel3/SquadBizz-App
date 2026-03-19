import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';

/// Controls the onboarding PageView state.
class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  /// Total number of onboarding slides.
  static const int totalPages = 3;

  /// Whether the user is on the last page.
  bool get isLastPage => currentPage.value == totalPages - 1;

  /// Move to the next page with a smooth animation.
  void nextPage() {
    if (isLastPage) {
      _goToRegister();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Skip directly to the register screen.
  void skip() => _goToRegister();

  /// Navigate to registration and remove onboarding from the stack.
  void _goToRegister() {
    Get.offNamed(AppRoutes.register);
  }

  /// Track the current page from PageView's onPageChanged.
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
