import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/app_logger.dart';

/// Remote data source for poll operations.
abstract class PollRemoteDatasource {
  Future<List<Map<String, dynamic>>> getRoomPolls(String roomId);
  Future<Map<String, dynamic>> createPoll({
    required String roomId,
    required String question,
    required List<String> options,
    String pollType = 'single',
    bool isAnonymous = false,
    DateTime? expiresAt,
  });
  Future<void> voteOnPoll({
    required String pollId,
    required String optionId,
  });
  Future<void> removeVote({
    required String pollId,
    required String optionId,
  });
  Future<Map<String, dynamic>> getPollWithResults(String pollId);
}

/// Supabase implementation.
class PollRemoteDatasourceImpl implements PollRemoteDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<Map<String, dynamic>>> getRoomPolls(String roomId) async {
    AppLogger.api('GET', 'polls?room=$roomId');

    final polls = await _client
        .from('polls')
        .select()
        .eq('room_id', roomId)
        .order('created_at', ascending: false);

    final result = <Map<String, dynamic>>[];

    for (final poll in (polls as List)) {
      final pollId = poll['id'] as String;

      // Fetch options with vote counts
      final options = await _client
          .from('poll_options')
          .select()
          .eq('poll_id', pollId)
          .order('sort_order');

      final enrichedOptions = <Map<String, dynamic>>[];
      for (final opt in (options as List)) {
        final votes = await _client
            .from('poll_votes')
            .select('user_id')
            .eq('poll_option_id', opt['id']);

        enrichedOptions.add({
          ...opt,
          'voteCount': (votes as List).length,
          'voterIds': votes.map((v) => v['user_id']).toList(),
        });
      }

      result.add({
        ...poll,
        'options': enrichedOptions,
      });
    }

    AppLogger.i('Fetched ${result.length} polls for room $roomId');
    return result;
  }

  @override
  Future<Map<String, dynamic>> createPoll({
    required String roomId,
    required String question,
    required List<String> options,
    String pollType = 'single',
    bool isAnonymous = false,
    DateTime? expiresAt,
  }) async {
    final userId = _client.auth.currentUser!.id;
    AppLogger.api('POST', 'polls/create → $question');

    // 1. Insert poll
    final poll = await _client
        .from('polls')
        .insert({
          'room_id': roomId,
          'created_by': userId,
          'question': question,
          'poll_type': pollType,
          'is_anonymous': isAnonymous,
          'expires_at': expiresAt?.toIso8601String(),
        })
        .select()
        .single();

    // 2. Insert options
    final pollId = poll['id'] as String;
    for (var i = 0; i < options.length; i++) {
      await _client.from('poll_options').insert({
        'poll_id': pollId,
        'text': options[i],
        'sort_order': i,
      });
    }

    AppLogger.i('Poll created: $pollId');
    return poll;
  }

  @override
  Future<void> voteOnPoll({
    required String pollId,
    required String optionId,
  }) async {
    final userId = _client.auth.currentUser!.id;
    AppLogger.api('POST', 'poll_votes → poll=$pollId option=$optionId');

    // For single-choice polls, remove existing vote first
    final poll = await _client
        .from('polls')
        .select('poll_type')
        .eq('id', pollId)
        .single();

    if (poll['poll_type'] == 'single') {
      await _client
          .from('poll_votes')
          .delete()
          .eq('poll_id', pollId)
          .eq('user_id', userId);
    }

    await _client.from('poll_votes').insert({
      'poll_id': pollId,
      'poll_option_id': optionId,
      'user_id': userId,
    });

    AppLogger.i('Vote cast on poll $pollId');
  }

  @override
  Future<void> removeVote({
    required String pollId,
    required String optionId,
  }) async {
    final userId = _client.auth.currentUser!.id;
    AppLogger.api('DELETE', 'poll_votes → poll=$pollId option=$optionId');

    await _client
        .from('poll_votes')
        .delete()
        .eq('poll_id', pollId)
        .eq('poll_option_id', optionId)
        .eq('user_id', userId);
  }

  @override
  Future<Map<String, dynamic>> getPollWithResults(String pollId) async {
    AppLogger.api('GET', 'polls/$pollId');

    final poll = await _client
        .from('polls')
        .select()
        .eq('id', pollId)
        .single();

    final options = await _client
        .from('poll_options')
        .select()
        .eq('poll_id', pollId)
        .order('sort_order');

    final enrichedOptions = <Map<String, dynamic>>[];
    for (final opt in (options as List)) {
      final votes = await _client
          .from('poll_votes')
          .select('user_id')
          .eq('poll_option_id', opt['id']);

      enrichedOptions.add({
        ...opt,
        'voteCount': (votes as List).length,
        'voterIds': votes.map((v) => v['user_id']).toList(),
      });
    }

    return {
      ...poll,
      'options': enrichedOptions,
    };
  }
}
