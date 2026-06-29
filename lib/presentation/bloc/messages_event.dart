part of 'messages_bloc.dart';

@immutable
sealed class MessagesEvent {}

final class LoadMessagesData extends MessagesEvent {}
