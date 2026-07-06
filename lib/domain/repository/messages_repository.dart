import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/core/common/entities/message.dart';

abstract interface class MessagesRepository {
  Future<Either<Failure, List<ChatRoom>>> getChatRooms();
  Stream<Either<Failure, List<ChatRoom>>> watchChatRooms();
  Future<Either<Failure, List<Message>>> getMessages(String roomId);
  Future<Either<Failure, Message>> sendMessage(String roomId, String content);
}
