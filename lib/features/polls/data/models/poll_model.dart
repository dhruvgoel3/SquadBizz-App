import 'package:freezed_annotation/freezed_annotation.dart';

part 'poll_model.freezed.dart';
part 'poll_model.g.dart';

/// Immutable poll model with JSON serialization.
@freezed
abstract class PollModel with _$PollModel {
  const factory PollModel({
    required String id,
    @JsonKey(name: 'room_id') required String roomId,
    @JsonKey(name: 'created_by') required String createdBy,
    required String question,
    @JsonKey(name: 'poll_type') @Default('single') String pollType,
    @JsonKey(name: 'is_anonymous') @Default(false) bool isAnonymous,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @Default([]) List<PollOptionModel> options,
  }) = _PollModel;

  factory PollModel.fromJson(Map<String, dynamic> json) =>
      _$PollModelFromJson(json);
}

/// A single option within a poll.
@freezed
abstract class PollOptionModel with _$PollOptionModel {
  const factory PollOptionModel({
    required String id,
    @JsonKey(name: 'poll_id') required String pollId,
    required String text,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @Default(0) int voteCount,
    @Default([]) List<String> voterIds,
  }) = _PollOptionModel;

  factory PollOptionModel.fromJson(Map<String, dynamic> json) =>
      _$PollOptionModelFromJson(json);
}
