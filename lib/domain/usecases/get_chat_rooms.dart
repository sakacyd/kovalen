import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/domain/repository/messages_repository.dart';

class GetChatRooms implements UseCase<List<ChatRoom>, NoParams> {
  final MessagesRepository repository;

  GetChatRooms(this.repository);

  @override
  Future<Either<Failure, List<ChatRoom>>> call(NoParams params) async {
    return await repository.getChatRooms();
  }
}
