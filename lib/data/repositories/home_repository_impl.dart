// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/entities/home_stats.dart';
import 'package:kovalen/core/common/entities/home_data.dart';
import 'package:kovalen/core/network/connection_checker.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/data/datasources/home_remote_data_source.dart';
import 'package:kovalen/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  final ConnectionChecker connectionChecker;
  const HomeRepositoryImpl(this.homeRemoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = homeRemoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure('User not logged in!'));
        }

        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            fullName: session.user.userMetadata?['full_name'] ?? '',
            avatarUrl: '',
            semester: session.user.userMetadata?['semester'] ?? 0,
            latitude: 0.0,
            longitude: 0.0,
            lastLocationUpdate: '',
            gpa: 0.0,
            universityId: '',
            studyProgramId: '',
          ),
        );
      }

      final user = await homeRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, HomeStats>> getHomeStats() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final stats = await homeRemoteDataSource.getHomeStats();
      return right(stats);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Stream<Either<Failure, HomeData>> watchHomeData() async* {
    if (!await connectionChecker.isConnected) {
      yield left(Failure('No internet connection'));
      return;
    }

    try {
      yield* homeRemoteDataSource
          .watchHomeData()
          .map((data) => right<Failure, HomeData>(data))
          .handleError((error) {
            if (error is ServerException) {
              return left(Failure(error.message));
            }
            return left(Failure(error.toString()));
          });
    } on ServerException catch (e) {
      yield left(Failure(e.message));
    }
  }
}
