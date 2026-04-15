import '../repositories/poll_repository.dart';

/// Use case: Create a new poll in a room.
class CreatePoll {
  final PollRepository _repository;
  CreatePoll(this._repository);

  Future<({bool success, String? pollId, String? error})> call({
    required String roomId,
    required String question,
    required List<String> options,
    String pollType = 'single',
    bool isAnonymous = false,
    DateTime? expiresAt,
  }) =>
      _repository.createPoll(
        roomId: roomId,
        question: question,
        options: options,
        pollType: pollType,
        isAnonymous: isAnonymous,
        expiresAt: expiresAt,
      );
}
