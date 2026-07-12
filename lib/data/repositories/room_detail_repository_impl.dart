import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/data/datasources/room_detail_remote_data_source.dart';
import 'package:kovalen/domain/repository/room_detail_repository.dart';

class RoomDetailRepositoryImpl implements RoomDetailRepository {
  final RoomDetailRemoteDataSource remoteDataSource;

  RoomDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> getUserById(String userId) async {
    try {
      final user = await remoteDataSource.getUserById(userId);
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, ChatRoom>> getGroupDetail(String roomId) async {
    try {
      final room = await remoteDataSource.getGroupDetail(roomId);
      return right(room);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getGroupParticipants(String roomId) async {
    try {
      final participants = await remoteDataSource.getGroupParticipants(roomId);
      return right(participants);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, ChatRoom>> updateGroupProfile(String roomId, String name, File? avatarFile) async {
    try {
      final room = await remoteDataSource.updateGroupProfile(roomId, name, avatarFile);
      return right(room);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
