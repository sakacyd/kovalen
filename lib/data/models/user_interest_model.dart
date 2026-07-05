import 'package:kovalen/core/common/entities/user_interest.dart';

class UserInterestModel extends UserInterest {
  UserInterestModel({
    required super.userId,
    required super.interestId,
    required super.createdAt,
  });

  factory UserInterestModel.fromJson(Map<String, dynamic> json) {
    return UserInterestModel(
      userId: json['user_id'] as String,
      interestId: json['interest_id'] as String,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
