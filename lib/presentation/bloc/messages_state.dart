part of 'messages_bloc.dart';

@immutable
sealed class MessagesState {}

final class MessagesInitial extends MessagesState {}

final class MessagesLoading extends MessagesState {}

class MessagePreview {
  final String name;
  final String time;
  final String preview;
  final String? imageUrl;
  final String? initials;
  final int unreadCount;
  final bool isOnline;
  final bool isRead;

  const MessagePreview({
    required this.name,
    required this.time,
    required this.preview,
    this.imageUrl,
    this.initials,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isRead = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MessagePreview &&
      other.name == name &&
      other.time == time &&
      other.preview == preview &&
      other.imageUrl == imageUrl &&
      other.initials == initials &&
      other.unreadCount == unreadCount &&
      other.isOnline == isOnline &&
      other.isRead == isRead;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      time.hashCode ^
      preview.hashCode ^
      imageUrl.hashCode ^
      initials.hashCode ^
      unreadCount.hashCode ^
      isOnline.hashCode ^
      isRead.hashCode;
  }
}

final class MessagesSuccess extends MessagesState {
  final List<MessagePreview> messages;

  MessagesSuccess({required this.messages});
}

final class MessagesFailure extends MessagesState {
  final String message;

  MessagesFailure({required this.message});
}
