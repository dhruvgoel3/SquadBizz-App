import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import 'onboarding_controller.dart';

/// Three-slide onboarding screen with dot indicators and Next / Skip / Get Started.
class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  // ── Slide data ──
  static const _slides = [
    _SlideData(
      icon: Icons.group_add_rounded,
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
      color: Color(0xFFEDE9FF),
      iconColor: AppColors.primary,
    ),
    _SlideData(
      icon: Icons.how_to_vote_rounded,
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
      color: Color(0xFFE0F7FA),
      iconColor: Color(0xFF00897B),
    ),
    _SlideData(
      icon: Icons.account_balance_wallet_rounded,
      title: AppStrings.onboardingTitle3,
      subtitle: AppStrings.onboardingSubtitle3,
      color: Color(0xFFFFF3E0),
      iconColor: Color(0xFFF57C00),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button ──
            Obx(
              () => Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 24),
                  child: controller.isLastPage
                      ? const SizedBox(height: 48)
                      : TextButton(
                          onPressed: controller.skip,
                          child: Text(
                            AppStrings.skip,
                            style: AppTextStyles.link,
                          ),
                        ),
                ),
              ),
            ),

            // ── PageView ──
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: OnboardingController.totalPages,
                itemBuilder: (_, index) =>
                    _OnboardingSlide(data: _slides[index]),
              ),
            ),

            // ── Dot Indicator ──
            SmoothPageIndicator(
              controller: controller.pageController,
              count: OnboardingController.totalPages,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.grey300,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
                spacing: 6,
              ),
            ),
            const SizedBox(height: 40),

            // ── Next / Get Started button ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Obx(
                () => CustomButton(
                  label: controller.isLastPage
                      ? AppStrings.getStarted
                      : AppStrings.next,
                  onTap: controller.nextPage,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Private slide data model ──
class _SlideData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;

  const _SlideData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
  });
}

// ── Individual slide widget ──
class _OnboardingSlide extends StatelessWidget {
  final _SlideData data;

  const _OnboardingSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Illustration circle ──
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: data.color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: 80,
              color: data.iconColor,
            ),
          ),
          const SizedBox(height: 48),

          // ── Title ──
          Text(
            data.title,
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // ── Subtitle ──
          Text(
            data.subtitle,
            style: AppTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
