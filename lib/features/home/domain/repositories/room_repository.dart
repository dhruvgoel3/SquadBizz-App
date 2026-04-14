/// Abstract interface for room operations.
abstract class RoomRepository {
  Future<({bool success, List<Map<String, dynamic>> rooms, String? error})>
      getUserRooms();

  Future<({bool success, String? roomId, String? roomCode, String? error})>
      createRoom({
    required String name,
    String? description,
    required String emoji,
  });

  String get currentUserFirstName;
}
