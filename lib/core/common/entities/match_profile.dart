import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/entities/interest.dart';

class MatchProfile {
  final User user;
  final List<Interest> interests;
  final int commonInterestsCount;
  final double distanceInKm; 
  final int matchPercentage;

  MatchProfile({
    required this.user,
    required this.interests,
    required this.commonInterestsCount,
    this.distanceInKm = 0.0,
    this.matchPercentage = 0,
  });
}
