import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/matching_preferences_repository.dart';

class SaveMatchingPreferences
    implements UseCase<void, SaveMatchingPreferencesParams> {
  final MatchingPreferencesRepository repository;

  SaveMatchingPreferences(this.repository);

  @override
  Future<Either<Failure, void>> call(
    SaveMatchingPreferencesParams params,
  ) async {
    return await repository.saveDistancePreference(params.maxDistance);
  }
}

class SaveMatchingPreferencesParams {
  final double maxDistance;

  SaveMatchingPreferencesParams({required this.maxDistance});
}
