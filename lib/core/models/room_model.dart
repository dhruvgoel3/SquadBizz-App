/// Data model for the `rooms` table in Supabase.
class RoomModel {
  final String id;
  final String name;
  final String? description;
  final String emoji;
  final String roomCode;
  final String createdBy;
  final DateTime createdAt;
  final int memberCount;

  const RoomModel({
    required this.id,
    required this.name,
    this.description,
    this.emoji = '👥',
    required this.roomCode,
    required this.createdBy,
    required this.createdAt,
    this.memberCount = 0,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      emoji: json['emoji'] as String? ?? '👥',
      roomCode: json['room_code'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      memberCount: json['member_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'emoji': emoji,
      'room_code': roomCode,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// For inserting new rooms (no id/created_at — Supabase generates them).
  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      'description': description,
      'emoji': emoji,
      'room_code': roomCode,
      'created_by': createdBy,
    };
  }

  RoomModel copyWith({
    String? id,
    String? name,
    String? description,
    String? emoji,
    String? roomCode,
    String? createdBy,
    DateTime? createdAt,
    int? memberCount,
  }) {
    return RoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      roomCode: roomCode ?? this.roomCode,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      memberCount: memberCount ?? this.memberCount,
    );
  }
}
