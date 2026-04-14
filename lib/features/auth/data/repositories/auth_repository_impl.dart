import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Concrete implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<({bool success, String? error, bool emailConfirmRequired})>
      registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _datasource.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (response.user != null) {
        final emailConfirmRequired = response.session == null;
        return (
          success: true,
          error: null,
          emailConfirmRequired: emailConfirmRequired,
        );
      }
      return (
        success: false,
        error: 'Registration failed.',
        emailConfirmRequired: false,
      );
    } catch (e) {
      return (
        success: false,
        error: _friendlyError(e.toString()),
        emailConfirmRequired: false,
      );
    }
  }

  @override
  Future<({bool success, String? error})> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _datasource.signInWithEmail(
        email: email,
        password: password,
      );
      return (success: true, error: null);
    } catch (e) {
      return (success: false, error: _friendlyError(e.toString()));
    }
  }

  @override
  Future<({bool success, String? error})> sendOtp({
    required String phone,
    String? fullName,
  }) async {
    try {
      await _datasource.sendOtp(phone: phone, fullName: fullName);
      return (success: true, error: null);
    } catch (e) {
      return (success: false, error: _friendlyError(e.toString()));
    }
  }

  @override
  Future<({bool success, String? error})> verifyOtp({
    required String phone,
    required String token,
  }) async {
    try {
      final response = await _datasource.verifyOtp(
        phone: phone,
        token: token,
      );
      if (response.session != null) {
        return (success: true, error: null);
      }
      return (success: false, error: 'Verification failed.');
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('expired')) {
        return (success: false, error: 'OTP has expired. Please request a new one.');
      }
      return (success: false, error: 'Invalid OTP. Please try again.');
    }
  }

  @override
  Future<void> signOut() async {
    await _datasource.signOut();
  }

  @override
  Future<({bool success, String? error})> resetPassword(String email) async {
    try {
      await _datasource.resetPassword(email);
      return (success: true, error: null);
    } catch (e) {
      return (success: false, error: _friendlyError(e.toString()));
    }
  }

  @override
  bool get isLoggedIn => _datasource.isLoggedIn;

  String _friendlyError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('network') || lower.contains('socketexception')) {
      return 'Please check your internet connection.';
    }
    if (lower.contains('already registered') ||
        lower.contains('already exists')) {
      return 'This email is already registered.';
    }
    if (lower.contains('invalid') || lower.contains('credentials')) {
      return 'Incorrect email or password.';
    }
    if (lower.contains('not found') || lower.contains('no user')) {
      return 'No account found. Please register first.';
    }
    if (lower.contains('rate limit') || lower.contains('too many')) {
      return 'Too many attempts. Please wait a minute.';
    }
    if (lower.contains('phone') && lower.contains('not supported')) {
      return 'Phone authentication is not enabled.';
    }
    final cleaned = raw.replaceAll(RegExp(r'^.*?:\s*'), '');
    return cleaned.isNotEmpty ? cleaned : 'Something went wrong. Please try again.';
  }
}
