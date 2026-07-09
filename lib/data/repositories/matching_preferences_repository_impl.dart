import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/network/connection_checker.dart';
import 'package:kovalen/data/datasources/matching_preferences_remote_data_source.dart';
import 'package:kovalen/domain/repository/matching_preferences_repository.dart';

class MatchingPreferencesRepositoryImpl
    implements MatchingPreferencesRepository {
  final MatchingPreferencesRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  MatchingPreferencesRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, double>> getDistancePreference() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      final distance = await remoteDataSource.getDistancePreference();
      return right(distance);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveDistancePreference(
    double maxDistance,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      await remoteDataSource.saveDistancePreference(maxDistance);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
