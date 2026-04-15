import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../injection.dart';
import '../bloc/poll_bloc.dart';

/// Polls tab — shows all polls in a room with inline voting & animated results.
class PollsTab extends StatelessWidget {
  final String roomId;
  const PollsTab({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PollBloc>()..add(LoadPollsEvent(roomId)),
      child: _PollsView(roomId: roomId),
    );
  }
}

class _PollsView extends StatelessWidget {
  final String roomId;
  const _PollsView({required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await context.push<bool>(
            AppRoutes.createPoll,
            extra: {'roomId': roomId},
          );
          if (result == true && context.mounted) {
            context.read<PollBloc>().add(RefreshPollsEvent(roomId));
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('New Poll', style: AppTextStyles.button.copyWith(color: Colors.white)),
      ),
      body: BlocConsumer<PollBloc, PollState>(
        listener: (context, state) {
          if (state is PollError) {
            AppSnackbar.error(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is PollLoading) {
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
                    'Loading polls...',
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is PollError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.error.withValues(alpha: 0.6)),
                  const SizedBox(height: 12),
                  Text(state.message, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => context.read<PollBloc>().add(LoadPollsEvent(roomId)),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PollLoaded) {
            if (state.polls.isEmpty) {
              return _buildEmptyState(context);
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PollBloc>().add(RefreshPollsEvent(roomId));
              },
              color: AppColors.primary,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.screenPaddingH,
                  AppConstants.spacingMd,
                  AppConstants.screenPaddingH,
                  100,
                ),
                itemCount: state.polls.length,
                itemBuilder: (context, index) {
                  return _PollCard(
                    key: ValueKey(state.polls[index]['id']),
                    poll: state.polls[index],
                    roomId: roomId,
                    isVoting: state.votingPollId == state.polls[index]['id'],
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
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
              child: const Icon(Icons.how_to_vote_rounded, size: 44, color: AppColors.primary),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              'No polls yet',
              style: AppTextStyles.heading3.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a poll and let the squad decide!',
              style: AppTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// ─── Individual Poll Card with animated progress bars ───
class _PollCard extends StatefulWidget {
  final Map<String, dynamic> poll;
  final String roomId;
  final bool isVoting;

  const _PollCard({
    super.key,
    required this.poll,
    required this.roomId,
    required this.isVoting,
  });

  @override
  State<_PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<_PollCard> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final question = widget.poll['question'] as String? ?? '';
    final options = (widget.poll['options'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final createdAt = widget.poll['created_at'] != null
        ? DateTime.tryParse(widget.poll['created_at'].toString())
        : null;
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final pollType = widget.poll['poll_type'] as String? ?? 'single';
    final isAnonymous = widget.poll['is_anonymous'] as bool? ?? false;

    // Calculate total votes
    int totalVotes = 0;
    for (final opt in options) {
      totalVotes += (opt['voteCount'] as int? ?? 0);
    }

    // Check if user has voted
    bool hasVoted = false;
    for (final opt in options) {
      final voterIds = (opt['voterIds'] as List?)?.cast<String>() ?? [];
      if (voterIds.contains(currentUserId)) {
        hasVoted = true;
        break;
      }
    }

    return FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic)),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.dividerLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.how_to_vote_rounded, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Poll', style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              )),
                              if (pollType == 'multi') ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('Multi', style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange.shade700,
                                  )),
                                ),
                              ],
                              if (isAnonymous) ...[
                                const SizedBox(width: 6),
                                Icon(Icons.visibility_off_outlined, size: 13,
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
                              ],
                            ],
                          ),
                          if (createdAt != null)
                            Text(
                              timeago.format(createdAt),
                              style: AppTextStyles.caption.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Vote count badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_outlined, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            '$totalVotes',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Question
                Text(
                  question,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    height: 1.3,
                  ),
                ),

                if (!hasVoted)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Tap to vote',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  ),

                const SizedBox(height: 14),

                // Options
                ...options.asMap().entries.map((entry) {
                  final opt = entry.value;
                  return _OptionRow(
                    option: opt,
                    totalVotes: totalVotes,
                    hasVoted: hasVoted,
                    currentUserId: currentUserId ?? '',
                    isDark: isDark,
                    isVoting: widget.isVoting,
                    onTap: () {
                      if (!hasVoted && !widget.isVoting) {
                        context.read<PollBloc>().add(VoteEvent(
                              roomId: widget.roomId,
                              pollId: widget.poll['id'] as String,
                              optionId: opt['id'] as String,
                            ));
                      }
                    },
                  );
                }),

                // Voted indicator
                if (hasVoted)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline_rounded,
                            size: 14, color: AppColors.success.withValues(alpha: 0.7)),
                        const SizedBox(width: 4),
                        Text(
                          'You voted',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ─── Single option row with animated progress bar ───
class _OptionRow extends StatelessWidget {
  final Map<String, dynamic> option;
  final int totalVotes;
  final bool hasVoted;
  final String currentUserId;
  final bool isDark;
  final bool isVoting;
  final VoidCallback onTap;

  const _OptionRow({
    required this.option,
    required this.totalVotes,
    required this.hasVoted,
    required this.currentUserId,
    required this.isDark,
    required this.isVoting,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = option['text'] as String? ?? '';
    final voteCount = option['voteCount'] as int? ?? 0;
    final voterIds = (option['voterIds'] as List?)?.cast<String>() ?? [];
    final isSelected = voterIds.contains(currentUserId);
    final percentage = totalVotes > 0 ? (voteCount / totalVotes) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.borderDark : AppColors.dividerLight),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Stack(
              children: [
                // Animated progress bar
                if (hasVoted)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    width: MediaQuery.of(context).size.width * percentage * 0.80,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : AppColors.grey100),
                    ),
                  ),
                // Content
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      // Selection indicator / radio
                      if (!hasVoted)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isVoting
                                    ? AppColors.grey400
                                    : AppColors.primary.withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      if (hasVoted && isSelected)
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
                        ),
                      Expanded(
                        child: Text(
                          text,
                          style: AppTextStyles.body.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (hasVoted) ...[
                        Text(
                          '$voteCount',
                          style: AppTextStyles.caption.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 38,
                          child: Text(
                            '${(percentage * 100).round()}%',
                            textAlign: TextAlign.right,
                            style: AppTextStyles.body.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                      if (isVoting)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
