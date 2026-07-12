import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/repository/room_detail_repository.dart';

class GetGroupDetailResult {
  final ChatRoom room;
  final List<User> participants;

  GetGroupDetailResult({required this.room, required this.participants});
}

class GetGroupDetail implements UseCase<GetGroupDetailResult, String> {
  final RoomDetailRepository repository;

  GetGroupDetail(this.repository);

  @override
  Future<Either<Failure, GetGroupDetailResult>> call(String params) async {
    final roomRes = await repository.getGroupDetail(params);
    return roomRes.fold(
      (l) => left(l),
      (room) async {
        final participantsRes = await repository.getGroupParticipants(params);
        return participantsRes.fold(
          (l) => left(l),
          (participants) => right(GetGroupDetailResult(room: room, participants: participants)),
        );
      },
    );
  }
}
