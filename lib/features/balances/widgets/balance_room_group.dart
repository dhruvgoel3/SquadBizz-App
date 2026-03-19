import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';

/// Grouped balance rows for a specific room.
class BalanceRoomGroup extends StatelessWidget {
  final String roomName;
  final List<Map<String, dynamic>> entries;

  const BalanceRoomGroup({
    super.key,
    required this.roomName,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'In $roomName',
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          ...entries.map((entry) {
            final amount = (entry['amount'] ?? 0).toDouble();
            final otherPerson = entry['other_person'] ?? 'Someone';
            final isPositive = amount > 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    isPositive
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    size: 18,
                    color: isPositive ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isPositive
                          ? '$otherPerson owes you'
                          : 'You owe $otherPerson',
                      style: AppTextStyles.body,
                    ),
                  ),
                  Text(
                    '₹ ${amount.abs().toStringAsFixed(0)}',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isPositive ? AppColors.success : AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 28,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        AppStrings.settleUp,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
