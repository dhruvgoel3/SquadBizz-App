import '../repositories/auth_repository.dart';

/// Use case: Verify OTP.
class VerifyOtp {
  final AuthRepository _repository;
  VerifyOtp(this._repository);

  Future<({bool success, String? error})> call({
    required String phone,
    required String token,
  }) {
    return _repository.verifyOtp(phone: phone, token: token);
  }
}
