import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/app_logger.dart';

/// Remote data source for room operations.
abstract class RoomRemoteDatasource {
  Future<List<Map<String, dynamic>>> getUserRooms();
  Future<Map<String, dynamic>> createRoom({
    required String name,
    String? description,
    required String emoji,
  });
  String get currentUserFirstName;
}

/// Implementation using Supabase client.
class RoomRemoteDatasourceImpl implements RoomRemoteDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<Map<String, dynamic>>> getUserRooms() async {
    final userId = _client.auth.currentUser!.id;
    AppLogger.api('GET', 'rooms?user=$userId');

    // 1. Get room IDs from membership
    final memberships = await _client
        .from('room_members')
        .select('room_id')
        .eq('user_id', userId);

    final roomIds =
        (memberships as List).map((m) => m['room_id'] as String).toList();

    if (roomIds.isEmpty) {
      AppLogger.i('No rooms found for user $userId');
      return [];
    }

    // 2. Fetch rooms
    final rooms = await _client
        .from('rooms')
        .select()
        .inFilter('id', roomIds)
        .order('created_at', ascending: false);

    AppLogger.i('Fetched ${(rooms as List).length} rooms');
    return rooms.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> createRoom({
    required String name,
    String? description,
    required String emoji,
  }) async {
    final userId = _client.auth.currentUser!.id;
    AppLogger.api('POST', 'rooms/create → $name');

    // Generate a unique 6-char room code
    final code = _generateRoomCode();

    // Insert room
    final result = await _client
        .from('rooms')
        .insert({
          'name': name,
          'description': description,
          'emoji': emoji,
          'room_code': code,
          'created_by': userId,
        })
        .select()
        .single();

    // Add creator as member
    await _client.from('room_members').insert({
      'room_id': result['id'],
      'user_id': userId,
      'role': 'admin',
    });

    AppLogger.i('Room created: ${result['id']} (code: $code)');
    return result;
  }

  @override
  String get currentUserFirstName {
    final name = _client.auth.currentUser?.userMetadata?['full_name'] as String?;
    if (name == null || name.isEmpty) return '';
    return name.split(' ').first;
  }

  String _generateRoomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = DateTime.now().microsecondsSinceEpoch;
    return List.generate(6, (i) => chars[(rand + i * 7) % chars.length]).join();
  }
}
