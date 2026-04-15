import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/poll_repository.dart';
import '../datasources/poll_remote_datasource.dart';

/// Implementation of [PollRepository] — bridges domain and data layers.
class PollRepositoryImpl implements PollRepository {
  final PollRemoteDatasource _datasource;

  PollRepositoryImpl(this._datasource);

  @override
  Future<({bool success, List<Map<String, dynamic>> polls, String? error})>
      getRoomPolls(String roomId) async {
    try {
      final polls = await _datasource.getRoomPolls(roomId);
      return (success: true, polls: polls, error: null);
    } catch (e, st) {
      AppLogger.e('PollRepository.getRoomPolls failed', error: e, stackTrace: st);
      return (success: false, polls: <Map<String, dynamic>>[], error: _friendlyError(e.toString()));
    }
  }

  @override
  Future<({bool success, String? pollId, String? error})> createPoll({
    required String roomId,
    required String question,
    required List<String> options,
    String pollType = 'single',
    bool isAnonymous = false,
    DateTime? expiresAt,
  }) async {
    try {
      final result = await _datasource.createPoll(
        roomId: roomId,
        question: question,
        options: options,
        pollType: pollType,
        isAnonymous: isAnonymous,
        expiresAt: expiresAt,
      );
      return (success: true, pollId: result['id'] as String?, error: null);
    } catch (e, st) {
      AppLogger.e('PollRepository.createPoll failed', error: e, stackTrace: st);
      return (success: false, pollId: null, error: _friendlyError(e.toString()));
    }
  }

  @override
  Future<({bool success, String? error})> voteOnPoll({
    required String pollId,
    required String optionId,
  }) async {
    try {
      await _datasource.voteOnPoll(pollId: pollId, optionId: optionId);
      return (success: true, error: null);
    } catch (e, st) {
      AppLogger.e('PollRepository.voteOnPoll failed', error: e, stackTrace: st);
      return (success: false, error: _friendlyError(e.toString()));
    }
  }

  @override
  Future<({bool success, String? error})> removeVote({
    required String pollId,
    required String optionId,
  }) async {
    try {
      await _datasource.removeVote(pollId: pollId, optionId: optionId);
      return (success: true, error: null);
    } catch (e, st) {
      AppLogger.e('PollRepository.removeVote failed', error: e, stackTrace: st);
      return (success: false, error: _friendlyError(e.toString()));
    }
  }

  @override
  Future<({bool success, Map<String, dynamic>? poll, String? error})>
      getPollWithResults(String pollId) async {
    try {
      final poll = await _datasource.getPollWithResults(pollId);
      return (success: true, poll: poll, error: null);
    } catch (e, st) {
      AppLogger.e('PollRepository.getPollWithResults failed', error: e, stackTrace: st);
      return (success: false, poll: null, error: _friendlyError(e.toString()));
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
