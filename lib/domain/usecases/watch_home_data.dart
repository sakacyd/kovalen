import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/home_data.dart';
import 'package:kovalen/domain/repository/home_repository.dart';
import 'dart:async';

class WatchHomeData {
  final HomeRepository repository;

  WatchHomeData(this.repository);

  Stream<Either<Failure, HomeData>> call(NoParams params) {
    return repository.watchHomeData();
  }
}
