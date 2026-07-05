import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/core/common/entities/message.dart';
import 'package:kovalen/data/datasources/messages_remote_data_source.dart';
import 'package:kovalen/domain/repository/messages_repository.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesRemoteDataSource remoteDataSource;

  MessagesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ChatRoom>>> getChatRooms() async {
    try {
      final rooms = await remoteDataSource.getChatRooms();
      return Right(rooms);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String roomId) async {
    try {
      final messages = await remoteDataSource.getMessages(roomId);
      return Right(messages);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(String roomId, String content) async {
    try {
      final message = await remoteDataSource.sendMessage(roomId, content);
      return Right(message);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
