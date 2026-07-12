part of 'admin_bloc.dart';

abstract class AdminEvent {}

class AdminFetchUsersEvent extends AdminEvent {}

class AdminFetchGroupsEvent extends AdminEvent {}

class AdminChangeUserRoleEvent extends AdminEvent {
  final String userId;
  final String newRole;

  AdminChangeUserRoleEvent({required this.userId, required this.newRole});
}

class AdminDeleteUserEvent extends AdminEvent {
  final String userId;

  AdminDeleteUserEvent({required this.userId});
}
