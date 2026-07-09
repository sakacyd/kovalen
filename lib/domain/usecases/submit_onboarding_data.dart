import 'dart:io';
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
      avatarFile: params.avatarFile,
      universityId: params.universityId,
      studyProgramId: params.studyProgramId,
      semester: params.semester,
      gender: params.gender,
      tujuanBelajar: params.tujuanBelajar,
      gayaBelajar: params.gayaBelajar,
      gpa: params.gpa,
      interestIds: params.interestIds,
    );
  }
}

class SubmitOnboardingDataParams {
  final String fullName;
  final String avatarUrl;
  final File? avatarFile;
  final String universityId;
  final String studyProgramId;
  final int semester;
  final String gender;
  final String tujuanBelajar;
  final String gayaBelajar;
  final double gpa;
  final List<String> interestIds;

  SubmitOnboardingDataParams({
    required this.fullName,
    required this.avatarUrl,
    this.avatarFile,
    required this.universityId,
    required this.studyProgramId,
    required this.semester,
    required this.gender,
    required this.tujuanBelajar,
    required this.gayaBelajar,
    required this.gpa,
    required this.interestIds,
  });
}
