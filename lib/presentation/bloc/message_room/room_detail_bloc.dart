import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/usecases/message_room/get_user_by_id.dart';
import 'package:kovalen/domain/usecases/message_room/get_group_detail.dart';
import 'package:kovalen/domain/usecases/message_room/update_group_profile.dart';
import 'package:kovalen/domain/usecases/message_room/add_user_to_group.dart';

part 'room_detail_event.dart';
part 'room_detail_state.dart';

class RoomDetailBloc extends Bloc<RoomDetailEvent, RoomDetailState> {
  final GetUserById _getUserById;
  final GetGroupDetail _getGroupDetail;
  final UpdateGroupProfile _updateGroupProfile;
  final AddUserToGroup _addUserToGroup;

  RoomDetailBloc({
    required GetUserById getUserById,
    required GetGroupDetail getGroupDetail,
    required UpdateGroupProfile updateGroupProfile,
    required AddUserToGroup addUserToGroup,
  }) : _getUserById = getUserById,
       _getGroupDetail = getGroupDetail,
       _updateGroupProfile = updateGroupProfile,
       _addUserToGroup = addUserToGroup,
       super(RoomDetailInitial()) {
    on<FetchPersonalRoomDetailEvent>(_onFetchPersonalRoomDetail);
    on<FetchGroupRoomDetailEvent>(_onFetchGroupRoomDetail);
    on<UpdateGroupProfileEvent>(_onUpdateGroupProfileEvent);
    on<AddUserToGroupEvent>(_onAddUserToGroupEvent);
  }

  Future<void> _onFetchPersonalRoomDetail(
    FetchPersonalRoomDetailEvent event,
    Emitter<RoomDetailState> emit,
  ) async {
    emit(RoomDetailLoading());
    final res = await _getUserById(event.userId);
    res.fold(
      (l) => emit(RoomDetailFailure(l.message)),
      (user) => emit(PersonalRoomDetailLoaded(user)),
    );
  }

  Future<void> _onFetchGroupRoomDetail(
    FetchGroupRoomDetailEvent event,
    Emitter<RoomDetailState> emit,
  ) async {
    emit(RoomDetailLoading());
    final res = await _getGroupDetail(event.roomId);
    res.fold(
      (l) => emit(RoomDetailFailure(l.message)),
      (data) => emit(
        GroupRoomDetailLoaded(room: data.room, participants: data.participants),
      ),
    );
  }

  Future<void> _onUpdateGroupProfileEvent(
    UpdateGroupProfileEvent event,
    Emitter<RoomDetailState> emit,
  ) async {
    final currentState = state;
    emit(RoomDetailLoading());

    final res = await _updateGroupProfile(
      UpdateGroupProfileParams(
        roomId: event.roomId,
        name: event.name,
        avatarFile: event.avatarFile,
      ),
    );

    res.fold(
      (l) {
        emit(RoomDetailFailure(l.message));
        if (currentState is GroupRoomDetailLoaded) {
          emit(currentState); // fallback
        }
      },
      (room) {
        if (currentState is GroupRoomDetailLoaded) {
          emit(
            GroupRoomDetailLoaded(
              room: room,
              participants: currentState.participants,
            ),
          );
        } else {
          emit(GroupRoomDetailLoaded(room: room, participants: const []));
        }
      },
    );
  }

  Future<void> _onAddUserToGroupEvent(
    AddUserToGroupEvent event,
    Emitter<RoomDetailState> emit,
  ) async {
    emit(RoomDetailLoading());
    final res = await _addUserToGroup(
      AddUserToGroupParams(roomId: event.roomId, userId: event.userId),
    );
    res.fold(
      (l) => emit(RoomDetailFailure(l.message)),
      (r) => emit(AddUserToGroupSuccess()),
    );
  }
}
