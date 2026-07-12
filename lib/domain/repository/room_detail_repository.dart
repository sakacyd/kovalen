import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/core/common/entities/user.dart';

abstract interface class RoomDetailRepository {
  Future<Either<Failure, User>> getUserById(String userId);
  Future<Either<Failure, ChatRoom>> getGroupDetail(String roomId);
  Future<Either<Failure, List<User>>> getGroupParticipants(String roomId);
  Future<Either<Failure, ChatRoom>> updateGroupProfile(String roomId, String name, File? avatarFile);
}
