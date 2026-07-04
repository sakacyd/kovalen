import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/repository/onboarding_repository.dart';

class SubmitOnboardingData implements UseCase<User, SubmitOnboardingDataParams> {
  final OnboardingRepository repository;

  SubmitOnboardingData(this.repository);

  @override
  Future<Either<Failure, User>> call(SubmitOnboardingDataParams params) async {
    return await repository.updateUserData(
      fullName: params.fullName,
      avatarUrl: params.avatarUrl,
      universityId: params.universityId,
      studyProgramId: params.studyProgramId,
      semester: params.semester,
      gpa: params.gpa,
    );
  }
}

class SubmitOnboardingDataParams {
  final String fullName;
  final String avatarUrl;
  final String universityId;
  final String studyProgramId;
  final int semester;
  final double gpa;

  SubmitOnboardingDataParams({
    required this.fullName,
    required this.avatarUrl,
    required this.universityId,
    required this.studyProgramId,
    required this.semester,
    required this.gpa,
  });
}
