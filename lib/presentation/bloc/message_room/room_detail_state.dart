part of 'room_detail_bloc.dart';

@immutable
sealed class RoomDetailState {}

final class RoomDetailInitial extends RoomDetailState {}

final class RoomDetailLoading extends RoomDetailState {}

final class PersonalRoomDetailLoaded extends RoomDetailState {
  final User user;
  PersonalRoomDetailLoaded(this.user);
}

final class GroupRoomDetailLoaded extends RoomDetailState {
  final ChatRoom room;
  final List<User> participants;

  GroupRoomDetailLoaded({required this.room, required this.participants});
}

final class RoomDetailFailure extends RoomDetailState {
  final String message;
  RoomDetailFailure(this.message);
}
