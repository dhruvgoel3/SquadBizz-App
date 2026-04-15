import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/get_room_polls.dart';
import '../../domain/usecases/create_poll.dart';
import '../../domain/usecases/vote_on_poll.dart';

// ══════════════════════════════════════════
//  EVENTS
// ══════════════════════════════════════════

abstract class PollEvent extends Equatable {
  const PollEvent();
  @override
  List<Object?> get props => [];
}

class LoadPollsEvent extends PollEvent {
  final String roomId;
  const LoadPollsEvent(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

class RefreshPollsEvent extends PollEvent {
  final String roomId;
  const RefreshPollsEvent(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

class CreatePollEvent extends PollEvent {
  final String roomId;
  final String question;
  final List<String> options;
  final String pollType;
  final bool isAnonymous;

  const CreatePollEvent({
    required this.roomId,
    required this.question,
    required this.options,
    this.pollType = 'single',
    this.isAnonymous = false,
  });

  @override
  List<Object?> get props => [roomId, question, options, pollType, isAnonymous];
}

class VoteEvent extends PollEvent {
  final String roomId;
  final String pollId;
  final String optionId;

  const VoteEvent({
    required this.roomId,
    required this.pollId,
    required this.optionId,
  });

  @override
  List<Object?> get props => [roomId, pollId, optionId];
}

// ══════════════════════════════════════════
//  STATES
// ══════════════════════════════════════════

abstract class PollState extends Equatable {
  const PollState();
  @override
  List<Object?> get props => [];
}

class PollInitial extends PollState {
  const PollInitial();
}

class PollLoading extends PollState {
  const PollLoading();
}

class PollLoaded extends PollState {
  final List<Map<String, dynamic>> polls;
  final String? votingPollId; // track which poll is being voted on
  final bool isCreating;

  const PollLoaded(this.polls, {this.votingPollId, this.isCreating = false});

  PollLoaded copyWith({
    List<Map<String, dynamic>>? polls,
    String? votingPollId,
    bool? isCreating,
  }) {
    return PollLoaded(
      polls ?? this.polls,
      votingPollId: votingPollId,
      isCreating: isCreating ?? this.isCreating,
    );
  }

  @override
  List<Object?> get props => [polls.length, votingPollId, isCreating];
}

class PollCreated extends PollState {
  const PollCreated();
}

class PollError extends PollState {
  final String message;
  const PollError(this.message);
  @override
  List<Object?> get props => [message];
}

// ══════════════════════════════════════════
//  BLOC
// ══════════════════════════════════════════

class PollBloc extends Bloc<PollEvent, PollState> {
  final GetRoomPolls getRoomPolls;
  final CreatePoll createPoll;
  final VoteOnPoll voteOnPoll;

  PollBloc({
    required this.getRoomPolls,
    required this.createPoll,
    required this.voteOnPoll,
  }) : super(const PollInitial()) {
    on<LoadPollsEvent>(_onLoadPolls);
    on<RefreshPollsEvent>(_onRefreshPolls);
    on<CreatePollEvent>(_onCreatePoll);
    on<VoteEvent>(_onVote);
  }

  Future<void> _onLoadPolls(LoadPollsEvent event, Emitter<PollState> emit) async {
    AppLogger.bloc('PollBloc', 'LoadPolls → ${event.roomId}');
    emit(const PollLoading());
    final result = await getRoomPolls(event.roomId);
    if (result.success) {
      emit(PollLoaded(result.polls));
    } else {
      emit(PollError(result.error ?? 'Failed to load polls'));
    }
  }

  Future<void> _onRefreshPolls(RefreshPollsEvent event, Emitter<PollState> emit) async {
    AppLogger.bloc('PollBloc', 'RefreshPolls → ${event.roomId}');
    final result = await getRoomPolls(event.roomId);
    if (result.success) {
      emit(PollLoaded(result.polls));
    } else {
      emit(PollError(result.error ?? 'Failed to refresh polls'));
    }
  }

  Future<void> _onCreatePoll(CreatePollEvent event, Emitter<PollState> emit) async {
    AppLogger.bloc('PollBloc', 'CreatePoll → ${event.question}');
    emit(const PollLoading());
    final result = await createPoll(
      roomId: event.roomId,
      question: event.question,
      options: event.options,
      pollType: event.pollType,
      isAnonymous: event.isAnonymous,
    );
    if (result.success) {
      emit(const PollCreated());
    } else {
      emit(PollError(result.error ?? 'Failed to create poll'));
    }
  }

  Future<void> _onVote(VoteEvent event, Emitter<PollState> emit) async {
    AppLogger.bloc('PollBloc', 'Vote → poll=${event.pollId} option=${event.optionId}');

    // Keep polls visible while voting (don't emit PollLoading!)
    if (state is PollLoaded) {
      emit((state as PollLoaded).copyWith(votingPollId: event.pollId));
    }

    final result = await voteOnPoll(
      pollId: event.pollId,
      optionId: event.optionId,
    );

    if (result.success) {
      // Reload polls to get updated vote counts
      final polls = await getRoomPolls(event.roomId);
      if (polls.success) {
        emit(PollLoaded(polls.polls));
      }
    } else {
      // Keep existing polls, show error via snackbar
      if (state is PollLoaded) {
        emit((state as PollLoaded).copyWith(votingPollId: null));
      }
      emit(PollError(result.error ?? 'Failed to cast vote'));
    }
  }
}
