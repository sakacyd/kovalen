import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/domain/repository/admin_repository.dart';
import 'package:kovalen/data/datasources/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      final users = await remoteDataSource.getAllUsers();
      return right(users);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ChatRoom>>> getAllGroups() async {
    try {
      final groups = await remoteDataSource.getAllGroups();
      return right(groups);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> changeUserRole({required String userId, required String newRole}) async {
    try {
      await remoteDataSource.changeUserRole(userId, newRole);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser({required String userId}) async {
    try {
      await remoteDataSource.deleteUser(userId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getGroupDetails({required String roomId}) async {
    try {
      final details = await remoteDataSource.getGroupDetails(roomId);
      return right(details);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
