import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/app_logger.dart';

/// Remote data source for authentication operations.
abstract class AuthRemoteDatasource {
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  });

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> sendOtp({required String phone, String? fullName});

  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
  });

  Future<void> signOut();
  Future<void> resetPassword(String email);
  User? get currentUser;
  bool get isLoggedIn;
}

/// Implementation using Supabase client.
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    AppLogger.api('POST', 'auth/signup');
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    AppLogger.i('Auth signup response → user: ${response.user?.id}');
    return response;
  }

  @override
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    AppLogger.api('POST', 'auth/login');
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendOtp({required String phone, String? fullName}) async {
    AppLogger.api('POST', 'auth/otp/send → $phone');
    await _client.auth.signInWithOtp(
      phone: phone,
      data: fullName != null ? {'full_name': fullName} : null,
    );
  }

  @override
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
  }) async {
    AppLogger.api('POST', 'auth/otp/verify');
    return await _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  @override
  Future<void> signOut() async {
    AppLogger.api('POST', 'auth/signout');
    await _client.auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    AppLogger.api('POST', 'auth/reset-password');
    await _client.auth.resetPasswordForEmail(email);
  }

  @override
  User? get currentUser => _client.auth.currentUser;

  @override
  bool get isLoggedIn => _client.auth.currentSession != null;
}
