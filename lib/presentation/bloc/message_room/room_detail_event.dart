part of 'room_detail_bloc.dart';

@immutable
sealed class RoomDetailEvent {}

class FetchPersonalRoomDetailEvent extends RoomDetailEvent {
  final String userId;
  FetchPersonalRoomDetailEvent(this.userId);
}

class FetchGroupRoomDetailEvent extends RoomDetailEvent {
  final String roomId;
  FetchGroupRoomDetailEvent(this.roomId);
}

class UpdateGroupProfileEvent extends RoomDetailEvent {
  final String roomId;
  final String name;
  final File? avatarFile;

  UpdateGroupProfileEvent({
    required this.roomId,
    required this.name,
    this.avatarFile,
  });
}

class AddUserToGroupEvent extends RoomDetailEvent {
  final String roomId;
  final String userId;

  AddUserToGroupEvent({required this.roomId, required this.userId});
}
