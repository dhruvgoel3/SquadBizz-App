import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../injection.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

/// Create Room page — emoji picker, validation, invite code on success.
class CreateRoomPage extends StatelessWidget {
  const CreateRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>(),
      child: const _CreateRoomView(),
    );
  }
}

class _CreateRoomView extends StatefulWidget {
  const _CreateRoomView();

  @override
  State<_CreateRoomView> createState() => _CreateRoomViewState();
}

class _CreateRoomViewState extends State<_CreateRoomView> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedEmoji = '👥';
  String? _nameError;
  int _nameLength = 0;
  int _descLength = 0;

  static const _emojis = [
    '🏖️', '✈️', '🏠', '🍕', '🎉', '💼', '🏕️', '🎮', '💰', '👥',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is RoomCreated) {
          _showInviteSheet(context, state.roomCode);
        } else if (state is RoomCreateError) {
          AppSnackbar.error(context, message: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Create a Room',
            style: AppTextStyles.heading2.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.screenPaddingH,
            vertical: AppConstants.screenPaddingV,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.spacingSm),

              // ── Room Name ──
              _fieldLabel(context, 'Room Name'),
              const SizedBox(height: AppConstants.spacingSm),
              TextFormField(
                controller: _nameController,
                maxLength: AppConstants.maxRoomNameLength,
                onChanged: (v) => setState(() {
                  _nameLength = v.length;
                  if (v.trim().isNotEmpty) _nameError = null;
                }),
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. Goa Trip 2025, Flatmates',
                  counterText: '$_nameLength/${AppConstants.maxRoomNameLength}',
                  counterStyle: AppTextStyles.caption,
                  errorText: _nameError,
                  prefixIcon: const Icon(
                    Icons.meeting_room_outlined,
                    color: AppColors.grey400,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingSm),

              // ── Description ──
              _fieldLabel(context, 'Description (optional)'),
              const SizedBox(height: AppConstants.spacingSm),
              TextFormField(
                controller: _descController,
                maxLength: AppConstants.maxRoomDescLength,
                maxLines: 3,
                minLines: 1,
                onChanged: (v) => setState(() => _descLength = v.length),
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: "What's this room for?",
                  counterText: '$_descLength/${AppConstants.maxRoomDescLength}',
                  counterStyle: AppTextStyles.caption,
                  prefixIcon: const Icon(
                    Icons.description_outlined,
                    color: AppColors.grey400,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // ── Emoji picker ──
              _fieldLabel(context, 'Choose an Icon'),
              const SizedBox(height: AppConstants.spacingXs),
              Text(
                'This emoji will appear on your room card',
                style: AppTextStyles.caption.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Wrap(
                spacing: AppConstants.spacingSm,
                runSpacing: AppConstants.spacingSm,
                children: _emojis.map((emoji) {
                  final isSelected = emoji == _selectedEmoji;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedEmoji = emoji),
                    child: AnimatedContainer(
                      duration: AppConstants.animFast,
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : isDark
                                ? AppColors.inputFillDark
                                : AppColors.inputFillLight,
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusLg,
                        ),
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // ── Create button ──
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return CustomButton(
                    label: AppStrings.createRoom,
                    isLoading: state is RoomCreating,
                    onTap: _onCreateRoom,
                  );
                },
              ),
              const SizedBox(height: AppConstants.spacingLg),
            ],
          ),
        ),
      ),
    );
  }

  void _onCreateRoom() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Room name is required');
      return;
    }
    if (name.length < AppConstants.minNameLength) {
      setState(
        () => _nameError = 'Room name must be at least ${AppConstants.minNameLength} characters',
      );
      return;
    }
    setState(() => _nameError = null);

    context.read<HomeBloc>().add(CreateRoomEvent(
          name: name,
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          emoji: _selectedEmoji,
        ));
  }

  void _showInviteSheet(BuildContext context, String roomCode) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor:
          isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadiusXl),
        ),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              size: 64,
              color: AppColors.success,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              'Room Created!',
              style: AppTextStyles.heading2.copyWith(
                color: Theme.of(ctx).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Share this code with your squad:',
              style: AppTextStyles.subtitle.copyWith(
                color: Theme.of(ctx)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
              ),
              child: Text(
                roomCode,
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 6,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'Share',
                    variant: ButtonVariant.outlined,
                    icon: Icons.share_rounded,
                    height: 48,
                    onTap: () {
                      Share.share(
                        'Join my SquadBizz room with code: $roomCode',
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: CustomButton(
                    label: 'Continue',
                    height: 48,
                    onTap: () {
                      Navigator.pop(ctx);
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMd),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(BuildContext context, String text) {
    return Text(
      text,
      style: AppTextStyles.body.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
