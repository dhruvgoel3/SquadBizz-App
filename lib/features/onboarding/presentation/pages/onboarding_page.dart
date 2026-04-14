import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/onboarding_cubit.dart';

/// Onboarding screen with 3 slides — matching Stitch "Onboarding 1" design.
///
/// Features animated illustration circles, dot indicators, and Next/Get Started.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  static const _slides = [
    _SlideData(
      icon: Icons.group_add_rounded,
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
      gradientColors: [Color(0xFFEDE9FF), Color(0xFFD4CFFF)],
      iconColor: AppColors.primary,
    ),
    _SlideData(
      icon: Icons.how_to_vote_rounded,
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
      gradientColors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
      iconColor: Color(0xFF00897B),
    ),
    _SlideData(
      icon: Icons.account_balance_wallet_rounded,
      title: AppStrings.onboardingTitle3,
      subtitle: AppStrings.onboardingSubtitle3,
      gradientColors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
      iconColor: Color(0xFFF57C00),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button ──
            BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                return Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, right: 24),
                    child: state.isLastPage
                        ? const SizedBox(height: 48)
                        : TextButton(
                            onPressed: () => context.go(AppRoutes.register),
                            child: Text(
                              AppStrings.skip,
                              style: AppTextStyles.link,
                            ),
                          ),
                  ),
                );
              },
            ),

            // ── PageView ──
            Expanded(
              child: PageView.builder(
                controller: cubit.pageController,
                onPageChanged: cubit.onPageChanged,
                itemCount: OnboardingCubit.totalPages,
                itemBuilder: (_, index) =>
                    _OnboardingSlide(data: _slides[index]),
              ),
            ),

            // ── Dot Indicator ──
            SmoothPageIndicator(
              controller: cubit.pageController,
              count: OnboardingCubit.totalPages,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: isDark ? AppColors.grey500 : AppColors.grey300,
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
              child: BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.isLastPage
                          ? () => context.go(AppRoutes.register)
                          : cubit.nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        state.isLastPage
                            ? AppStrings.getStarted
                            : AppStrings.next,
                        style: AppTextStyles.button,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Slide data model ──
class _SlideData {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final Color iconColor;

  const _SlideData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
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
          // ── Illustration circle with gradient ──
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: data.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: data.gradientColors.first.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
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
            style: AppTextStyles.heading2.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // ── Subtitle ──
          Text(
            data.subtitle,
            style: AppTextStyles.subtitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
