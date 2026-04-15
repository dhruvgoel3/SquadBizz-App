import '../repositories/poll_repository.dart';

/// Use case: Vote on a poll option.
class VoteOnPoll {
  final PollRepository _repository;
  VoteOnPoll(this._repository);

  Future<({bool success, String? error})> call({
    required String pollId,
    required String optionId,
  }) =>
      _repository.voteOnPoll(pollId: pollId, optionId: optionId);
}
