import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../injection.dart';
import '../bloc/expense_bloc.dart';

/// Expenses tab — shows all expenses in a room.
class ExpensesTab extends StatelessWidget {
  final String roomId;
  const ExpensesTab({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpenseBloc>()..add(LoadExpensesEvent(roomId)),
      child: _ExpensesView(roomId: roomId),
    );
  }
}

class _ExpensesView extends StatelessWidget {
  final String roomId;
  const _ExpensesView({required this.roomId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await context.push<bool>(
            AppRoutes.createExpense,
            extra: {'roomId': roomId},
          );
          if (result == true && context.mounted) {
            context.read<ExpenseBloc>().add(RefreshExpensesEvent(roomId));
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Add Expense', style: AppTextStyles.button.copyWith(color: Colors.white)),
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is ExpenseError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.error.withValues(alpha: 0.6)),
                  const SizedBox(height: 12),
                  Text(state.message, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.read<ExpenseBloc>().add(LoadExpensesEvent(roomId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ExpenseLoaded) {
            if (state.expenses.isEmpty) {
              return _buildEmptyState(context);
            }

            // Calculate total owed to/by current user
            var youOwe = 0.0;
            var youAreOwed = 0.0;

            for (final exp in state.expenses) {
              final createdBy = exp['created_by'] as String?;
              final participants = (exp['participants'] as List?)?.cast<Map<String, dynamic>>() ?? [];

              for (final p in participants) {
                final owed = (p['amount_owed'] as num?)?.toDouble() ?? 0;
                final isPaid = p['is_paid'] as bool? ?? false;

                if (!isPaid && owed > 0) {
                  if (p['user_id'] == currentUserId) {
                    youOwe += owed;
                  } else if (createdBy == currentUserId) {
                    youAreOwed += owed;
                  }
                }
              }
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ExpenseBloc>().add(RefreshExpensesEvent(roomId));
              },
              color: AppColors.primary,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.screenPaddingH,
                  AppConstants.spacingMd,
                  AppConstants.screenPaddingH,
                  100,
                ),
                children: [
                  // Balance summary card
                  _buildBalanceSummary(context, isDark, youOwe, youAreOwed),
                  const SizedBox(height: AppConstants.spacingLg),

                  // Expense list
                  ...state.expenses.map((e) => _ExpenseCard(
                    expense: e,
                    isDark: isDark,
                    currentUserId: currentUserId ?? '',
                  )),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        },
      ),
    );
  }

  Widget _buildBalanceSummary(BuildContext context, bool isDark, double youOwe, double youAreOwed) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('You owe', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                const SizedBox(height: 4),
                Text(
                  '₹${youOwe.toStringAsFixed(0)}',
                  style: AppTextStyles.heading2.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 50, color: Colors.white24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('You are owed', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(
                    '₹${youAreOwed.toStringAsFixed(0)}',
                    style: AppTextStyles.heading2.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long_rounded, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            'No expenses yet',
            style: AppTextStyles.heading3.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 6),
          Text(
            'Track shared expenses with your squad',
            style: AppTextStyles.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final Map<String, dynamic> expense;
  final bool isDark;
  final String currentUserId;

  const _ExpenseCard({required this.expense, required this.isDark, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final title = expense['title'] as String? ?? '';
    final amount = (expense['amount'] as num?)?.toDouble() ?? 0;
    final createdBy = expense['created_by'] as String? ?? '';
    final createdAt = expense['created_at'] != null
        ? DateTime.tryParse(expense['created_at'].toString())
        : null;
    final isPayer = createdBy == currentUserId;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.dividerLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (isPayer ? AppColors.success : AppColors.warning).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isPayer ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                color: isPayer ? AppColors.success : AppColors.warning,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
                  if (createdAt != null)
                    Text(
                      '${isPayer ? "You paid" : "Paid by someone"} • ${timeago.format(createdAt)}',
                      style: AppTextStyles.caption.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '₹${amount.toStringAsFixed(0)}',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                color: isPayer ? AppColors.success : AppColors.warning,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
