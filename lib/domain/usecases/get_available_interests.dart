import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/interest.dart';
import 'package:kovalen/domain/repository/base_universities_study_programs_repository.dart';

class GetAvailableInterests<T extends BaseUniversitiesStudyProgramsRepository>
    implements UseCase<List<Interest>, NoParams> {
  final T repository;

  GetAvailableInterests(this.repository);

  @override
  Future<Either<Failure, List<Interest>>> call(NoParams params) async {
    return await repository.getAvailableInterests();
  }
}
