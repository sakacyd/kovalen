import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/study_program.dart';
import 'package:kovalen/domain/repository/onboarding_repository.dart';

class GetStudyProgramsData implements UseCase<List<StudyProgram>, GetStudyProgramsDataParams> {
  final OnboardingRepository repository;

  GetStudyProgramsData(this.repository);

  @override
  Future<Either<Failure, List<StudyProgram>>> call(GetStudyProgramsDataParams params) async {
    return await repository.getStudyProgramsByUniversityId(params.universityId);
  }
}

class GetStudyProgramsDataParams {
  final String universityId;

  GetStudyProgramsDataParams({required this.universityId});
}
