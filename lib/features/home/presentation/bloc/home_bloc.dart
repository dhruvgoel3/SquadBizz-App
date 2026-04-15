import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/room_repository.dart';
import '../../domain/usecases/get_user_rooms.dart';
import '../../domain/usecases/create_room.dart';
import '../../domain/usecases/join_room.dart';
import 'home_event.dart';
import 'home_state.dart';

/// BLoC for rooms — loading, creating, refreshing, joining.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetUserRooms _getUserRooms;
  final CreateRoom _createRoom;
  final JoinRoom _joinRoom;
  final RoomRepository _repository;

  HomeBloc({
    required GetUserRooms getUserRooms,
    required CreateRoom createRoom,
    required JoinRoom joinRoom,
    required RoomRepository repository,
  })  : _getUserRooms = getUserRooms,
        _createRoom = createRoom,
        _joinRoom = joinRoom,
        _repository = repository,
        super(const HomeInitial()) {
    on<LoadRoomsEvent>(_onLoadRooms);
    on<RefreshRoomsEvent>(_onRefreshRooms);
    on<CreateRoomEvent>(_onCreateRoom);
    on<JoinRoomEvent>(_onJoinRoom);
  }

  Future<void> _onLoadRooms(
    LoadRoomsEvent event,
    Emitter<HomeState> emit,
  ) async {
    AppLogger.bloc('HomeBloc', 'LoadRooms');
    emit(const HomeLoading());
    try {
      final result = await _getUserRooms();
      emit(HomeLoaded(
        rooms: result.rooms,
        firstName: _repository.currentUserFirstName,
      ));
    } catch (e, st) {
      AppLogger.e('Failed to load rooms', error: e, stackTrace: st);
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshRooms(
    RefreshRoomsEvent event,
    Emitter<HomeState> emit,
  ) async {
    AppLogger.bloc('HomeBloc', 'RefreshRooms');
    try {
      final result = await _getUserRooms();
      if (result.success) {
        emit(HomeLoaded(
          rooms: result.rooms,
          firstName: _repository.currentUserFirstName,
        ));
      }
    } catch (e, st) {
      AppLogger.e('Failed to refresh rooms', error: e, stackTrace: st);
    }
  }

  Future<void> _onCreateRoom(
    CreateRoomEvent event,
    Emitter<HomeState> emit,
  ) async {
    AppLogger.bloc('HomeBloc', 'CreateRoom → ${event.name}');
    emit(const RoomCreating());
    try {
      final result = await _createRoom(
        name: event.name,
        description: event.description,
        emoji: event.emoji,
      );
      if (result.success) {
        AppLogger.i('Room created: ${result.roomId}');
        emit(RoomCreated(
          roomId: result.roomId!,
          roomCode: result.roomCode!,
        ));
      } else {
        AppLogger.w('Room create failed: ${result.error}');
        emit(RoomCreateError(result.error ?? 'Failed to create room.'));
      }
    } catch (e, st) {
      AppLogger.e('Room create exception', error: e, stackTrace: st);
      emit(RoomCreateError(e.toString()));
    }
  }

  Future<void> _onJoinRoom(
    JoinRoomEvent event,
    Emitter<HomeState> emit,
  ) async {
    AppLogger.bloc('HomeBloc', 'JoinRoom → ${event.roomCode}');
    emit(const RoomJoining());
    try {
      final result = await _joinRoom(event.roomCode);
      if (result.success) {
        AppLogger.i('Room joined: ${result.roomId}');
        emit(RoomJoined(result.roomId!));
      } else {
        AppLogger.w('Room join failed: ${result.error}');
        emit(RoomJoinError(result.error ?? 'Failed to join room.'));
      }
    } catch (e, st) {
      AppLogger.e('Room join exception', error: e, stackTrace: st);
      emit(RoomJoinError(e.toString()));
    }
  }
}
