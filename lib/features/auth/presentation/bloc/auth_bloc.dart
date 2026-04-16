import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/register_with_email.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/verify_otp.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for all authentication flows.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail _loginWithEmail;
  final RegisterWithEmail _registerWithEmail;
  final SendOtp _sendOtp;
  final VerifyOtp _verifyOtp;

  AuthBloc({
    required LoginWithEmail loginWithEmail,
    required RegisterWithEmail registerWithEmail,
    required SendOtp sendOtp,
    required VerifyOtp verifyOtp,
  }) : _loginWithEmail = loginWithEmail,
       _registerWithEmail = registerWithEmail,
       _sendOtp = sendOtp,
       _verifyOtp = verifyOtp,
       super(const AuthInitial()) {
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<AuthResetEvent>(_onReset);
  }

  Future<void> _onLoginWithEmail(
    LoginWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.bloc('AuthBloc', 'LoginWithEmail → ${event.email}');
    emit(const AuthLoading());

    final result = await _loginWithEmail(
      email: event.email,
      password: event.password,
    );

    if (result.success) {
      AppLogger.i('Login success for ${event.email}');
      emit(const AuthLoginSuccess());
    } else {
      AppLogger.w('Login failed: ${result.error}');
      emit(AuthError(result.error ?? 'Login failed.'));
    }
  }

  Future<void> _onRegisterWithEmail(
    RegisterWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.bloc('AuthBloc', 'RegisterWithEmail → ${event.email}');
    emit(const AuthLoading());

    final result = await _registerWithEmail(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
    );

    if (result.success) {
      if (result.emailConfirmRequired) {
        AppLogger.i('Registration success — email confirm required');
        emit(AuthEmailConfirmRequired(event.email));
      } else {
        AppLogger.i('Registration success — session available');
        emit(const AuthRegisterSuccess());
      }
    } else {
      AppLogger.w('Registration failed: ${result.error}');
      emit(AuthError(result.error ?? 'Registration failed.'));
    }
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    AppLogger.bloc('AuthBloc', 'SendOtp → ${event.phone}');
    emit(const AuthLoading());

    final result = await _sendOtp(phone: event.phone, fullName: event.fullName);

    if (result.success) {
      AppLogger.i('OTP sent to ${event.phone}');
      emit(const AuthOtpSent());
    } else {
      AppLogger.w('OTP send failed: ${result.error}');
      emit(AuthError(result.error ?? 'Failed to send OTP.'));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.bloc('AuthBloc', 'VerifyOtp → ${event.phone}');
    emit(const AuthLoading());

    final result = await _verifyOtp(phone: event.phone, token: event.token);

    if (result.success) {
      AppLogger.i('OTP verified for ${event.phone}');
      emit(const AuthOtpVerified());
    } else {
      AppLogger.w('OTP verify failed: ${result.error}');
      emit(AuthError(result.error ?? 'OTP verification failed.'));
    }
  }

  void _onReset(AuthResetEvent event, Emitter<AuthState> emit) {
    emit(const AuthInitial());
  }
}
