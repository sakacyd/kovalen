import 'package:kovalen/core/common/entities/match_profile.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:kovalen/data/models/interest_model.dart';

class MatchProfileModel extends MatchProfile {
  MatchProfileModel({
    required super.user,
    required super.interests,
    required super.commonInterestsCount,
    super.distanceInKm,
    super.matchPercentage,
  });

  factory MatchProfileModel.fromJson(Map<String, dynamic> json, {int commonCount = 0, double distance = 0.0, int matchPercentage = 0}) {
    // Expects json to represent a User and potentially a list of user_interests
    final userModel = UserModel.fromJson(json);
    
    // Check for interests embedded in the response if fetched via a join
    List<InterestModel> interestsList = [];
    if (json['user_interests'] != null) {
      final List<dynamic> uiData = json['user_interests'] as List<dynamic>;
      for (var item in uiData) {
        if (item['interests'] != null) {
          interestsList.add(InterestModel.fromJson(item['interests']));
        }
      }
    }

    return MatchProfileModel(
      user: userModel,
      interests: interestsList,
      commonInterestsCount: commonCount,
      distanceInKm: distance,
      matchPercentage: matchPercentage,
    );
  }

  MatchProfileModel copyWith({
    UserModel? user,
    List<InterestModel>? interests,
    int? commonInterestsCount,
    double? distanceInKm,
    int? matchPercentage,
  }) {
    return MatchProfileModel(
      user: user ?? this.user as UserModel,
      interests: interests ?? this.interests.cast<InterestModel>(),
      commonInterestsCount: commonInterestsCount ?? this.commonInterestsCount,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      matchPercentage: matchPercentage ?? this.matchPercentage,
    );
  }
}
