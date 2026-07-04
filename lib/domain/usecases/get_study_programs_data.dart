import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/study_program.dart';
import 'package:kovalen/domain/repository/base_universities_study_programs_repository.dart';

class GetStudyProgramsData<T extends BaseUniversitiesStudyProgramsRepository>
    implements UseCase<List<StudyProgram>, GetStudyProgramsDataParams> {
  final T repository;

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
