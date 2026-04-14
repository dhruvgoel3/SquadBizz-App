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

/// Login page with email + phone tabs.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _completePhone = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          context.go(AppRoutes.home);
        } else if (state is AuthOtpSent) {
          context.push(AppRoutes.otp, extra: {
            'phone': _completePhone,
            'fullName': '',
            'source': 'login',
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

                // ── Logo ──
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
                      Icons.groups_rounded,
                      size: AppConstants.iconSizeLarge,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),
                Center(
                  child: Text(
                    AppStrings.login,
                    style: AppTextStyles.heading1.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Center(
                  child: Text(
                    AppStrings.loginSubtitle,
                    style: AppTextStyles.subtitle.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
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
                  height: 320,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildEmailTab(context),
                      _buildPhoneTab(context),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // ── Register link ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.dontHaveAccount,
                      style: AppTextStyles.body.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.register),
                      child: Text(
                        AppStrings.register,
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
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          style: AppTextStyles.body.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: AppStrings.emailHint,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.grey400,
              size: AppConstants.iconSizeSmall,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        StatefulBuilder(
          builder: (context, setInnerState) {
            return TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              style: AppTextStyles.body.copyWith(color: textColor),
              decoration: InputDecoration(
                hintText: AppStrings.passwordHint,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.grey400,
                  size: AppConstants.iconSizeSmall,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.grey400,
                    size: AppConstants.iconSizeSmall,
                  ),
                  onPressed: () => setInnerState(
                    () => _isPasswordVisible = !_isPasswordVisible,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppConstants.spacingSm),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(AppStrings.forgotPassword, style: AppTextStyles.link),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return CustomButton(
              label: AppStrings.login,
              isLoading: state is AuthLoading,
              onTap: () {
                context.read<AuthBloc>().add(LoginWithEmailEvent(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    ));
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPhoneTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntlPhoneField(
          decoration: InputDecoration(
            hintText: AppStrings.phoneNumber,
            counterText: '',
          ),
          initialCountryCode: 'IN',
          style: AppTextStyles.body.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
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
                    ));
              },
            );
          },
        ),
      ],
    );
  }
}
