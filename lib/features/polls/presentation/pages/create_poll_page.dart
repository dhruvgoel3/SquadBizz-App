import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../injection.dart';
import '../bloc/poll_bloc.dart';

/// Page to create a new poll within a room.
class CreatePollPage extends StatefulWidget {
  final String roomId;
  const CreatePollPage({super.key, required this.roomId});

  @override
  State<CreatePollPage> createState() => _CreatePollPageState();
}

class _CreatePollPageState extends State<CreatePollPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  String _pollType = 'single';
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _questionController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    if (_optionControllers.length < 8) {
      setState(() => _optionControllers.add(TextEditingController()));
    }
  }

  void _removeOption(int index) {
    if (_optionControllers.length > 2) {
      setState(() {
        _optionControllers[index].dispose();
        _optionControllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => sl<PollBloc>(),
      child: BlocListener<PollBloc, PollState>(
        listener: (context, state) {
          if (state is PollCreated) {
            AppSnackbar.success(context, message: 'Poll created!');
            // Defer pop to avoid !_debugLocked
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) context.pop(true);
            });
          } else if (state is PollError) {
            AppSnackbar.error(context, message: state.message);
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
              'Create Poll',
              style: AppTextStyles.heading3.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.screenPaddingH),
              children: [
                // ── Question Section ──
                _sectionHeader(context, Icons.help_outline_rounded, 'Question'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _questionController,
                  maxLines: 2,
                  maxLength: 200,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    counterText: '',
                    filled: true,
                    fillColor: isDark ? AppColors.inputFillDark : AppColors.inputFillLight,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a question' : null,
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // ── Options Section ──
                _sectionHeader(context, Icons.list_alt_rounded, 'Options'),
                const SizedBox(height: 10),
                ...List.generate(_optionControllers.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _optionControllers[i],
                            textCapitalization: TextCapitalization.sentences,
                            style: AppTextStyles.body.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Option ${i + 1}',
                              filled: true,
                              fillColor: isDark ? AppColors.inputFillDark : AppColors.inputFillLight,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Option cannot be empty'
                                : null,
                          ),
                        ),
                        if (_optionControllers.length > 2) ...[
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 22),
                            onPressed: () => _removeOption(i),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ],
                    ),
                  );
                }),

                if (_optionControllers.length < 8)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add Option'),
                      onPressed: _addOption,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: AppConstants.spacingLg),

                // ── Settings Section ──
                _sectionHeader(context, Icons.tune_rounded, 'Settings'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.grey50,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.dividerLight,
                    ),
                  ),
                  child: Column(
                    children: [
                      _settingRow(
                        context: context,
                        icon: Icons.radio_button_checked_rounded,
                        label: 'Allow multiple choices',
                        value: _pollType == 'multi',
                        onChanged: (v) => setState(() => _pollType = v ? 'multi' : 'single'),
                      ),
                      Divider(
                        height: 1,
                        color: isDark ? AppColors.borderDark : AppColors.dividerLight,
                      ),
                      _settingRow(
                        context: context,
                        icon: Icons.visibility_off_outlined,
                        label: 'Anonymous voting',
                        value: _isAnonymous,
                        onChanged: (v) => setState(() => _isAnonymous = v),
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
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isSubmitting = true);
                                  final options = _optionControllers
                                      .map((c) => c.text.trim())
                                      .where((t) => t.isNotEmpty)
                                      .toList();
                                  ctx.read<PollBloc>().add(CreatePollEvent(
                                        roomId: widget.roomId,
                                        question: _questionController.text.trim(),
                                        options: options,
                                        pollType: _pollType,
                                        isAnonymous: _isAnonymous,
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
                                  const Icon(Icons.how_to_vote_rounded, size: 20),
                                  const SizedBox(width: 8),
                                  Text('Create Poll', style: AppTextStyles.button),
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

  Widget _settingRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
