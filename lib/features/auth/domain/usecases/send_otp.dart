import '../repositories/auth_repository.dart';

/// Use case: Send OTP to phone number.
class SendOtp {
  final AuthRepository _repository;
  SendOtp(this._repository);

  Future<({bool success, String? error})> call({
    required String phone,
    String? fullName,
  }) {
    return _repository.sendOtp(phone: phone, fullName: fullName);
  }
}
