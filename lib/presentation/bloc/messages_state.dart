part of 'messages_bloc.dart';

@immutable
sealed class MessagesState {}

final class MessagesInitial extends MessagesState {}

final class MessagesLoading extends MessagesState {}

final class MessagesSuccess extends MessagesState {
  final List<ChatRoom> rooms;

  MessagesSuccess({required this.rooms});
}

final class MessagesFailure extends MessagesState {
  final String message;

  MessagesFailure({required this.message});
}
