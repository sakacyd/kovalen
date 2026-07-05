import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/constants/constants.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/network/connection_checker.dart';
import 'package:kovalen/core/common/entities/message.dart';
import 'package:kovalen/data/datasources/message_room_remote_data_source.dart';
import 'package:kovalen/domain/repository/message_room_repository.dart';

class MessageRoomRepositoryImpl implements MessageRoomRepository {
  final MessageRoomRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  MessageRoomRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, List<Message>>> getMessageRoomMessages(String roomId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constants.noConnectionMessage));
      }
      final messages = await remoteDataSource.getMessageRoomMessages(roomId);
      return right(messages);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(String roomId, String content) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constants.noConnectionMessage));
      }
      final message = await remoteDataSource.sendMessage(roomId, content);
      return right(message);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
