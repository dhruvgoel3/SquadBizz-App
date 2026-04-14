/// Abstract interface for authentication operations.
///
/// The domain layer depends on this — the data layer implements it.
abstract class AuthRepository {
  Future<({bool success, String? error, bool emailConfirmRequired})>
      registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  });

  Future<({bool success, String? error})> loginWithEmail({
    required String email,
    required String password,
  });

  Future<({bool success, String? error})> sendOtp({
    required String phone,
    String? fullName,
  });

  Future<({bool success, String? error})> verifyOtp({
    required String phone,
    required String token,
  });

  Future<void> signOut();

  Future<({bool success, String? error})> resetPassword(String email);

  bool get isLoggedIn;
}
