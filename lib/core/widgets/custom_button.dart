import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Reusable primary action button for SquadBizz.
///
/// Shows a loading spinner when [isLoading] is true.
/// Supports filled, outlined, and text variants.
enum ButtonVariant { filled, outlined, text }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final ButtonVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final double borderRadius;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.variant = ButtonVariant.filled,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = AppConstants.buttonHeight,
    this.borderRadius = AppConstants.borderRadius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: switch (variant) {
        ButtonVariant.filled => _buildFilled(context),
        ButtonVariant.outlined => _buildOutlined(context),
        ButtonVariant.text => _buildText(context),
      },
    );
  }

  Widget _loadingSpinner(Color color) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _labelWidget(Color color) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppConstants.iconSizeSmall, color: color),
          const SizedBox(width: AppConstants.spacingSm),
          Text(label, style: AppTextStyles.button.copyWith(color: color)),
        ],
      );
    }
    return Text(label, style: AppTextStyles.button.copyWith(color: color));
  }

  ElevatedButton _buildFilled(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primary;
    final fg = foregroundColor ?? AppColors.textOnPrimary;
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        disabledBackgroundColor: bg.withValues(alpha: 0.5),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: isLoading ? _loadingSpinner(fg) : _labelWidget(fg),
    );
  }

  OutlinedButton _buildOutlined(BuildContext context) {
    final fg = foregroundColor ?? AppColors.primary;
    return OutlinedButton(
      onPressed: isLoading ? null : onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: fg,
        side: BorderSide(color: fg, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: isLoading ? _loadingSpinner(fg) : _labelWidget(fg),
    );
  }

  TextButton _buildText(BuildContext context) {
    final fg = foregroundColor ?? AppColors.primary;
    return TextButton(
      onPressed: isLoading ? null : onTap,
      style: TextButton.styleFrom(foregroundColor: fg),
      child: isLoading ? _loadingSpinner(fg) : _labelWidget(fg),
    );
  }
}
