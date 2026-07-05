class ChatParticipant {
  final String roomId;
  final String userId;
  final DateTime joinedAt;

  ChatParticipant({
    required this.roomId,
    required this.userId,
    required this.joinedAt,
  });
}
