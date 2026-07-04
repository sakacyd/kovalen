import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/common/entities/study_program.dart';
import 'package:kovalen/core/common/entities/university.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/user.dart';

abstract interface class OnboardingRepository {
  Future<Either<Failure, User>> updateUserData({
    required String fullName,
    required String avatarUrl,
    required String universityId,
    required String studyProgramId,
    required int semester,
    required double gpa,
  });

  Future<Either<Failure, List<University>>> getUniversities();
  Future<Either<Failure, List<StudyProgram>>> getStudyProgramsByUniversityId(String universityId);
}
