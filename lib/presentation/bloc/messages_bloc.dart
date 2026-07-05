import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/usecases/get_chat_rooms.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final GetChatRooms _getChatRooms;

  MessagesBloc({
    required GetChatRooms getChatRooms,
  })  : _getChatRooms = getChatRooms,
        super(MessagesInitial()) {
    on<LoadMessagesData>(_onLoadMessagesData);
  }

  FutureOr<void> _onLoadMessagesData(
    LoadMessagesData event,
    Emitter<MessagesState> emit,
  ) async {
    emit(MessagesLoading());
    
    final res = await _getChatRooms(NoParams());
    
    res.fold(
      (failure) => emit(MessagesFailure(message: failure.message)),
      (rooms) => emit(MessagesSuccess(rooms: rooms)),
    );
  }
}
