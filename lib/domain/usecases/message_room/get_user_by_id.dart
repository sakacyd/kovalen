import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/repository/room_detail_repository.dart';

class GetUserById implements UseCase<User, String> {
  final RoomDetailRepository repository;

  GetUserById(this.repository);

  @override
  Future<Either<Failure, User>> call(String params) async {
    return await repository.getUserById(params);
  }
}
