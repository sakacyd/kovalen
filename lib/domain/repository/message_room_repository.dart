import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/message.dart';

abstract interface class MessageRoomRepository {
  Stream<Either<Failure, List<Message>>> getMessageRoomMessages(String roomId);
  Future<Either<Failure, Message>> sendMessage(String roomId, String content);
}
