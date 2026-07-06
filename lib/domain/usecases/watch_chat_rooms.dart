import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/domain/repository/messages_repository.dart';

class WatchChatRooms implements StreamUseCase<List<ChatRoom>, NoParams> {
  final MessagesRepository repository;

  WatchChatRooms(this.repository);

  @override
  Stream<Either<Failure, List<ChatRoom>>> call(NoParams params) {
    return repository.watchChatRooms();
  }
}
