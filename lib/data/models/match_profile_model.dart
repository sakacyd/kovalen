import 'package:kovalen/core/common/entities/match_profile.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:kovalen/data/models/interest_model.dart';

class MatchProfileModel extends MatchProfile {
  MatchProfileModel({
    required super.user,
    required super.interests,
    required super.commonInterestsCount,
    super.distanceInKm,
  });

  factory MatchProfileModel.fromJson(Map<String, dynamic> json, {int commonCount = 0, double distance = 0.0}) {
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
    );
  }
}
