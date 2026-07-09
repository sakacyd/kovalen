import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/matching_preferences_repository.dart';

class GetMatchingPreferences implements UseCase<double, NoParams> {
  final MatchingPreferencesRepository repository;

  GetMatchingPreferences(this.repository);

  @override
  Future<Either<Failure, double>> call(NoParams params) async {
    return await repository.getDistancePreference();
  }
}
