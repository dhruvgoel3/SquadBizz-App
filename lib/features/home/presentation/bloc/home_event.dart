import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class LoadRoomsEvent extends HomeEvent {
  const LoadRoomsEvent();
}

class RefreshRoomsEvent extends HomeEvent {
  const RefreshRoomsEvent();
}

class CreateRoomEvent extends HomeEvent {
  final String name;
  final String? description;
  final String emoji;

  const CreateRoomEvent({
    required this.name,
    this.description,
    required this.emoji,
  });

  @override
  List<Object?> get props => [name, description, emoji];
}
