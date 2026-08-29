import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';

abstract interface class AdminRepository {
  Future<Either<Failure, List<User>>> getAllUsers();
  Future<Either<Failure, List<ChatRoom>>> getAllGroups();
  Future<Either<Failure, void>> changeUserRole({
    required String userId,
    required String newRole,
  });
  Future<Either<Failure, void>> changeUserStatus({
    required String userId,
    required String status,
    DateTime? suspendedUntil,
  });
  Future<Either<Failure, void>> deleteUser({required String userId});
  Future<Either<Failure, Map<String, dynamic>>> getGroupDetails({
    required String roomId,
  });
}
