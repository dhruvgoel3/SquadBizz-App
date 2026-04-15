import 'dart:async';

import '../../../../core/utils/app_logger.dart';
import '../datasources/chat_remote_datasource.dart';

/// Repository for chat operations.
class ChatRepository {
  final ChatRemoteDatasource _datasource;

  ChatRepository(this._datasource);

  Future<({bool success, List<Map<String, dynamic>> messages, String? error})>
      getMessages({required String roomId, int limit = 50}) async {
    try {
      final messages =
          await _datasource.getMessages(roomId: roomId, limit: limit);
      return (success: true, messages: messages, error: null);
    } catch (e, st) {
      AppLogger.e('ChatRepository.getMessages failed', error: e, stackTrace: st);
      return (
        success: false,
        messages: <Map<String, dynamic>>[],
        error: _friendlyError(e.toString()),
      );
    }
  }

  Future<({bool success, Map<String, dynamic>? message, String? error})>
      sendMessage({required String roomId, required String message}) async {
    try {
      final result = await _datasource.sendMessage(
        roomId: roomId,
        message: message,
      );
      return (success: true, message: result, error: null);
    } catch (e, st) {
      AppLogger.e('ChatRepository.sendMessage failed', error: e, stackTrace: st);
      return (success: false, message: null, error: _friendlyError(e.toString()));
    }
  }

  StreamSubscription<List<Map<String, dynamic>>> subscribeToMessages({
    required String roomId,
    required void Function(Map<String, dynamic>) onNewMessage,
  }) {
    return _datasource.subscribeToMessages(
      roomId: roomId,
      onNewMessage: onNewMessage,
    );
  }

  void unsubscribe(String roomId) => _datasource.unsubscribe(roomId);

  String _friendlyError(String raw) {
    if (raw.contains('network') || raw.contains('SocketException')) {
      return 'Please check your internet connection.';
    }
    final cleaned = raw.replaceAll(RegExp(r'^.*?:\s*'), '');
    return cleaned.isNotEmpty ? cleaned : 'Something went wrong.';
  }
}
