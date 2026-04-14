import '../repositories/auth_repository.dart';

/// Use case: Login with email & password.
class LoginWithEmail {
  final AuthRepository _repository;
  LoginWithEmail(this._repository);

  Future<({bool success, String? error})> call({
    required String email,
    required String password,
  }) {
    return _repository.loginWithEmail(email: email, password: password);
  }
}
