import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

/// Reusable shimmer loading placeholder.
///
/// Shows a pulsing grey skeleton while data is loading.
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 80,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey200,
      highlightColor: AppColors.grey100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.grey200,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Generates a list of shimmer placeholders for list loading states.
  static Widget list({int count = 3, double height = 80, double spacing = 12}) {
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: ShimmerLoading(height: height),
        ),
      ),
    );
  }
}
