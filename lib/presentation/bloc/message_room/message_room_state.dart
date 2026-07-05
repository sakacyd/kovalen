part of 'message_room_bloc.dart';

@immutable
sealed class MessageRoomState {}

final class MessageRoomInitial extends MessageRoomState {}

final class MessageRoomLoading extends MessageRoomState {}

final class MessageRoomSuccess extends MessageRoomState {
  final List<Message> messages;
  MessageRoomSuccess(this.messages);
}

final class MessageRoomFailure extends MessageRoomState {
  final String message;
  MessageRoomFailure(this.message);
}
