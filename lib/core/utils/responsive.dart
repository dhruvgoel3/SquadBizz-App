import 'package:flutter/material.dart';

/// Responsive utility extensions.
///
/// Uses ScreenUtil under the hood for consistent scaling.
///
/// Usage:
/// ```dart
/// Text('Hello', style: TextStyle(fontSize: 16.sp));
/// SizedBox(width: 24.w, height: 24.h);
/// Padding(padding: EdgeInsets.all(16.w));
/// ```
///
/// These are re-exported from flutter_screenutil — no extra work needed.
/// Just wrap your MaterialApp.router with ScreenUtilInit.
///
/// For custom responsive checks:
/// ```dart
/// if (context.isMobile) { ... }
/// if (context.isTablet) { ... }
/// ```
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  /// Returns a value based on screen size.
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }
}
