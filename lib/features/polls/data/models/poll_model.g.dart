// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PollModel _$PollModelFromJson(Map<String, dynamic> json) => _PollModel(
  id: json['id'] as String,
  roomId: json['room_id'] as String,
  createdBy: json['created_by'] as String,
  question: json['question'] as String,
  pollType: json['poll_type'] as String? ?? 'single',
  isAnonymous: json['is_anonymous'] as bool? ?? false,
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => PollOptionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PollModelToJson(_PollModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'created_by': instance.createdBy,
      'question': instance.question,
      'poll_type': instance.pollType,
      'is_anonymous': instance.isAnonymous,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'options': instance.options,
    };

_PollOptionModel _$PollOptionModelFromJson(Map<String, dynamic> json) =>
    _PollOptionModel(
      id: json['id'] as String,
      pollId: json['poll_id'] as String,
      text: json['text'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      voteCount: (json['voteCount'] as num?)?.toInt() ?? 0,
      voterIds:
          (json['voterIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PollOptionModelToJson(_PollOptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poll_id': instance.pollId,
      'text': instance.text,
      'sort_order': instance.sortOrder,
      'voteCount': instance.voteCount,
      'voterIds': instance.voterIds,
    };
