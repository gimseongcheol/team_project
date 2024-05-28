import 'package:firebase_auth/firebase_auth.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/schedule_model.dart';
import 'package:team_project/providers/schedule/schedule_state.dart';
import 'package:team_project/repositories/schedule_repository.dart';

class ScheduleProvider extends StateNotifier<ScheduleState> with LocatorMixin {
  ScheduleProvider() : super(ScheduleState.init());

  Future<void> getScheduleList({
    required String clubId,
  }) async {
    try {
      state = state.copyWith(scheduleStatus: ScheduleStatus.fetching);
      List<ScheduleModel> scheduleList =
      await read<ScheduleRepository>().getScheduleList(clubId: clubId);

      state = state.copyWith(
        scheduleList: scheduleList,
        scheduleStatus: ScheduleStatus.success,
      );
    } on CustomException catch (_) {
      state = state.copyWith(scheduleStatus: ScheduleStatus.error);
      rethrow;
    }
  }

  Future<void> uploadSchedule({
    required String cont,
    required String clubId,
  }) async {
    try {
      state = state.copyWith(scheduleStatus: ScheduleStatus.submitting);

      String uid = read<User>().uid;
      ScheduleModel scheduleModel = await read<ScheduleRepository>()
          .uploadSchedule(
        cont: cont,
        uid: uid,
        clubId: clubId,
      );
      //상태관리 갱신
      state = state.copyWith(
          scheduleStatus: ScheduleStatus.success,
          //새롭게 생성된 게시물 갱신
          scheduleList: [scheduleModel, ...state.scheduleList]);
    } on CustomException catch (_) {
      state = state.copyWith(scheduleStatus: ScheduleStatus.error);
      rethrow;
    }
  }
}