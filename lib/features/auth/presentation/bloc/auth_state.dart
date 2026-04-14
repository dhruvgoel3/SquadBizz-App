import 'package:equatable/equatable.dart';

/// Auth states.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial idle state.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading indicator active.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Login succeeded.
class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess();
}

/// Registration succeeded (session available).
class AuthRegisterSuccess extends AuthState {
  const AuthRegisterSuccess();
}

/// Registration succeeded but email confirmation is required.
class AuthEmailConfirmRequired extends AuthState {
  final String email;
  const AuthEmailConfirmRequired(this.email);

  @override
  List<Object?> get props => [email];
}

/// OTP sent successfully.
class AuthOtpSent extends AuthState {
  const AuthOtpSent();
}

/// OTP verified — user authenticated.
class AuthOtpVerified extends AuthState {
  const AuthOtpVerified();
}

/// Authentication error.
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
