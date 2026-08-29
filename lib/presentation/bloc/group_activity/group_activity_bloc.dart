import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/entities/group_activity.dart';
import 'package:kovalen/domain/usecases/group_activity/create_group_activity.dart';

part 'group_activity_event.dart';
part 'group_activity_state.dart';

class GroupActivityBloc extends Bloc<GroupActivityEvent, GroupActivityState> {
  final CreateGroupActivity _createGroupActivity;

  GroupActivityBloc({required CreateGroupActivity createGroupActivity})
    : _createGroupActivity = createGroupActivity,
      super(GroupActivityInitial()) {
    on<SubmitGroupActivityEvent>(_onSubmitActivity);
  }

  void _onSubmitActivity(
    SubmitGroupActivityEvent event,
    Emitter<GroupActivityState> emit,
  ) async {
    emit(GroupActivityLoading());
    final result = await _createGroupActivity(
      CreateGroupActivityParams(
        scheduleId: event.scheduleId,
        roomId: event.roomId,
        activitySummary: event.activitySummary,
        materialCovered: event.materialCovered,
        nextGoals: event.nextGoals,
      ),
    );

    result.fold(
      (failure) => emit(GroupActivityFailure(failure.message)),
      (activity) => emit(GroupActivitySuccess(activity)),
    );
  }
}
