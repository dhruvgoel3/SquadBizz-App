import '../repositories/expense_repository.dart';

/// Use case: Fetch all members for a room.
class GetRoomMembers {
  final ExpenseRepository _repository;
  GetRoomMembers(this._repository);

  Future<({bool success, List<Map<String, dynamic>> members, String? error})> call(
          String roomId) =>
      _repository.getRoomMembers(roomId);
}
