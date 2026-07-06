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
    final result = await repository.getStudyProgramsByUniversityId(params.universityId);
    
    return result.map((programs) {
      final sortedPrograms = List<StudyProgram>.from(programs);
      sortedPrograms.sort((a, b) {
        int rankA = _getStudyProgramRank(a.educationLevel);
        int rankB = _getStudyProgramRank(b.educationLevel);
        if (rankA != rankB) return rankA.compareTo(rankB);
        return a.name.compareTo(b.name);
      });
      return sortedPrograms;
    });
  }

  int _getStudyProgramRank(String level) {
    final lowerLevel = level.toLowerCase();
    if (lowerLevel == 'd1') return 1;
    if (lowerLevel == 'd2') return 2;
    if (lowerLevel == 'd3') return 3;
    if (lowerLevel.contains('d4') || lowerLevel.contains('terapan')) return 4;
    if (lowerLevel == 's1') return 5;
    if (lowerLevel == 'profesi') return 6;
    if (lowerLevel == 's2') return 7;
    if (lowerLevel == 'sp-1') return 8;
    if (lowerLevel == 's3') return 9;
    if (lowerLevel.contains('sp-2') || lowerLevel.contains('subspesialis')) return 10;
    return 99;
  }
}

class GetStudyProgramsDataParams {
  final String universityId;

  GetStudyProgramsDataParams({required this.universityId});
}
