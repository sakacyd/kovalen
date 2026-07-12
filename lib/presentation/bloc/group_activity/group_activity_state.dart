part of 'group_activity_bloc.dart';

abstract class GroupActivityState {}

class GroupActivityInitial extends GroupActivityState {}

class GroupActivityLoading extends GroupActivityState {}

class GroupActivitySuccess extends GroupActivityState {
  final GroupActivity activity;
  GroupActivitySuccess(this.activity);
}

class GroupActivityFailure extends GroupActivityState {
  final String message;
  GroupActivityFailure(this.message);
}
