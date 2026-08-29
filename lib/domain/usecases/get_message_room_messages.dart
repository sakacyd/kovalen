import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/message.dart';
import 'package:kovalen/domain/repository/message_room_repository.dart';

class GetMessageRoomMessages
    implements StreamUseCase<List<Message>, GetMessageRoomMessagesParams> {
  final MessageRoomRepository repository;

  GetMessageRoomMessages(this.repository);

  @override
  Stream<Either<Failure, List<Message>>> call(
    GetMessageRoomMessagesParams params,
  ) {
    return repository.getMessageRoomMessages(params.roomId);
  }
}

class GetMessageRoomMessagesParams {
  final String roomId;
  GetMessageRoomMessagesParams({required this.roomId});
}
