import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/network/connection_checker.dart';
import 'package:kovalen/core/common/entities/study_program.dart';
import 'package:kovalen/core/common/entities/university.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/data/datasources/onboarding_remote_data_source.dart';
import 'package:kovalen/domain/repository/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource onboardingRemoteDataSource;
  final ConnectionChecker connectionChecker;

  const OnboardingRepositoryImpl(this.onboardingRemoteDataSource, this.connectionChecker);

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

      final user = await onboardingRemoteDataSource.updateUserData(
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
      final universities = await onboardingRemoteDataSource.getUniversities();
      return right(universities);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StudyProgram>>> getStudyProgramsByUniversityId(String universityId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      final programs = await onboardingRemoteDataSource.getStudyProgramsByUniversityId(universityId);
      return right(programs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
