import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_snackbar.dart';
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
  bool _isLoadingMembers = true;
  
  List<Map<String, dynamic>> _roomMembers = [];
  final Set<String> _selectedUserIds = {};

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _toggleSelection(String userId) {
    setState(() {
      if (_selectedUserIds.contains(userId)) {
        if (_selectedUserIds.length > 1) { // Prevent unselecting everyone
          _selectedUserIds.remove(userId);
        } else {
          AppSnackbar.error(context, message: 'Expense must have at least one participant.');
        }
      } else {
        _selectedUserIds.add(userId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedUserIds.clear();
      _selectedUserIds.addAll(_roomMembers.map((m) => m['user_id'] as String));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;

    return BlocProvider(
      create: (_) => sl<ExpenseBloc>()..add(LoadRoomMembersEvent(widget.roomId)),
      child: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is RoomMembersLoaded) {
            setState(() {
              _roomMembers = state.members;
              _selectedUserIds.addAll(_roomMembers.map((m) => m['user_id'] as String));
              _isLoadingMembers = false;
            });
          } else if (state is ExpenseCreated) {
            setState(() {
              _isSubmitting = false;
            });
            AppSnackbar.success(context, message: 'Expense added!');
            // Use standard Navigator with Future.delayed to avoid route popping collisions
            Future.delayed(const Duration(milliseconds: 100), () {
              if (context.mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop(true);
              }
            });
          } else if (state is ExpenseError) {
            AppSnackbar.error(context, message: state.message);
            setState(() {
              _isSubmitting = false;
              if (_isLoadingMembers) _isLoadingMembers = false;
            });
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
                // ── What was it for? ──
                _sectionHeader(context, Icons.receipt_long_rounded, 'What was it for?'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. Dinner, Uber, Groceries',
                    filled: true,
                    fillColor: isDark ? AppColors.inputFillDark : AppColors.inputFillLight,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a title' : null,
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // ── How much? ──
                _sectionHeader(context, Icons.currency_rupee_rounded, 'How much?'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixText: '₹ ',
                    filled: true,
                    fillColor: isDark ? AppColors.inputFillDark : AppColors.inputFillLight,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter an amount';
                    final amount = double.tryParse(v.trim());
                    if (amount == null || amount <= 0) return 'Enter a valid amount';
                    return null;
                  },
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // ── Note (Optional) ──
                _sectionHeader(context, Icons.notes_rounded, 'Note (optional)'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _noteController,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add a note...',
                    filled: true,
                    fillColor: isDark ? AppColors.inputFillDark : AppColors.inputFillLight,
                  ),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // ── Split With ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _sectionHeader(context, Icons.people_alt_rounded, 'Split with'),
                    if (_roomMembers.isNotEmpty)
                      TextButton(
                        onPressed: _selectAll,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Select All',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                
                if (_isLoadingMembers)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    ),
                  )
                else if (_roomMembers.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('No members found in this room.', style: AppTextStyles.bodySmall),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.grey50,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.dividerLight,
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _roomMembers.length,
                      separatorBuilder: (ctx, idx) => Divider(
                        height: 1,
                        color: isDark ? AppColors.borderDark : AppColors.dividerLight,
                      ),
                      itemBuilder: (context, index) {
                        final member = _roomMembers[index];
                        final userId = member['user_id'] as String;
                        final role = member['role'] as String;
                        final isMe = userId == currentUserId;
                        
                        // Because we lack a profile table, display generic logic for members
                        final displayName = isMe ? 'You' : 'Member (${userId.substring(0, 5)})';
                        final isSelected = _selectedUserIds.contains(userId);

                        return ListTile(
                          onTap: () => _toggleSelection(userId),
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                            child: Text(
                              displayName[0].toUpperCase(),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                displayName,
                                style: AppTextStyles.body.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: isMe ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                              if (role == 'admin') ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Admin',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.grey400,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                                : null,
                          ),
                        );
                      },
                    ),
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
                          _selectedUserIds.isEmpty
                            ? 'Please select participants.'
                            : 'This expense will be split equally among ${_selectedUserIds.length} participant${_selectedUserIds.length > 1 ? "s" : ""}.',
                          style: AppTextStyles.caption.copyWith(color: AppColors.info),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // ── Submit ──
                Builder(
                  builder: (ctx) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppConstants.buttonHeight,
                      child: ElevatedButton(
                        onPressed: _isSubmitting || _selectedUserIds.isEmpty || _isLoadingMembers
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isSubmitting = true);
                                  ctx.read<ExpenseBloc>().add(CreateExpenseEvent(
                                        roomId: widget.roomId,
                                        title: _titleController.text.trim(),
                                        amount: double.parse(_amountController.text.trim()),
                                        note: _noteController.text.trim().isNotEmpty
                                            ? _noteController.text.trim()
                                            : null,
                                        participantUserIds: _selectedUserIds.toList(),
                                      ));
                                }
                              },
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.receipt_long_rounded, size: 20),
                                  const SizedBox(width: 8),
                                  Text('Add Expense', style: AppTextStyles.button),
                                ],
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppConstants.spacingLg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
