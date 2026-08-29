import 'package:kovalen/core/common/entities/user.dart';

class MatchConnection {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime createdAt;

  // Optional populated fields
  final User? matchedUser;

  MatchConnection({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
    this.matchedUser,
  });
}
