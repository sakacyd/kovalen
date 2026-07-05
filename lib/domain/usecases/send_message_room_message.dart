import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/message.dart';
import 'package:kovalen/domain/repository/message_room_repository.dart';

class SendMessageRoomMessage implements UseCase<Message, SendMessageRoomMessageParams> {
  final MessageRoomRepository repository;

  SendMessageRoomMessage(this.repository);

  @override
  Future<Either<Failure, Message>> call(SendMessageRoomMessageParams params) async {
    return await repository.sendMessage(params.roomId, params.content);
  }
}

class SendMessageRoomMessageParams {
  final String roomId;
  final String content;

  SendMessageRoomMessageParams({
    required this.roomId,
    required this.content,
  });
}
