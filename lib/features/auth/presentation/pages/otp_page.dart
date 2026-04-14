import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../injection.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// OTP verification page — 6-digit auto-advance with countdown.
class OtpPage extends StatelessWidget {
  final String phoneNumber;
  final String fullName;
  final String source;

  const OtpPage({
    super.key,
    required this.phoneNumber,
    required this.fullName,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: _OtpView(
        phoneNumber: phoneNumber,
        fullName: fullName,
        source: source,
      ),
    );
  }
}

class _OtpView extends StatefulWidget {
  final String phoneNumber;
  final String fullName;
  final String source;

  const _OtpView({
    required this.phoneNumber,
    required this.fullName,
    required this.source,
  });

  @override
  State<_OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<_OtpView> {
  final List<TextEditingController> _controllers =
      List.generate(AppConstants.otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(AppConstants.otpLength, (_) => FocusNode());

  int _resendCountdown = AppConstants.otpResendSeconds;
  Timer? _countdownTimer;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _resendCountdown = AppConstants.otpResendSeconds;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_resendCountdown <= 1) {
          timer.cancel();
          _resendCountdown = 0;
        } else {
          _resendCountdown--;
        }
      });
    });
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  void _onDigitChanged(String value, int index) {
    setState(() => _otpError = null);
    if (value.isNotEmpty && index < AppConstants.otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpVerified) {
          AppSnackbar.success(context, message: AppStrings.otpVerified);
          context.go(AppRoutes.home);
        } else if (state is AuthError) {
          setState(() => _otpError = state.message);
          context.read<AuthBloc>().add(const AuthResetEvent());
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.screenPaddingH,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppConstants.spacingLg),

                // ── Icon ──
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusXl,
                    ),
                  ),
                  child: const Icon(
                    Icons.sms_rounded,
                    size: AppConstants.iconSizeLarge,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                Text(
                  AppStrings.otpVerification,
                  style: AppTextStyles.heading2.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  '${AppStrings.otpSubtitle}\n${widget.phoneNumber}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // ── OTP Fields ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(AppConstants.otpLength, (index) {
                    return Container(
                      width: 48,
                      height: 56,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingXs,
                      ),
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: AppTextStyles.heading3.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: isDark
                              ? AppColors.inputFillDark
                              : AppColors.inputFillLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (v) => _onDigitChanged(v, index),
                      ),
                    );
                  }),
                ),

                if (_otpError != null) ...[
                  const SizedBox(height: AppConstants.spacingSm),
                  Text(
                    _otpError!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppConstants.spacingXl),

                // ── Verify Button ──
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return CustomButton(
                      label: AppStrings.verifyOtp,
                      isLoading: state is AuthLoading,
                      onTap: () {
                        if (_otpCode.length != AppConstants.otpLength) {
                          setState(
                            () => _otpError = 'Enter all ${AppConstants.otpLength} digits',
                          );
                          return;
                        }
                        context.read<AuthBloc>().add(VerifyOtpEvent(
                              phone: widget.phoneNumber,
                              token: _otpCode,
                            ));
                      },
                    );
                  },
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // ── Resend ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.didntReceiveCode,
                      style: AppTextStyles.body.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                    GestureDetector(
                      onTap: _resendCountdown > 0
                          ? null
                          : () {
                              context.read<AuthBloc>().add(SendOtpEvent(
                                    phone: widget.phoneNumber,
                                  ));
                              _startCountdown();
                            },
                      child: Text(
                        _resendCountdown > 0
                            ? '${AppStrings.resendIn} ${_resendCountdown}s'
                            : AppStrings.resendOtp,
                        style: AppTextStyles.link.copyWith(
                          color: _resendCountdown > 0
                              ? AppColors.grey400
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
