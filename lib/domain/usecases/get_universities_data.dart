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
    return await repository.getUniversities();
  }
}
