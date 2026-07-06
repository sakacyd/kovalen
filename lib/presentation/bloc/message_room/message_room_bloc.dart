import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/entities/message.dart';
import 'package:kovalen/domain/usecases/get_message_room_messages.dart';
import 'package:kovalen/domain/usecases/send_message_room_message.dart';

part 'message_room_event.dart';
part 'message_room_state.dart';

class MessageRoomBloc extends Bloc<MessageRoomEvent, MessageRoomState> {
  final GetMessageRoomMessages _getMessageRoomMessages;
  final SendMessageRoomMessage _sendMessageRoomMessage;

  MessageRoomBloc({
    required GetMessageRoomMessages getMessageRoomMessages,
    required SendMessageRoomMessage sendMessageRoomMessage,
  })  : _getMessageRoomMessages = getMessageRoomMessages,
        _sendMessageRoomMessage = sendMessageRoomMessage,
        super(MessageRoomInitial()) {
    on<LoadMessageRoomMessages>(_onLoadMessages);
    on<SendMessageRoomMessageEvent>(_onSendMessage);
  }

  FutureOr<void> _onLoadMessages(
    LoadMessageRoomMessages event,
    Emitter<MessageRoomState> emit,
  ) async {
    emit(MessageRoomLoading());

    await emit.forEach(
      _getMessageRoomMessages(
        GetMessageRoomMessagesParams(roomId: event.roomId),
      ),
      onData: (res) {
        return res.fold(
          (l) => MessageRoomFailure(l.message),
          (r) => MessageRoomSuccess(r),
        );
      },
    );
  }

  FutureOr<void> _onSendMessage(
    SendMessageRoomMessageEvent event,
    Emitter<MessageRoomState> emit,
  ) async {
    // If it's already success, we can do optimistic update
    final currentState = state;
    List<Message> currentMessages = [];
    if (currentState is MessageRoomSuccess) {
      currentMessages = List.from(currentState.messages);
      // Wait, we don't have the user ID to optimistically create a message without making it nullable.
      // So let's just show loading or not change state until network succeeds.
    }

    final res = await _sendMessageRoomMessage(
      SendMessageRoomMessageParams(roomId: event.roomId, content: event.content),
    );

    res.fold(
      (l) => emit(MessageRoomFailure(l.message)),
      (newMessage) {
        if (currentState is MessageRoomSuccess) {
          emit(MessageRoomSuccess([...currentMessages, newMessage]));
        } else {
          // If we weren't in success state, we shouldn't really be sending, but just in case:
          emit(MessageRoomSuccess([newMessage]));
        }
      },
    );
  }
}
