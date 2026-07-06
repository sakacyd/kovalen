import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/interest.dart';
import 'package:kovalen/domain/repository/base_universities_study_programs_repository.dart';

class GetAvailableInterests<T extends BaseUniversitiesStudyProgramsRepository>
    implements UseCase<Map<String, Map<String, List<Interest>>>, NoParams> {
  final T repository;

  GetAvailableInterests(this.repository);

  @override
  Future<Either<Failure, Map<String, Map<String, List<Interest>>>>> call(NoParams params) async {
    final result = await repository.getAvailableInterests();
    
    return result.map((interests) {
      final Map<String, Map<String, List<Interest>>> groupedByType = {};

      for (var interest in interests) {
        final type = interest.category?.type ?? 'other';
        final typeName = type == 'academic' ? 'Akademik' : (type == 'non_academic' ? 'Non Akademik' : type);
        final catName = interest.category?.name ?? 'Lainnya';

        if (!groupedByType.containsKey(typeName)) {
          groupedByType[typeName] = {};
        }
        if (!groupedByType[typeName]!.containsKey(catName)) {
          groupedByType[typeName]![catName] = [];
        }
        groupedByType[typeName]![catName]!.add(interest);
      }

      for (var typeKey in groupedByType.keys) {
        for (var catKey in groupedByType[typeKey]!.keys) {
          groupedByType[typeKey]![catKey]!.sort((a, b) => a.name.compareTo(b.name));
        }
      }

      return groupedByType;
    });
  }
}
