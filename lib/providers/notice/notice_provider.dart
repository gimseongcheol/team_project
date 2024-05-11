import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/notice_model.dart';
import 'package:team_project/providers/notice/notice_state.dart';
import 'package:team_project/repositories/notice_repository.dart';

class NoticeProvider extends StateNotifier<NoticeState> with LocatorMixin {
  NoticeProvider() : super(NoticeState.init());

  Future<void> getNoticeList() async {
    try{
      state = state.copyWith(noticeStatus: NoticeStatus.fetching);

      List<NoticeModel> noticeList = await read<NoticeRepository>().getNoticeList();

      state = state.copyWith(
        noticeList: noticeList,
        noticeStatus: NoticeStatus.success,
      );

    }on CustomException catch (_) {
      state = state.copyWith(noticeStatus: NoticeStatus.error);
      rethrow;
    }
  }

  Future<void> uploadNotice({
    required List<String> files,
    required String title,
    required String desc,
  }) async {
    try {
      state = state.copyWith(noticeStatus: NoticeStatus.submitting);

      String clubId = read<ClubModel>().clubId;
      await read<NoticeRepository>().uploadNotice(
        files: files,
        title: title,
        desc: desc,
        clubId: clubId,
      );
      state = state.copyWith(noticeStatus: NoticeStatus.success);
    } on CustomException catch (_) {
      state = state.copyWith(noticeStatus: NoticeStatus.error);
      rethrow;
    }
  }
}