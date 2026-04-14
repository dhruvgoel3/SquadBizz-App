import '../repositories/room_repository.dart';

class CreateRoom {
  final RoomRepository _repository;
  CreateRoom(this._repository);

  Future<({bool success, String? roomId, String? roomCode, String? error})> call({
    required String name,
    String? description,
    required String emoji,
  }) {
    return _repository.createRoom(
      name: name,
      description: description,
      emoji: emoji,
    );
  }
}
