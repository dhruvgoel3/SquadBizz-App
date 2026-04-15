/// Abstract contract for expense repository.
abstract class ExpenseRepository {
  Future<({bool success, List<Map<String, dynamic>> expenses, String? error})>
      getRoomExpenses(String roomId);

  Future<({bool success, String? expenseId, String? error})> createExpense({
    required String roomId,
    required String title,
    required double amount,
    String? note,
    required List<String> participantUserIds,
  });

  Future<({bool success, String? error})> markAsPaid(String participantId);

  Future<({bool success, List<Map<String, dynamic>> members, String? error})>
      getRoomMembers(String roomId);
}
