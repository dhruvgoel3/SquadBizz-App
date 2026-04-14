import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_remote_datasource.dart';

/// Implementation of [RoomRepository] — bridges domain and data layers.
class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDatasource _datasource;

  RoomRepositoryImpl(this._datasource);

  @override
  Future<({bool success, List<Map<String, dynamic>> rooms, String? error})>
      getUserRooms() async {
    try {
      final rooms = await _datasource.getUserRooms();
      return (success: true, rooms: rooms, error: null);
    } catch (e, st) {
      AppLogger.e('RoomRepository.getUserRooms failed', error: e, stackTrace: st);
      return (success: false, rooms: <Map<String, dynamic>>[], error: _friendlyError(e.toString()));
    }
  }

  @override
  Future<({bool success, String? roomId, String? roomCode, String? error})>
      createRoom({
    required String name,
    String? description,
    required String emoji,
  }) async {
    try {
      final result = await _datasource.createRoom(
        name: name,
        description: description,
        emoji: emoji,
      );

      return (
        success: true,
        roomId: result['id'] as String?,
        roomCode: result['room_code'] as String?,
        error: null,
      );
    } catch (e, st) {
      AppLogger.e('RoomRepository.createRoom failed', error: e, stackTrace: st);
      return (success: false, roomId: null, roomCode: null, error: _friendlyError(e.toString()));
    }
  }

  @override
  String get currentUserFirstName => _datasource.currentUserFirstName;

  String _friendlyError(String raw) {
    if (raw.contains('network') || raw.contains('SocketException')) {
      return 'Please check your internet connection.';
    }
    if (raw.contains('duplicate') || raw.contains('unique')) {
      return 'A room with this code already exists. Please try again.';
    }
    final cleaned = raw.replaceAll(RegExp(r'^.*?:\s*'), '');
    return cleaned.isNotEmpty ? cleaned : 'Something went wrong.';
  }
}
