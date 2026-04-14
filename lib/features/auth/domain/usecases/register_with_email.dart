import '../repositories/auth_repository.dart';

/// Use case: Register with email & password.
class RegisterWithEmail {
  final AuthRepository _repository;
  RegisterWithEmail(this._repository);

  Future<({bool success, String? error, bool emailConfirmRequired})> call({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _repository.registerWithEmail(
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}
