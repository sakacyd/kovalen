import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/usecases/watch_chat_rooms.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final WatchChatRooms _watchChatRooms;

  MessagesBloc({
    required WatchChatRooms watchChatRooms,
  })  : _watchChatRooms = watchChatRooms,
        super(MessagesInitial()) {
    on<LoadMessagesData>(_onLoadMessagesData);
  }

  FutureOr<void> _onLoadMessagesData(
    LoadMessagesData event,
    Emitter<MessagesState> emit,
  ) async {
    emit(MessagesLoading());
    
    await emit.forEach(
      _watchChatRooms(NoParams()),
      onData: (res) => res.fold(
        (failure) => MessagesFailure(message: failure.message),
        (rooms) => MessagesSuccess(rooms: rooms),
      ),
      onError: (error, stackTrace) => MessagesFailure(message: error.toString()),
    );
  }
}
