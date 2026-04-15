import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../injection.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

/// Join Room page — enter 6-character alphanumeric code.
class JoinRoomPage extends StatelessWidget {
  const JoinRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>(),
      child: const _JoinRoomView(),
    );
  }
}

class _JoinRoomView extends StatefulWidget {
  const _JoinRoomView();

  @override
  State<_JoinRoomView> createState() => _JoinRoomViewState();
}

class _JoinRoomViewState extends State<_JoinRoomView> {
  final _codeController = TextEditingController();
  String? _codeError;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onJoinPressed() {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _codeError = 'Please enter a room code');
      return;
    }
    if (code.length != AppConstants.roomCodeLength) {
      setState(() =>
          _codeError = 'Room code must be ${AppConstants.roomCodeLength} characters');
      return;
    }
    setState(() => _codeError = null);

    context.read<HomeBloc>().add(JoinRoomEvent(code));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is RoomJoined) {
          AppSnackbar.success(context, message: 'Successfully joined room!');
          // Pop the current page to return to home, where it will refresh automatically
          context.pop(true);
        } else if (state is RoomJoinError) {
          AppSnackbar.error(context, message: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Join Room',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppConstants.spacingXl),
              
              // ── Icon ──
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.group_add_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),
              
              Text(
                'Enter Invite Code',
                style: AppTextStyles.heading2.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                'Ask the room admin for the ${AppConstants.roomCodeLength}-character invite code.',
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: AppConstants.spacingXxl),

              // ── Code Input ──
              TextFormField(
                controller: _codeController,
                maxLength: AppConstants.roomCodeLength,
                textCapitalization: TextCapitalization.characters,
                onChanged: (v) {
                  if (v.trim().isNotEmpty) setState(() => _codeError = null);
                },
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 4,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'ABCD12',
                  hintStyle: AppTextStyles.heading2.copyWith(
                    color: AppColors.grey400,
                    letterSpacing: 4,
                  ),
                  errorText: _codeError,
                  counterText: '',
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceVariantDark : AppColors.grey100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppConstants.spacingLg,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingXxl),

              // ── Join Button ──
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return CustomButton(
                    label: 'Join Room',
                    isLoading: state is RoomJoining,
                    onTap: _onJoinPressed,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
