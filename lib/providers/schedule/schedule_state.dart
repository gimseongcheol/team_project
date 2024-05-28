import 'package:team_project/models/schedule_model.dart';

enum ScheduleStatus {
  init,
  submitting,
  fetching, //목록을 가져오고 있는 중
  success,
  error,
}

class ScheduleState {
  final ScheduleStatus scheduleStatus;
  final List<ScheduleModel> scheduleList;

  const ScheduleState({
    required this.scheduleStatus,
    required this.scheduleList,
  });

  factory ScheduleState.init() {
    return ScheduleState(
      scheduleStatus: ScheduleStatus.init,
      scheduleList: [],
    );
  }

  ScheduleState copyWith({
    ScheduleStatus? scheduleStatus,
    List<ScheduleModel>? scheduleList,
  }) {
    return ScheduleState(
      scheduleStatus: scheduleStatus ?? this.scheduleStatus,
      scheduleList: scheduleList ?? this.scheduleList,
    );
  }
}
