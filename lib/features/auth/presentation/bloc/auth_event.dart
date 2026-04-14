import 'package:equatable/equatable.dart';

/// Auth events.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Login with email + password.
class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Register with email + password.
class RegisterWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  const RegisterWithEmailEvent({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object?> get props => [email, password, fullName];
}

/// Send OTP to phone.
class SendOtpEvent extends AuthEvent {
  final String phone;
  final String? fullName;

  const SendOtpEvent({required this.phone, this.fullName});

  @override
  List<Object?> get props => [phone, fullName];
}

/// Verify OTP.
class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String token;

  const VerifyOtpEvent({required this.phone, required this.token});

  @override
  List<Object?> get props => [phone, token];
}

/// Reset to initial state.
class AuthResetEvent extends AuthEvent {
  const AuthResetEvent();
}
