import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Immutable user model for the auth feature.
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
