import '../repositories/expense_repository.dart';

/// Use case: Create a new expense in a room.
class CreateExpense {
  final ExpenseRepository _repository;
  CreateExpense(this._repository);

  Future<({bool success, String? expenseId, String? error})> call({
    required String roomId,
    required String title,
    required double amount,
    String? note,
    required List<String> participantUserIds,
  }) =>
      _repository.createExpense(
        roomId: roomId,
        title: title,
        amount: amount,
        note: note,
        participantUserIds: participantUserIds,
      );
}
