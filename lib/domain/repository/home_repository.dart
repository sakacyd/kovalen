import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/repository/base_user_repository.dart';

import 'package:kovalen/core/common/entities/home_stats.dart';
import 'package:kovalen/core/common/entities/home_data.dart';

abstract interface class HomeRepository implements BaseUserRepository {
  @override
  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, HomeStats>> getHomeStats();

  Stream<Either<Failure, HomeData>> watchHomeData();
}
