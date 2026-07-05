part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);
}

class ProfileSuccess extends ProfileState {
  final User user;
  ProfileSuccess(this.user);
}
