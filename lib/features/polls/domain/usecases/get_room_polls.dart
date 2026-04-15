import '../repositories/poll_repository.dart';

/// Use case: Fetch all polls for a room.
class GetRoomPolls {
  final PollRepository _repository;
  GetRoomPolls(this._repository);

  Future<({bool success, List<Map<String, dynamic>> polls, String? error})>
      call(String roomId) => _repository.getRoomPolls(roomId);
}
