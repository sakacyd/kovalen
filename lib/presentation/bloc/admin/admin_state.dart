part of 'admin_bloc.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminUsersLoaded extends AdminState {
  final List<User> users;

  AdminUsersLoaded(this.users);
}

class AdminGroupsLoaded extends AdminState {
  final List<ChatRoom> groups;

  AdminGroupsLoaded(this.groups);
}

class AdminActionSuccess extends AdminState {
  final String message;

  AdminActionSuccess(this.message);
}

class AdminError extends AdminState {
  final String message;

  AdminError(this.message);
}
