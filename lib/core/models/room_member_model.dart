/// Data model for the `room_members` table in Supabase.
class RoomMemberModel {
  final String id;
  final String roomId;
  final String userId;
  final String role; // 'admin' or 'member'
  final DateTime joinedAt;

  const RoomMemberModel({
    required this.id,
    required this.roomId,
    required this.userId,
    this.role = 'member',
    required this.joinedAt,
  });

  factory RoomMemberModel.fromJson(Map<String, dynamic> json) {
    return RoomMemberModel(
      id: json['id'] as String,
      roomId: json['room_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      role: json['role'] as String? ?? 'member',
      joinedAt: DateTime.tryParse(json['joined_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'user_id': userId,
      'role': role,
      'joined_at': joinedAt.toIso8601String(),
    };
  }

  /// For inserting new memberships (no id/joined_at — Supabase generates them).
  Map<String, dynamic> toInsertJson() {
    return {
      'room_id': roomId,
      'user_id': userId,
      'role': role,
    };
  }

  RoomMemberModel copyWith({
    String? id,
    String? roomId,
    String? userId,
    String? role,
    DateTime? joinedAt,
  }) {
    return RoomMemberModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
