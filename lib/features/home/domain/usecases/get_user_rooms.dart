import '../repositories/room_repository.dart';

class GetUserRooms {
  final RoomRepository _repository;
  GetUserRooms(this._repository);

  Future<({bool success, List<Map<String, dynamic>> rooms, String? error})> call() {
    return _repository.getUserRooms();
  }
}
