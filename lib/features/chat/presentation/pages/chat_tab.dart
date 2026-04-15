import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../injection.dart';
import '../bloc/chat_bloc.dart';

/// Chat tab — real-time group chat for room members.
class ChatTab extends StatefulWidget {
  final String roomId;
  final String roomName;

  const ChatTab({super.key, required this.roomId, required this.roomName});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> with TickerProviderStateMixin {
  late final ChatBloc _chatBloc;
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  final String _currentUserId =
      Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();
    _chatBloc = sl<ChatBloc>()..add(LoadMessages(widget.roomId));
  }

  @override
  void dispose() {
    _chatBloc.add(DisposeChat(widget.roomId));
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (animated) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        } else {
          _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _chatBloc.add(SendMessage(roomId: widget.roomId, message: text));
    _messageController.clear();
    _focusNode.requestFocus();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatBloc,
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded) {
            if (state.sendError != null) {
              AppSnackbar.error(context, message: state.sendError!);
            }
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Messages area
              Expanded(child: _buildMessageArea(context, state)),
              // Input area
              _buildInputArea(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageArea(BuildContext context, ChatState state) {
    if (state is ChatLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading messages...',
              style: AppTextStyles.caption.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    if (state is ChatError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: AppColors.error.withValues(alpha: 0.7)),
              const SizedBox(height: 12),
              Text(
                state.message,
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () =>
                    _chatBloc.add(LoadMessages(widget.roomId)),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is ChatLoaded) {
      if (state.messages.isEmpty) {
        return _buildEmptyChat(context);
      }
      return _buildMessageList(context, state.messages);
    }

    return const SizedBox.shrink();
  }

  Widget _buildEmptyChat(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 40,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No messages yet',
              style: AppTextStyles.heading3.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to say hello! 👋',
              style: AppTextStyles.body.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(
      BuildContext context, List<Map<String, dynamic>> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final prevMsg = index > 0 ? messages[index - 1] : null;
        final isMe = msg['sender_id'] == _currentUserId;
        final isOptimistic = msg['_optimistic'] == true;

        // Check if we should show sender name / date header
        final showSenderName = !isMe &&
            (prevMsg == null || prevMsg['sender_id'] != msg['sender_id']);
        final showDateHeader = _shouldShowDateHeader(msg, prevMsg);

        return Column(
          children: [
            if (showDateHeader) _buildDateHeader(context, msg),
            _MessageBubble(
              key: ValueKey(msg['id']),
              message: msg,
              isMe: isMe,
              isOptimistic: isOptimistic,
              showSenderName: showSenderName,
              showTail: _shouldShowTail(messages, index),
            ),
          ],
        );
      },
    );
  }

  bool _shouldShowDateHeader(
      Map<String, dynamic> msg, Map<String, dynamic>? prevMsg) {
    if (prevMsg == null) return true;
    final msgDate = DateTime.tryParse(msg['created_at'] ?? '');
    final prevDate = DateTime.tryParse(prevMsg['created_at'] ?? '');
    if (msgDate == null || prevDate == null) return false;
    return msgDate.day != prevDate.day ||
        msgDate.month != prevDate.month ||
        msgDate.year != prevDate.year;
  }

  bool _shouldShowTail(List<Map<String, dynamic>> messages, int index) {
    if (index == messages.length - 1) return true;
    final next = messages[index + 1];
    return next['sender_id'] != messages[index]['sender_id'];
  }

  Widget _buildDateHeader(BuildContext context, Map<String, dynamic> msg) {
    final date = DateTime.tryParse(msg['created_at'] ?? '')?.toLocal();
    String label = 'Today';
    if (date != null) {
      final now = DateTime.now();
      if (date.day == now.day &&
          date.month == now.month &&
          date.year == now.year) {
        label = 'Today';
      } else if (date.day == now.day - 1 &&
          date.month == now.month &&
          date.year == now.year) {
        label = 'Yesterday';
      } else {
        label =
            '${date.day}/${date.month}/${date.year}';
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.45),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, ChatState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSending =
        state is ChatLoaded && state.isSending;

    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.dividerLight,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.inputFillDark
                    : AppColors.inputFillLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                maxLines: 5,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: AppTextStyles.body.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 6),

          // Send button
          AnimatedContainer(
            duration: AppConstants.animFast,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: isSending ? null : _sendMessage,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isSending
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Message Bubble Widget
// ═══════════════════════════════════════════════════════════════

class _MessageBubble extends StatefulWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final bool isOptimistic;
  final bool showSenderName;
  final bool showTail;

  const _MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.isOptimistic,
    required this.showSenderName,
    required this.showTail,
  });

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: Offset(widget.isMe ? 0.3 : -0.3, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = widget.message['message'] as String? ?? '';
    final senderName = widget.message['sender_name'] as String? ?? '';
    final createdAt =
        DateTime.tryParse(widget.message['created_at'] ?? '')?.toLocal();
    final timeStr = createdAt != null
        ? '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}'
        : '';

    // Color palette per sender for non-me bubbles
    final senderColor = _getSenderColor(widget.message['sender_id'] ?? '');

    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          alignment:
              widget.isMe ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(
              top: widget.showSenderName ? 8 : 2,
              bottom: widget.showTail ? 4 : 0,
            ),
            child: Row(
              mainAxisAlignment: widget.isMe
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Avatar for other users
                if (!widget.isMe && widget.showTail)
                  _buildAvatar(senderName, senderColor)
                else if (!widget.isMe)
                  const SizedBox(width: 32),

                const SizedBox(width: 6),

                Flexible(
                  child: Column(
                    crossAxisAlignment: widget.isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (widget.showSenderName && !widget.isMe)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, bottom: 3),
                          child: Text(
                            senderName,
                            style: AppTextStyles.caption.copyWith(
                              color: senderColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      // Bubble
                      Container(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width * 0.72,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isMe
                              ? AppColors.primary
                              : isDark
                                  ? AppColors.surfaceVariantDark
                                  : const Color(0xFFF0F1F5),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(
                              widget.isMe || !widget.showTail ? 18 : 4,
                            ),
                            bottomRight: Radius.circular(
                              !widget.isMe || !widget.showTail ? 18 : 4,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              text,
                              style: AppTextStyles.body.copyWith(
                                color: widget.isMe
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                                fontSize: 15,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  timeStr,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: widget.isMe
                                        ? Colors.white.withValues(alpha: 0.7)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.35),
                                  ),
                                ),
                                if (widget.isMe) ...[
                                  const SizedBox(width: 3),
                                  Icon(
                                    widget.isOptimistic
                                        ? Icons.access_time_rounded
                                        : Icons.done_all_rounded,
                                    size: 13,
                                    color:
                                        Colors.white.withValues(alpha: 0.7),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (widget.isMe) const SizedBox(width: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String name, Color color) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }

  Color _getSenderColor(String senderId) {
    final colors = [
      const Color(0xFF6C5CE7),
      const Color(0xFF00B894),
      const Color(0xFFE17055),
      const Color(0xFF0984E3),
      const Color(0xFFFD79A8),
      const Color(0xFFE84393),
      const Color(0xFF00CEC9),
      const Color(0xFFFF7675),
    ];
    final hash = senderId.hashCode.abs();
    return colors[hash % colors.length];
  }
}
