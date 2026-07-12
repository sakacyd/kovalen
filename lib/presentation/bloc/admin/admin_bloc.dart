import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/usecases/admin/get_all_users.dart';
import 'package:kovalen/domain/usecases/admin/change_user_role.dart';
import 'package:kovalen/domain/usecases/admin/delete_user.dart';
import 'package:kovalen/domain/usecases/admin/get_all_groups.dart';
import 'package:kovalen/domain/usecases/admin/get_group_details_for_admin.dart';
import 'package:kovalen/core/common/entities/group_schedule.dart';
import 'package:kovalen/core/common/entities/group_activity.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetAllUsers _getAllUsers;
  final GetAllGroups _getAllGroups;
  final ChangeUserRole _changeUserRole;
  final DeleteUser _deleteUser;
  final GetGroupDetailsForAdmin _getGroupDetailsForAdmin;

  AdminBloc({
    required GetAllUsers getAllUsers,
    required GetAllGroups getAllGroups,
    required ChangeUserRole changeUserRole,
    required DeleteUser deleteUser,
    required GetGroupDetailsForAdmin getGroupDetailsForAdmin,
  })  : _getAllUsers = getAllUsers,
        _getAllGroups = getAllGroups,
        _changeUserRole = changeUserRole,
        _deleteUser = deleteUser,
        _getGroupDetailsForAdmin = getGroupDetailsForAdmin,
        super(AdminInitial()) {
    on<AdminFetchUsersEvent>(_onFetchUsers);
    on<AdminFetchGroupsEvent>(_onFetchGroups);
    on<AdminFetchGroupDetailsEvent>(_onFetchGroupDetails);
    on<AdminChangeUserRoleEvent>(_onChangeRole);
    on<AdminDeleteUserEvent>(_onDeleteUser);
  }

  void _onFetchUsers(AdminFetchUsersEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await _getAllUsers(NoParams());
    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (users) => emit(AdminUsersLoaded(users)),
    );
  }

  void _onFetchGroups(AdminFetchGroupsEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await _getAllGroups(NoParams());
    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (groups) => emit(AdminGroupsLoaded(groups)),
    );
  }

  void _onFetchGroupDetails(AdminFetchGroupDetailsEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    final result = await _getGroupDetailsForAdmin(event.roomId);
    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (details) {
        final schedules = details['schedules'] as List<GroupSchedule>;
        final activities = details['activities'] as List<GroupActivity>;
        emit(AdminGroupDetailsLoaded(schedules: schedules, activities: activities));
      },
    );
  }

  void _onChangeRole(AdminChangeUserRoleEvent event, Emitter<AdminState> emit) async {
    final result = await _changeUserRole(ChangeUserRoleParams(userId: event.userId, newRole: event.newRole));
    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) {
        emit(AdminActionSuccess('Berhasil mengubah role pengguna.'));
        add(AdminFetchUsersEvent()); // Refresh data
      },
    );
  }

  void _onDeleteUser(AdminDeleteUserEvent event, Emitter<AdminState> emit) async {
    final result = await _deleteUser(DeleteUserParams(userId: event.userId));
    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) {
        emit(AdminActionSuccess('Berhasil menghapus pengguna.'));
        add(AdminFetchUsersEvent()); // Refresh data
      },
    );
  }
}
