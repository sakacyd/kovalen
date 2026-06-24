// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:kovalen/core/constants/constants.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/network/connection_checker.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/data/datasources/auth_remote_data_source.dart';
import 'package:kovalen/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(this.authRemoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteDataSource.signUpWithEmailAndPassword(
        fullName: fullName,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = authRemoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure('User not logged in!'));
        }

        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            fullName: /* session.user.userMetadata['full_name'] ??  */ '',
            phoneNumber: /* session.user.userMetadata['phone_number'] ?? */ '',
            avatarUrl: /* session.user.userMetadata['avatar_url'] ??  */ '',
            studyProgram: /* session.user.userMetadata['study_program'] ?? */
                '',
            semester: /* session.user.userMetadata['semester'] ?? */ 0,
            latitude: /* session.user.userMetadata['latitude'] ?? */ 0.0,
            longitude: /* session.user.userMetadata['longitude'] ?? */ 0.0,
            lastLocationUpdate: /* session.user.userMetadata['last_location_update'] ?? */
                '',
          ),
        );
      }

      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authRemoteDataSource.signOut();
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      final hasConnection = await connectionChecker.isConnected;

      if (!hasConnection) {
        return left(Failure(Constants.noConnectionMessage));
      }

      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
