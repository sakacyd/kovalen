import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/admin_repository.dart';

class GetGroupDetailsForAdmin implements UseCase<Map<String, dynamic>, String> {
  final AdminRepository repository;

  GetGroupDetailsForAdmin(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String roomId) async {
    return await repository.getGroupDetails(roomId: roomId);
  }
}
