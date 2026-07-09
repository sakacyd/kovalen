import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';

abstract interface class MatchingPreferencesRepository {
  Future<Either<Failure, double>> getDistancePreference();
  Future<Either<Failure, void>> saveDistancePreference(double maxDistance);
}
