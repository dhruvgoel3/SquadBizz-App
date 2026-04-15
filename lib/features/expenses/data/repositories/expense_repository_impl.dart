import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasource.dart';

/// Implementation of [ExpenseRepository].
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDatasource _datasource;

  ExpenseRepositoryImpl(this._datasource);

  @override
  Future<({bool success, List<Map<String, dynamic>> expenses, String? error})>
      getRoomExpenses(String roomId) async {
    try {
      final expenses = await _datasource.getRoomExpenses(roomId);
      return (success: true, expenses: expenses, error: null);
    } catch (e, st) {
      AppLogger.e('ExpenseRepository.getRoomExpenses failed', error: e, stackTrace: st);
      return (success: false, expenses: <Map<String, dynamic>>[], error: _friendlyError(e.toString()));
    }
  }

  @override
  Future<({bool success, String? expenseId, String? error})> createExpense({
    required String roomId,
    required String title,
    required double amount,
    String? note,
    required List<String> participantUserIds,
  }) async {
    try {
      final result = await _datasource.createExpense(
        roomId: roomId,
        title: title,
        amount: amount,
        note: note,
        participantUserIds: participantUserIds,
      );
      return (success: true, expenseId: result['id'] as String?, error: null);
    } catch (e, st) {
      AppLogger.e('ExpenseRepository.createExpense failed', error: e, stackTrace: st);
      return (success: false, expenseId: null, error: _friendlyError(e.toString()));
    }
  }

  @override
  Future<({bool success, String? error})> markAsPaid(String participantId) async {
    try {
      await _datasource.markAsPaid(participantId);
      return (success: true, error: null);
    } catch (e, st) {
      AppLogger.e('ExpenseRepository.markAsPaid failed', error: e, stackTrace: st);
      return (success: false, error: _friendlyError(e.toString()));
    }
  }

  @override
  Future<({bool success, List<Map<String, dynamic>> members, String? error})>
      getRoomMembers(String roomId) async {
    try {
      final members = await _datasource.getRoomMembers(roomId);
      return (success: true, members: members, error: null);
    } catch (e, st) {
      AppLogger.e('ExpenseRepository.getRoomMembers failed', error: e, stackTrace: st);
      return (success: false, members: <Map<String, dynamic>>[], error: _friendlyError(e.toString()));
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('network') || raw.contains('SocketException')) {
      return 'Please check your internet connection.';
    }
    final cleaned = raw.replaceAll(RegExp(r'^.*?:\s*'), '');
    return cleaned.isNotEmpty ? cleaned : 'Something went wrong.';
  }
}
