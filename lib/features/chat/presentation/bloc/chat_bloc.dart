import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/app_logger.dart';
import '../../data/repositories/chat_repository_impl.dart';

// ═══════════════════════════════════════════════════════════════
//  Events
// ═══════════════════════════════════════════════════════════════

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatEvent {
  final String roomId;
  const LoadMessages(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

class SendMessage extends ChatEvent {
  final String roomId;
  final String message;
  const SendMessage({required this.roomId, required this.message});
  @override
  List<Object?> get props => [roomId, message];
}

class NewMessageReceived extends ChatEvent {
  final Map<String, dynamic> message;
  const NewMessageReceived(this.message);
  @override
  List<Object?> get props => [message];
}

class DisposeChat extends ChatEvent {
  final String roomId;
  const DisposeChat(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

// ═══════════════════════════════════════════════════════════════
//  States
// ═══════════════════════════════════════════════════════════════

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final List<Map<String, dynamic>> messages;
  final bool isSending;
  final String? sendError;

  const ChatLoaded({
    required this.messages,
    this.isSending = false,
    this.sendError,
  });

  ChatLoaded copyWith({
    List<Map<String, dynamic>>? messages,
    bool? isSending,
    String? sendError,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      sendError: sendError,
    );
  }

  @override
  List<Object?> get props => [messages.length, isSending, sendError];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}

// ═══════════════════════════════════════════════════════════════
//  BLoC
// ═══════════════════════════════════════════════════════════════

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;
  String? _currentRoomId;

  /// Current user ID for identifying own messages.
  final String currentUserId =
      Supabase.instance.client.auth.currentUser?.id ?? '';

  ChatBloc({required ChatRepository repository})
      : _repository = repository,
        super(const ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<NewMessageReceived>(_onNewMessage);
    on<DisposeChat>(_onDispose);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    AppLogger.bloc('ChatBloc', 'LoadMessages → ${event.roomId}');
    _currentRoomId = event.roomId;
    emit(const ChatLoading());

    final result = await _repository.getMessages(roomId: event.roomId);

    if (result.success) {
      emit(ChatLoaded(messages: result.messages));

      // Subscribe to real-time updates
      _subscription?.cancel();
      _subscription = _repository.subscribeToMessages(
        roomId: event.roomId,
        onNewMessage: (msg) {
          // Avoid duplicate if we sent it ourselves (optimistic add)
          add(NewMessageReceived(msg));
        },
      );
    } else {
      emit(ChatError(result.error ?? 'Failed to load messages'));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoaded) return;
    final current = state as ChatLoaded;

    if (event.message.trim().isEmpty) return;

    AppLogger.bloc('ChatBloc', 'SendMessage');

    // Optimistic add
    final optimisticMsg = {
      'id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
      'room_id': event.roomId,
      'sender_id': currentUserId,
      'sender_name':
          Supabase.instance.client.auth.currentUser?.userMetadata?['full_name'] ??
              'You',
      'message': event.message.trim(),
      'message_type': 'text',
      'created_at': DateTime.now().toIso8601String(),
      '_optimistic': true,
    };

    emit(current.copyWith(
      messages: [...current.messages, optimisticMsg],
      isSending: true,
    ));

    final result = await _repository.sendMessage(
      roomId: event.roomId,
      message: event.message,
    );

    if (state is! ChatLoaded) return;
    final afterSend = state as ChatLoaded;

    if (result.success) {
      // Replace optimistic message with real one
      final updated = afterSend.messages
          .where((m) => m['id'] != optimisticMsg['id'])
          .toList();
      // The real message will arrive via realtime, but add it in case
      if (!updated.any((m) => m['id'] == result.message!['id'])) {
        updated.add(result.message!);
      }
      emit(afterSend.copyWith(messages: updated, isSending: false));
    } else {
      // Remove optimistic message on error
      final updated = afterSend.messages
          .where((m) => m['id'] != optimisticMsg['id'])
          .toList();
      emit(afterSend.copyWith(
        messages: updated,
        isSending: false,
        sendError: result.error,
      ));
    }
  }

  void _onNewMessage(
    NewMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    if (state is! ChatLoaded) return;
    final current = state as ChatLoaded;

    // Avoid duplicate messages
    final msgId = event.message['id'];
    if (current.messages.any((m) => m['id'] == msgId)) return;

    // Remove any optimistic messages from same sender with same content
    final cleaned = current.messages
        .where((m) => m['_optimistic'] != true ||
            m['message'] != event.message['message'] ||
            m['sender_id'] != event.message['sender_id'])
        .toList();

    emit(current.copyWith(messages: [...cleaned, event.message]));
  }

  void _onDispose(DisposeChat event, Emitter<ChatState> emit) {
    _subscription?.cancel();
    _repository.unsubscribe(event.roomId);
    _currentRoomId = null;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    if (_currentRoomId != null) {
      _repository.unsubscribe(_currentRoomId!);
    }
    return super.close();
  }
}
