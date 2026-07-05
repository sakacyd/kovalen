import 'package:kovalen/core/common/entities/match_connection.dart';
import 'package:kovalen/data/models/user_model.dart';

class MatchConnectionModel extends MatchConnection {
  MatchConnectionModel({
    required super.id,
    required super.user1Id,
    required super.user2Id,
    required super.createdAt,
    super.matchedUser,
  });

  factory MatchConnectionModel.fromJson(Map<String, dynamic> json) {
    return MatchConnectionModel(
      id: json['id'] as String,
      user1Id: json['user1_id'] as String,
      user2Id: json['user2_id'] as String,
      createdAt: DateTime.parse(json['created_at']),
      matchedUser: json['users'] != null ? UserModel.fromJson(json['users']) : null,
    );
  }
}
