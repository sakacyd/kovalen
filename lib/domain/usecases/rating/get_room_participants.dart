import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/repository/rating_repository.dart';

class GetRoomParticipantsParams {
  final String roomId;
  GetRoomParticipantsParams({required this.roomId});
}

class GetRoomParticipants implements UseCase<List<User>, GetRoomParticipantsParams> {
  final RatingRepository repository;

  GetRoomParticipants(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(GetRoomParticipantsParams params) async {
    return await repository.getRoomParticipants(params.roomId);
  }
}
