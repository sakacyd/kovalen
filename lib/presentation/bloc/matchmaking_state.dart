part of 'matchmaking_bloc.dart';

@immutable
sealed class MatchmakingState {}

final class MatchmakingInitial extends MatchmakingState {}

final class MatchmakingLoading extends MatchmakingState {}

class MatchProfile {
  final String name;
  final String semester;
  final String major;
  final String distance;
  final int matchPercentage;
  final String imageUrl;
  final List<String> interests;

  const MatchProfile({
    required this.name,
    required this.semester,
    required this.major,
    required this.distance,
    required this.matchPercentage,
    required this.imageUrl,
    required this.interests,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MatchProfile &&
      other.name == name &&
      other.semester == semester &&
      other.major == major &&
      other.distance == distance &&
      other.matchPercentage == matchPercentage &&
      other.imageUrl == imageUrl &&
      listEquals(other.interests, interests);
  }

  @override
  int get hashCode {
    return name.hashCode ^
      semester.hashCode ^
      major.hashCode ^
      distance.hashCode ^
      matchPercentage.hashCode ^
      imageUrl.hashCode ^
      interests.hashCode;
  }
}

final class MatchmakingSuccess extends MatchmakingState {
  final List<MatchProfile> matches;

  MatchmakingSuccess({required this.matches});
}

final class MatchmakingFailure extends MatchmakingState {
  final String message;

  MatchmakingFailure({required this.message});
}
