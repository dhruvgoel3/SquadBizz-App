import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/app_logger.dart';

/// Remote data source for chat operations with real-time support.
abstract class ChatRemoteDatasource {
  /// Fetch recent messages for a room (paginated).
  Future<List<Map<String, dynamic>>> getMessages({
    required String roomId,
    int limit = 50,
    String? beforeId,
  });

  /// Send a text message to a room.
  Future<Map<String, dynamic>> sendMessage({
    required String roomId,
    required String message,
  });

  /// Subscribe to new messages in a room (real-time).
  StreamSubscription<List<Map<String, dynamic>>> subscribeToMessages({
    required String roomId,
    required void Function(Map<String, dynamic> newMessage) onNewMessage,
  });

  /// Unsubscribe from real-time updates.
  void unsubscribe(String roomId);
}

/// Supabase implementation with real-time channel subscriptions.
class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final SupabaseClient _client = Supabase.instance.client;
  final Map<String, RealtimeChannel> _channels = {};

  @override
  Future<List<Map<String, dynamic>>> getMessages({
    required String roomId,
    int limit = 50,
    String? beforeId,
  }) async {
    AppLogger.api('GET', 'chat_messages?room=$roomId&limit=$limit');

    var query = _client
        .from('chat_messages')
        .select()
        .eq('room_id', roomId)
        .order('created_at', ascending: false)
        .limit(limit);

    final result = await query;
    final messages = (result as List).cast<Map<String, dynamic>>();

    AppLogger.i('Fetched ${messages.length} messages for room $roomId');
    // Return in chronological order (oldest first)
    return messages.reversed.toList();
  }

  @override
  Future<Map<String, dynamic>> sendMessage({
    required String roomId,
    required String message,
  }) async {
    final user = _client.auth.currentUser!;
    final senderName =
        user.userMetadata?['full_name'] as String? ?? 'Unknown';

    AppLogger.api('POST', 'chat_messages/send');

    final result = await _client
        .from('chat_messages')
        .insert({
          'room_id': roomId,
          'sender_id': user.id,
          'sender_name': senderName,
          'message': message.trim(),
          'message_type': 'text',
        })
        .select()
        .single();

    AppLogger.i('Message sent in room $roomId');
    return result;
  }

  @override
  StreamSubscription<List<Map<String, dynamic>>> subscribeToMessages({
    required String roomId,
    required void Function(Map<String, dynamic> newMessage) onNewMessage,
  }) {
    AppLogger.i('Subscribing to chat realtime: $roomId');

    // Remove existing channel if any
    unsubscribe(roomId);

    final channel = _client.channel('chat:$roomId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'room_id',
            value: roomId,
          ),
          callback: (payload) {
            AppLogger.i('Realtime: new message in room $roomId');
            final newRecord = payload.newRecord;
            onNewMessage(newRecord);
          },
        )
        .subscribe();

    _channels[roomId] = channel;

    // Return a dummy StreamSubscription (channel manages its own lifecycle)
    final controller = StreamController<List<Map<String, dynamic>>>();
    return controller.stream.listen((_) {});
  }

  @override
  void unsubscribe(String roomId) {
    final existing = _channels.remove(roomId);
    if (existing != null) {
      AppLogger.i('Unsubscribing from chat realtime: $roomId');
      _client.removeChannel(existing);
    }
  }
}
