import 'package:kovalen/core/common/entities/chat_participant.dart';

class ChatParticipantModel extends ChatParticipant {
  ChatParticipantModel({
    required super.roomId,
    required super.userId,
    required super.joinedAt,
  });

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) {
    return ChatParticipantModel(
      roomId: json['room_id'] as String,
      userId: json['user_id'] as String,
      joinedAt: DateTime.parse(json['joined_at']),
    );
  }
}
