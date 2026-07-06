import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/repository/profile_settings_repository.dart';

class UpdateUserProfile implements UseCase<User, UpdateUserProfileParams> {
  final ProfileSettingsRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserData(
      fullName: params.fullName,
      avatarUrl: params.avatarUrl,
      avatarFile: params.avatarFile,
      universityId: params.universityId,
      studyProgramId: params.studyProgramId,
      semester: params.semester,
      gpa: params.gpa,
      interestIds: params.interestIds,
    );
  }
}

class UpdateUserProfileParams {
  final String fullName;
  final String avatarUrl;
  final File? avatarFile;
  final String universityId;
  final String studyProgramId;
  final int semester;
  final double gpa;
  final List<String> interestIds;

  UpdateUserProfileParams({
    required this.fullName,
    required this.avatarUrl,
    this.avatarFile,
    required this.universityId,
    required this.studyProgramId,
    required this.semester,
    required this.gpa,
    required this.interestIds,
  });
}
