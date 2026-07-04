import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignOut implements UseCase<void, NoParams> {
  final ProfileRepository profileRepository;

  UserSignOut(this.profileRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await profileRepository.signOut();
  }
}
