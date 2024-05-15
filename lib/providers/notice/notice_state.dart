import 'package:team_project/models/notice_model.dart';

enum NoticeStatus {
  init,
  submitting,
  fetching, //목록을 가져오고 있는 중
  success,
  error,
}

class NoticeState {
  final NoticeStatus noticeStatus;
  final List<NoticeModel> noticeList;

  const NoticeState({
    required this.noticeStatus,
    required this.noticeList,
  });

  factory NoticeState.init() {
    return NoticeState(
      noticeStatus: NoticeStatus.init,
      noticeList: [],
    );
  }

  NoticeState copyWith({
    NoticeStatus? noticeStatus,
    List<NoticeModel>? noticeList,
  }) {
    return NoticeState(
      noticeStatus: noticeStatus ?? this.noticeStatus,
      noticeList: noticeList ?? this.noticeList,
    );
  }
}
