import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/entities/study_program.dart';
import 'package:kovalen/core/common/entities/university.dart';
import 'package:kovalen/domain/repository/base_universities_study_programs_repository.dart';

abstract interface class ProfileSettingsRepository
    implements BaseUniversitiesStudyProgramsRepository {
  Future<Either<Failure, User>> updateUserData({
    required String fullName,
    required String avatarUrl,
    required String universityId,
    required String studyProgramId,
    required int semester,
    required double gpa,
  });

  @override
  Future<Either<Failure, List<University>>> getUniversities();

  @override
  Future<Either<Failure, List<StudyProgram>>> getStudyProgramsByUniversityId(
    String universityId,
  );

  Future<Either<Failure, void>> signOut();
}
