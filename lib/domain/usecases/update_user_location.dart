import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/repository/auth_repository.dart';

class UpdateUserLocation implements UseCase<User, UpdateUserLocationParams> {
  final AuthRepository authRepository;

  UpdateUserLocation(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UpdateUserLocationParams params) async {
    return await authRepository.updateUserLocation(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class UpdateUserLocationParams {
  final double latitude;
  final double longitude;

  UpdateUserLocationParams({
    required this.latitude,
    required this.longitude,
  });
}
