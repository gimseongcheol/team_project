import 'package:team_project/models/club_model.dart';

enum ReportStatus {
  init,
  submitting,
  fetching,
  reFetching,
  success,
  error,
}

class ReportState {
  final ReportStatus reportStatus;
  final List<ClubModel> reportList;
  final bool hasNext;

  const ReportState({
    required this.reportStatus,
    required this.reportList,
    required this.hasNext,
  });

  factory ReportState.init() {
    return ReportState(
      reportStatus: ReportStatus.init,
      reportList: [],
      hasNext: true,
    );
  }

  ReportState copyWith({
    ReportStatus? reportStatus,
    List<ClubModel>? reportList,
    bool? hasNext,
  }) {
    return ReportState(
      reportStatus: reportStatus ?? this.reportStatus,
      reportList: reportList ?? this.reportList,
      hasNext: hasNext ?? this.hasNext,
    );
  }

  @override
  String toString() {
    return 'ReportState{reportStatus: $reportStatus, reportList: $reportList, hasNext: $hasNext}';
  }
}