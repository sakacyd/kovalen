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
  Stream<Either<Failure, List<Message>>> getMessageRoomMessages(String roomId) async* {
    if (!await connectionChecker.isConnected) {
      yield left(Failure(Constants.noConnectionMessage));
      return;
    }
    try {
      await for (final messages in remoteDataSource.getMessageRoomMessages(roomId)) {
        yield right(messages);
      }
    } on ServerException catch (e) {
      yield left(Failure(e.message));
    } catch (e) {
      yield left(Failure(e.toString()));
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
