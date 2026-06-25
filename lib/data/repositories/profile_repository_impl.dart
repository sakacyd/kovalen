// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/network/connection_checker.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/data/datasources/profile_remote_data_source.dart';
import 'package:kovalen/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final ConnectionChecker connectionChecker;
  const ProfileRepositoryImpl(this.profileRemoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = profileRemoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure('User not logged in!'));
        }

        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            fullName: session.user.userMetadata?['full_name'] ?? '',
            phoneNumber: /* session.user.userMetadata['phone_number'] ?? */ '',
            avatarUrl: /* session.user.userMetadata['image_url'] ??  */ '',
            semester: session.user.userMetadata?['semester'] ?? 0,
            studyProgram: session.user.userMetadata?['study_program'] ?? '',
            latitude: /* session.user.userMetadata['latitude'] ?? */ 0.0,
            longitude: /* session.user.userMetadata['longitude'] ?? */ 0.0,
            lastLocationUpdate: /* session.user.userMetadata['last_location_update'] ?? */
                '',
          ),
        );
      }

      final user = await profileRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
