import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/message.dart';
import 'package:kovalen/domain/repository/messages_repository.dart';

class SendMessageUseCase implements UseCase<Message, SendMessageParams> {
  final MessagesRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    return await repository.sendMessage(params.roomId, params.content);
  }
}

class SendMessageParams {
  final String roomId;
  final String content;

  SendMessageParams({required this.roomId, required this.content});
}
