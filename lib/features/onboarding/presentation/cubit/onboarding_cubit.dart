import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Onboarding states.
class OnboardingState {
  final int currentPage;
  final bool isLastPage;

  const OnboardingState({this.currentPage = 0, this.isLastPage = false});

  OnboardingState copyWith({int? currentPage, bool? isLastPage}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}

/// Controls the onboarding PageView state.
class OnboardingCubit extends Cubit<OnboardingState> {
  static const int totalPages = 3;
  final PageController pageController = PageController();

  OnboardingCubit() : super(const OnboardingState());

  /// Move to the next page.
  void nextPage() {
    if (state.isLastPage) return; // Navigation handled by UI

    pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  /// Track the current page from PageView's onPageChanged.
  void onPageChanged(int index) {
    emit(OnboardingState(
      currentPage: index,
      isLastPage: index == totalPages - 1,
    ));
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
