/// Abstract contract for poll repository.
abstract class PollRepository {
  Future<({bool success, List<Map<String, dynamic>> polls, String? error})>
      getRoomPolls(String roomId);

  Future<({bool success, String? pollId, String? error})> createPoll({
    required String roomId,
    required String question,
    required List<String> options,
    String pollType = 'single',
    bool isAnonymous = false,
    DateTime? expiresAt,
  });

  Future<({bool success, String? error})> voteOnPoll({
    required String pollId,
    required String optionId,
  });

  Future<({bool success, String? error})> removeVote({
    required String pollId,
    required String optionId,
  });

  Future<({bool success, Map<String, dynamic>? poll, String? error})>
      getPollWithResults(String pollId);
}
