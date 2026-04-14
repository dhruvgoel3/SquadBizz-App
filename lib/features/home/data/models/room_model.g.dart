// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => _RoomModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  emoji: json['emoji'] as String? ?? '👥',
  roomCode: json['roomCode'] as String,
  createdBy: json['createdBy'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  memberCount: (json['memberCount'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$RoomModelToJson(_RoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'emoji': instance.emoji,
      'roomCode': instance.roomCode,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'memberCount': instance.memberCount,
    };
