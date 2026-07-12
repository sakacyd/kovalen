import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/room_detail_repository.dart';

class AddUserToGroup implements UseCase<void, AddUserToGroupParams> {
  final RoomDetailRepository repository;

  AddUserToGroup(this.repository);

  @override
  Future<Either<Failure, void>> call(AddUserToGroupParams params) async {
    return await repository.addUserToGroup(params.roomId, params.userId);
  }
}

class AddUserToGroupParams {
  final String roomId;
  final String userId;

  AddUserToGroupParams({required this.roomId, required this.userId});
}
