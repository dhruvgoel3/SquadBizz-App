import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
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
            context.pop(true);
          } else if (state is PollError) {
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
              'Create Poll',
              style: AppTextStyles.heading3.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.screenPaddingH),
              children: [
                // Question
                Text('Question', style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _questionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: "What's on your mind?",
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a question' : null,
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Options
                Text('Options', style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
                const SizedBox(height: 8),
                ...List.generate(_optionControllers.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _optionControllers[i],
                            decoration: InputDecoration(
                              hintText: 'Option ${i + 1}',
                            ),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Option cannot be empty'
                                : null,
                          ),
                        ),
                        if (_optionControllers.length > 2)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 22),
                            onPressed: () => _removeOption(i),
                          ),
                      ],
                    ),
                  );
                }),

                if (_optionControllers.length < 8)
                  TextButton.icon(
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text('Add Option'),
                    onPressed: _addOption,
                  ),

                const SizedBox(height: AppConstants.spacingLg),

                // Poll type toggle
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.grey50,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Allow multiple choices', style: AppTextStyles.body.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          )),
                          Switch.adaptive(
                            value: _pollType == 'multi',
                            onChanged: (v) => setState(() => _pollType = v ? 'multi' : 'single'),
                            activeTrackColor: AppColors.primary,
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Anonymous voting', style: AppTextStyles.body.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          )),
                          Switch.adaptive(
                            value: _isAnonymous,
                            onChanged: (v) => setState(() => _isAnonymous = v),
                            activeTrackColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Submit button
                Builder(
                  builder: (ctx) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppConstants.buttonHeight,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : () {
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
                                width: 22, height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text('Create Poll', style: AppTextStyles.button),
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
