// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/entities/study_program.dart';
import 'package:kovalen/core/common/entities/university.dart';
import 'package:kovalen/core/network/connection_checker.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/data/datasources/profile_remote_data_source.dart';
import 'package:kovalen/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final ConnectionChecker connectionChecker;
  const ProfileRepositoryImpl(
    this.profileRemoteDataSource,
    this.connectionChecker,
  );

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

      final user = await profileRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserData({
    required String fullName,
    required String avatarUrl,
    required String universityId,
    required String studyProgramId,
    required int semester,
    required double gpa,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final user = await profileRemoteDataSource.updateUserData(
        fullName: fullName,
        avatarUrl: avatarUrl,
        universityId: universityId,
        studyProgramId: studyProgramId,
        semester: semester,
        gpa: gpa,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<University>>> getUniversities() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      final universities = await profileRemoteDataSource.getUniversities();
      return right(universities);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StudyProgram>>> getStudyProgramsByUniversityId(
    String universityId,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      final programs = await profileRemoteDataSource
          .getStudyProgramsByUniversityId(universityId);
      return right(programs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await profileRemoteDataSource.signOut();
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
