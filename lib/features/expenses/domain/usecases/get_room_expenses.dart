import '../repositories/expense_repository.dart';

/// Use case: Fetch all expenses for a room.
class GetRoomExpenses {
  final ExpenseRepository _repository;
  GetRoomExpenses(this._repository);

  Future<({bool success, List<Map<String, dynamic>> expenses, String? error})>
      call(String roomId) => _repository.getRoomExpenses(roomId);
}
