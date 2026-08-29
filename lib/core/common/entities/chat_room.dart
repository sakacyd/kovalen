import 'package:kovalen/core/common/entities/user.dart';

class ChatRoom {
  final String id;
  final String type; // 'personal' or 'group'
  final String? name;
  final String? avatarUrl;
  final DateTime createdAt;

  // Custom properties for UI
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final User? otherUser; // populated for 'personal' type

  ChatRoom({
    required this.id,
    required this.type,
    this.name,
    this.avatarUrl,
    required this.createdAt,
    this.lastMessage,
    this.lastMessageTime,
    this.otherUser,
  });
}
