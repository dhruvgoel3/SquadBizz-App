import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../injection.dart';
import '../bloc/expense_bloc.dart';

/// Page to create a new expense within a room.
class CreateExpensePage extends StatefulWidget {
  final String roomId;
  const CreateExpensePage({super.key, required this.roomId});

  @override
  State<CreateExpensePage> createState() => _CreateExpensePageState();
}

class _CreateExpensePageState extends State<CreateExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpenseBloc>(),
      child: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseCreated) {
            context.pop(true);
          } else if (state is ExpenseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
            setState(() => _isSubmitting = false);
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Add Expense',
              style: AppTextStyles.heading3.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.screenPaddingH),
              children: [
                // Title
                Text('What was it for?', style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'e.g. Dinner, Uber, Groceries'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a title' : null,
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Amount
                Text('How much?', style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    prefixText: '₹ ',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter an amount';
                    final amount = double.tryParse(v.trim());
                    if (amount == null || amount <= 0) return 'Enter a valid amount';
                    return null;
                  },
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Note
                Text('Note (optional)', style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: const InputDecoration(hintText: 'Add a note...'),
                ),

                const SizedBox(height: 12),

                // Info text
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.info, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This expense will be split equally among all room members.',
                          style: AppTextStyles.caption.copyWith(color: AppColors.info),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Submit
                Builder(
                  builder: (ctx) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppConstants.buttonHeight,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : () {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isSubmitting = true);
                            final currentUserId = Supabase.instance.client.auth.currentUser!.id;
                            ctx.read<ExpenseBloc>().add(CreateExpenseEvent(
                              roomId: widget.roomId,
                              title: _titleController.text.trim(),
                              amount: double.parse(_amountController.text.trim()),
                              note: _noteController.text.trim().isNotEmpty
                                  ? _noteController.text.trim()
                                  : null,
                              participantUserIds: [currentUserId], // Will be expanded with room members
                            ));
                          }
                        },
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text('Add Expense', style: AppTextStyles.button),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
