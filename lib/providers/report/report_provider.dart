

import 'package:state_notifier/state_notifier.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/providers/report/report_state.dart';
import 'package:team_project/providers/user/user_state.dart';
import 'package:team_project/repositories/report_repository.dart';

class ReportProvider extends StateNotifier<ReportState> with LocatorMixin {
  ReportProvider() : super(ReportState.init());

  void deleteClub({
    required String clubId,
  }) {
    state = state.copyWith(reportStatus: ReportStatus.submitting);

    try {
      List<ClubModel> newReportList =
      state.reportList.where((element) => element.clubId != clubId).toList();

      state = state.copyWith(
        reportStatus: ReportStatus.success,
        reportList: newReportList,
      );
    } on CustomException catch (_) {
      state = state.copyWith(reportStatus: ReportStatus.error);
      rethrow;
    }
  }

  void reportClub({
    required ClubModel newClubModel,
  }) {
    state = state.copyWith(reportStatus: ReportStatus.submitting);

    try {
      List<ClubModel> newReportList = [];

      int index = state.reportList
          .indexWhere((clubModel) => clubModel.clubId == newClubModel.clubId);

      if (index == -1) {
        newReportList = [newClubModel, ...state.reportList];
      } else {
        state.reportList.removeAt(index);
        newReportList = state.reportList.toList();
      }

      state = state.copyWith(
        reportStatus: ReportStatus.success,
        reportList: newReportList,
      );
    } on CustomException catch (_) {
      state = state.copyWith(reportStatus: ReportStatus.error);
      rethrow;
    }
  }

  Future<void> getReportList({
    String? clubId,
  }) async {
    final int reportLength = 3;
    state = clubId == null
        ? state.copyWith(reportStatus: ReportStatus.fetching)
        : state.copyWith(reportStatus: ReportStatus.reFetching);

    try {
      String uid = read<UserState>().userModel.uid;
      List<ClubModel> reportList = await read<ReportRepository>().getReportList(
        uid: uid,
        clubId: clubId,
        reportLength: reportLength,

      );


      List<ClubModel> newReportList = [
        if (clubId != null) ...state.reportList,
        ...reportList,
      ];

      state = state.copyWith(
        reportStatus: ReportStatus.success,
        reportList: newReportList,
        hasNext: reportList.length == reportLength,
      );
    } on CustomException catch (_) {
      state = state.copyWith(reportStatus: ReportStatus.error);
      rethrow;
    }
  }
}