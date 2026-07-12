import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/domain/repository/room_detail_repository.dart';

class UpdateGroupProfileParams {
  final String roomId;
  final String name;
  final File? avatarFile;

  UpdateGroupProfileParams({
    required this.roomId,
    required this.name,
    this.avatarFile,
  });
}

class UpdateGroupProfile implements UseCase<ChatRoom, UpdateGroupProfileParams> {
  final RoomDetailRepository repository;

  UpdateGroupProfile(this.repository);

  @override
  Future<Either<Failure, ChatRoom>> call(UpdateGroupProfileParams params) async {
    return await repository.updateGroupProfile(params.roomId, params.name, params.avatarFile);
  }
}
