import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/entities/group_schedule.dart';
import 'package:kovalen/domain/usecases/group_schedule/get_active_schedule.dart';
import 'package:kovalen/domain/usecases/group_schedule/create_schedule.dart';
import 'package:kovalen/domain/usecases/group_schedule/complete_schedule.dart';

part 'group_schedule_event.dart';
part 'group_schedule_state.dart';

class GroupScheduleBloc extends Bloc<GroupScheduleEvent, GroupScheduleState> {
  final GetActiveSchedule _getActiveSchedule;
  final CreateSchedule _createSchedule;
  final CompleteSchedule _completeSchedule;

  GroupScheduleBloc({
    required GetActiveSchedule getActiveSchedule,
    required CreateSchedule createSchedule,
    required CompleteSchedule completeSchedule,
  })  : _getActiveSchedule = getActiveSchedule,
        _createSchedule = createSchedule,
        _completeSchedule = completeSchedule,
        super(GroupScheduleInitial()) {
    on<FetchActiveScheduleEvent>(_onFetchActiveSchedule);
    on<CreateGroupScheduleEvent>(_onCreateSchedule);
    on<CompleteGroupScheduleEvent>(_onCompleteSchedule);
  }

  void _onFetchActiveSchedule(FetchActiveScheduleEvent event, Emitter<GroupScheduleState> emit) async {
    emit(GroupScheduleLoading());
    final result = await _getActiveSchedule(GetActiveScheduleParams(roomId: event.roomId));
    result.fold(
      (failure) => emit(GroupScheduleError(failure.message)),
      (schedule) => emit(GroupScheduleLoaded(schedule)),
    );
  }

  void _onCreateSchedule(CreateGroupScheduleEvent event, Emitter<GroupScheduleState> emit) async {
    emit(GroupScheduleLoading());
    final result = await _createSchedule(CreateScheduleParams(
      roomId: event.roomId,
      title: event.title,
      meetingTime: event.meetingTime,
      locationName: event.locationName,
      locationUrl: event.locationUrl,
    ));
    result.fold(
      (failure) => emit(GroupScheduleError(failure.message)),
      (schedule) {
        emit(GroupScheduleActionSuccess('Jadwal berhasil dibuat.'));
        emit(GroupScheduleLoaded(schedule));
      },
    );
  }

  void _onCompleteSchedule(CompleteGroupScheduleEvent event, Emitter<GroupScheduleState> emit) async {
    emit(GroupScheduleLoading());
    final result = await _completeSchedule(CompleteScheduleParams(scheduleId: event.scheduleId));
    result.fold(
      (failure) => emit(GroupScheduleError(failure.message)),
      (_) {
        emit(GroupScheduleActionSuccess('Jadwal ditandai selesai.'));
        emit(GroupScheduleLoaded(null));
      },
    );
  }
}
