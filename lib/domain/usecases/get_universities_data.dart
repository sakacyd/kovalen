import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/university.dart';
import 'package:kovalen/domain/repository/base_universities_study_programs_repository.dart';

class GetUniversitiesData<T extends BaseUniversitiesStudyProgramsRepository>
    implements UseCase<List<University>, NoParams> {
  final T repository;

  GetUniversitiesData(this.repository);

  @override
  Future<Either<Failure, List<University>>> call(NoParams params) async {
    final result = await repository.getUniversities();
    
    return result.map((universities) {
      final sortedUniversities = List<University>.from(universities);
      sortedUniversities.sort((a, b) {
        int rankA = _getUniversityRank(a.name);
        int rankB = _getUniversityRank(b.name);
        if (rankA != rankB) return rankA.compareTo(rankB);
        return a.name.compareTo(b.name);
      });
      return sortedUniversities;
    });
  }

  int _getUniversityRank(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.startsWith('universitas')) return 1;
    if (lowerName.startsWith('institut')) return 2;
    if (lowerName.startsWith('sekolah tinggi')) return 3;
    if (lowerName.startsWith('politeknik')) return 4;
    if (lowerName.startsWith('akademi komunitas')) return 6;
    if (lowerName.startsWith('akademi')) return 5;
    return 99;
  }
}
