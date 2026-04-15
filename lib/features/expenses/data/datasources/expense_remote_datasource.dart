import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/app_logger.dart';

/// Remote data source for expense operations.
abstract class ExpenseRemoteDatasource {
  Future<List<Map<String, dynamic>>> getRoomExpenses(String roomId);
  Future<Map<String, dynamic>> createExpense({
    required String roomId,
    required String title,
    required double amount,
    String? note,
    required List<String> participantUserIds,
  });
  Future<void> markAsPaid(String participantId);
  Future<List<Map<String, dynamic>>> getRoomMembers(String roomId);
}

/// Supabase implementation.
class ExpenseRemoteDatasourceImpl implements ExpenseRemoteDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<Map<String, dynamic>>> getRoomExpenses(String roomId) async {
    AppLogger.api('GET', 'expenses?room=$roomId');

    final expenses = await _client
        .from('expenses')
        .select()
        .eq('room_id', roomId)
        .order('created_at', ascending: false);

    final result = <Map<String, dynamic>>[];
    for (final expense in (expenses as List)) {
      final participants = await _client
          .from('expense_participants')
          .select()
          .eq('expense_id', expense['id']);

      result.add({
        ...expense,
        'participants': participants,
      });
    }

    AppLogger.i('Fetched ${result.length} expenses for room $roomId');
    return result;
  }

  @override
  Future<Map<String, dynamic>> createExpense({
    required String roomId,
    required String title,
    required double amount,
    String? note,
    required List<String> participantUserIds,
  }) async {
    final userId = _client.auth.currentUser!.id;
    AppLogger.api('POST', 'expenses/create → $title');

    // 1. Insert expense
    final expense = await _client
        .from('expenses')
        .insert({
          'room_id': roomId,
          'created_by': userId,
          'title': title,
          'amount': amount,
          'note': note,
        })
        .select()
        .single();

    // 2. Calculate equal split
    final splitAmount = amount / participantUserIds.length;

    // 3. Insert participants
    for (final pUserId in participantUserIds) {
      await _client.from('expense_participants').insert({
        'expense_id': expense['id'],
        'user_id': pUserId,
        'amount_owed': pUserId == userId ? 0 : splitAmount, // payer owes nothing
        'is_paid': pUserId == userId, // payer is already "paid"
      });
    }

    AppLogger.i('Expense created: ${expense['id']}');
    return expense;
  }

  @override
  Future<void> markAsPaid(String participantId) async {
    AppLogger.api('PATCH', 'expense_participants/$participantId');

    await _client
        .from('expense_participants')
        .update({'is_paid': true})
        .eq('id', participantId);
  }

  @override
  Future<List<Map<String, dynamic>>> getRoomMembers(String roomId) async {
    final memberships = await _client
        .from('room_members')
        .select('user_id, role')
        .eq('room_id', roomId);

    return (memberships as List).cast<Map<String, dynamic>>();
  }
}
