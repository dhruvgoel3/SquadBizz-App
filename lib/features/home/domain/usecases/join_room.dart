import '../repositories/room_repository.dart';

/// Usecase for joining a room by code.
class JoinRoom {
  final RoomRepository _repository;

  JoinRoom(this._repository);

  Future<({bool success, String? roomId, String? error})> call(String roomCode) async {
    return await _repository.joinRoom(roomCode);
  }
}
