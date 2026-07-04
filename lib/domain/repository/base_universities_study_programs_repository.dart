import 'package:kovalen/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/common/entities/study_program.dart';
import 'package:kovalen/core/common/entities/university.dart';

abstract interface class BaseUniversitiesStudyProgramsRepository {
  Future<Either<Failure, List<University>>> getUniversities();
  Future<Either<Failure, List<StudyProgram>>> getStudyProgramsByUniversityId(
    String universityId,
  );
}
