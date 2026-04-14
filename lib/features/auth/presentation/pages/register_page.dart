import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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

/// Register page — email + phone tabs with full validation.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _completePhone = '';

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNameController.dispose();
    super.dispose();
  }

  bool _validateEmailForm() {
    bool valid = true;
    setState(() {
      _nameError = _emailError = _passwordError = _confirmError = null;

      final name = _fullNameController.text.trim();
      if (name.isEmpty) {
        _nameError = AppStrings.requiredField;
        valid = false;
      } else if (name.length < AppConstants.minNameLength) {
        _nameError = AppStrings.nameTooShort;
        valid = false;
      }

      final email = _emailController.text.trim();
      if (email.isEmpty) {
        _emailError = AppStrings.requiredField;
        valid = false;
      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
        _emailError = AppStrings.invalidEmail;
        valid = false;
      }

      final password = _passwordController.text;
      if (password.isEmpty) {
        _passwordError = AppStrings.requiredField;
        valid = false;
      } else if (password.length < AppConstants.minPasswordLength) {
        _passwordError = AppStrings.passwordTooShort;
        valid = false;
      }

      final confirm = _confirmPasswordController.text;
      if (confirm.isEmpty) {
        _confirmError = AppStrings.requiredField;
        valid = false;
      } else if (confirm != password) {
        _confirmError = AppStrings.passwordsDoNotMatch;
        valid = false;
      }
    });
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          AppSnackbar.success(context, message: AppStrings.accountCreated);
          context.go(AppRoutes.home);
        } else if (state is AuthEmailConfirmRequired) {
          AppSnackbar.info(
            context,
            message: 'Confirmation link sent to ${state.email}. Please verify your email.',
            title: 'Check Email',
          );
          context.go(AppRoutes.login);
        } else if (state is AuthOtpSent) {
          context.push(AppRoutes.otp, extra: {
            'phone': _completePhone,
            'fullName': _phoneNameController.text.trim(),
            'source': 'register',
          });
        } else if (state is AuthError) {
          AppSnackbar.error(context, message: state.message);
          context.read<AuthBloc>().add(const AuthResetEvent());
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.screenPaddingH,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // ── Header ──
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusXl,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: AppConstants.iconSizeLarge,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),
                Center(
                  child: Text(
                    AppStrings.createAccount,
                    style: AppTextStyles.heading1.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // ── Tab Bar ──
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceVariantDark
                        : AppColors.grey100,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    labelStyle: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    dividerHeight: 0,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Email'),
                      Tab(text: 'Phone'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Tab Content ──
                SizedBox(
                  height: 500,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildEmailTab(context),
                      _buildPhoneTab(context),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // ── Login link ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount,
                      style: AppTextStyles.body.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.login),
                      child: Text(
                        AppStrings.login,
                        style: AppTextStyles.link,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingLg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTab(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _fullNameController,
          textInputAction: TextInputAction.next,
          style: AppTextStyles.body.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: AppStrings.fullNameHint,
            prefixIcon: const Icon(Icons.person_outline,
                color: AppColors.grey400, size: AppConstants.iconSizeSmall),
            errorText: _nameError,
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          style: AppTextStyles.body.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: AppStrings.emailHint,
            prefixIcon: const Icon(Icons.email_outlined,
                color: AppColors.grey400, size: AppConstants.iconSizeSmall),
            errorText: _emailError,
          ),
        ),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setInner) => TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.next,
            style: AppTextStyles.body.copyWith(color: textColor),
            decoration: InputDecoration(
              hintText: AppStrings.passwordHint,
              prefixIcon: const Icon(Icons.lock_outline,
                  color: AppColors.grey400, size: AppConstants.iconSizeSmall),
              errorText: _passwordError,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.grey400,
                  size: AppConstants.iconSizeSmall,
                ),
                onPressed: () =>
                    setInner(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        StatefulBuilder(
          builder: (ctx, setInner) => TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            textInputAction: TextInputAction.done,
            style: AppTextStyles.body.copyWith(color: textColor),
            decoration: InputDecoration(
              hintText: AppStrings.confirmPasswordHint,
              prefixIcon: const Icon(Icons.lock_outline,
                  color: AppColors.grey400, size: AppConstants.iconSizeSmall),
              errorText: _confirmError,
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.grey400,
                  size: AppConstants.iconSizeSmall,
                ),
                onPressed: () => setInner(() =>
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return CustomButton(
              label: AppStrings.createAccount,
              isLoading: state is AuthLoading,
              onTap: () {
                if (_validateEmailForm()) {
                  context.read<AuthBloc>().add(RegisterWithEmailEvent(
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                        fullName: _fullNameController.text.trim(),
                      ));
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPhoneTab(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _phoneNameController,
          textInputAction: TextInputAction.next,
          style: AppTextStyles.body.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: AppStrings.fullNameHint,
            prefixIcon: const Icon(Icons.person_outline,
                color: AppColors.grey400, size: AppConstants.iconSizeSmall),
          ),
        ),
        const SizedBox(height: 14),
        IntlPhoneField(
          decoration: InputDecoration(
            hintText: AppStrings.phoneNumber,
            counterText: '',
          ),
          initialCountryCode: 'IN',
          style: AppTextStyles.body.copyWith(color: textColor),
          onChanged: (phone) => _completePhone = phone.completeNumber,
        ),
        const SizedBox(height: AppConstants.spacingLg),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return CustomButton(
              label: AppStrings.sendOtp,
              isLoading: state is AuthLoading,
              onTap: () {
                context.read<AuthBloc>().add(SendOtpEvent(
                      phone: _completePhone,
                      fullName: _phoneNameController.text.trim(),
                    ));
              },
            );
          },
        ),
      ],
    );
  }
}
