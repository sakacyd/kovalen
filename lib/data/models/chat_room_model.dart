import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/data/models/user_model.dart';

class ChatRoomModel extends ChatRoom {
  ChatRoomModel({
    required super.id,
    required super.type,
    super.name,
    super.avatarUrl,
    required super.createdAt,
    super.lastMessage,
    super.lastMessageTime,
    super.otherUser,
  });

  factory ChatRoomModel.fromJson(
    Map<String, dynamic> json, {
    String? lastMessage,
    DateTime? lastMessageTime,
    UserModel? otherUser,
  }) {
    return ChatRoomModel(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      otherUser: otherUser,
    );
  }
}
