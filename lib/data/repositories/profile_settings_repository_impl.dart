import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/entities/study_program.dart';
import 'package:kovalen/core/common/entities/university.dart';
import 'package:kovalen/core/common/entities/interest.dart';
import 'package:kovalen/data/datasources/profile_settings_remote_data_source.dart';
import 'package:kovalen/domain/repository/profile_settings_repository.dart';

class ProfileSettingsRepositoryImpl implements ProfileSettingsRepository {
  final ProfileSettingsRemoteDataSource remoteDataSource;

  ProfileSettingsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> updateUserData({
    required String fullName,
    required String avatarUrl,
    File? avatarFile,
    required String universityId,
    required String studyProgramId,
    required int semester,
    required String gender,
    required String tujuanBelajar,
    required String gayaBelajar,
    required String hobi,
    required double gpa,
    required List<String> interestIds,
  }) async {
    try {
      final userModel = await remoteDataSource.updateUserData(
        fullName: fullName,
        avatarUrl: avatarUrl,
        avatarFile: avatarFile,
        universityId: universityId,
        studyProgramId: studyProgramId,
        semester: semester,
        gender: gender,
        tujuanBelajar: tujuanBelajar,
        gayaBelajar: gayaBelajar,
        hobi: hobi,
        gpa: gpa,
        interestIds: interestIds,
      );
      return right(userModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<University>>> getUniversities() async {
    try {
      final universities = await remoteDataSource.getUniversities();
      return right(universities);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<StudyProgram>>> getStudyProgramsByUniversityId(
    String universityId,
  ) async {
    try {
      final programs = await remoteDataSource.getStudyProgramsByUniversityId(
        universityId,
      );
      return right(programs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Interest>>> getAvailableInterests() async {
    try {
      final interests = await remoteDataSource.getAvailableInterests();
      return right(interests);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
