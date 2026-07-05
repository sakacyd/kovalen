part of 'message_room_bloc.dart';

@immutable
sealed class MessageRoomEvent {}

class LoadMessageRoomMessages extends MessageRoomEvent {
  final String roomId;
  LoadMessageRoomMessages(this.roomId);
}

class SendMessageRoomMessageEvent extends MessageRoomEvent {
  final String roomId;
  final String content;
  SendMessageRoomMessageEvent(this.roomId, this.content);
}
