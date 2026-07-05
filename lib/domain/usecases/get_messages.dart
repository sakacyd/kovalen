import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/message.dart';
import 'package:kovalen/domain/repository/messages_repository.dart';

class GetMessages implements UseCase<List<Message>, String> {
  final MessagesRepository repository;

  GetMessages(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(String roomId) async {
    return await repository.getMessages(roomId);
  }
}
