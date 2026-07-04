import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/university.dart';
import 'package:kovalen/domain/repository/onboarding_repository.dart';

class GetUniversitiesData implements UseCase<List<University>, NoParams> {
  final OnboardingRepository repository;

  GetUniversitiesData(this.repository);

  @override
  Future<Either<Failure, List<University>>> call(NoParams params) async {
    return await repository.getUniversities();
  }
}
