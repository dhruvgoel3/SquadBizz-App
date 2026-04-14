import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';

/// Immutable room model with JSON serialization.
@freezed
abstract class RoomModel with _$RoomModel {
  const factory RoomModel({
    required String id,
    required String name,
    String? description,
    @Default('👥') String emoji,
    required String roomCode,
    required String createdBy,
    DateTime? createdAt,
    @Default(1) int memberCount,
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);
}
