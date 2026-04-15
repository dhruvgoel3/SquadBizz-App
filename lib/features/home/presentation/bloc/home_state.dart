import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Map<String, dynamic>> rooms;
  final String firstName;

  const HomeLoaded({required this.rooms, required this.firstName});

  @override
  List<Object?> get props => [rooms, firstName];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class RoomCreated extends HomeState {
  final String roomId;
  final String roomCode;

  const RoomCreated({required this.roomId, required this.roomCode});

  @override
  List<Object?> get props => [roomId, roomCode];
}

class RoomCreateError extends HomeState {
  final String message;
  const RoomCreateError(this.message);

  @override
  List<Object?> get props => [message];
}

class RoomCreating extends HomeState {
  const RoomCreating();
}

class RoomJoined extends HomeState {
  final String roomId;
  const RoomJoined(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class RoomJoinError extends HomeState {
  final String message;
  const RoomJoinError(this.message);

  @override
  List<Object?> get props => [message];
}

class RoomJoining extends HomeState {
  const RoomJoining();
}
