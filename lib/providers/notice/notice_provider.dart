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

  Future<void> getNoticeList({
    required String clubId,
  }) async {
    try {
      state = state.copyWith(noticeStatus: NoticeStatus.fetching);
      List<NoticeModel> noticeList =
      await read<NoticeRepository>().getNoticeList(clubId: clubId);

      state = state.copyWith(
        noticeList: noticeList,
        noticeStatus: NoticeStatus.success,
      );
    } on CustomException catch (_) {
      state = state.copyWith(noticeStatus: NoticeStatus.error);
      rethrow;
    }
  }

  Future<void> uploadNotice({
    required List<String> files,
    required String title,
    required String desc,
    required String clubId,
  }) async {
    try {
      state = state.copyWith(noticeStatus: NoticeStatus.submitting);

      String uid = read<User>().uid;
      NoticeModel noticeModel = await read<NoticeRepository>().uploadNotice(
        files: files,
        desc: desc,
        title: title,
        uid: uid,
        clubId: clubId,
      );
      //상태관리 갱신
      state = state.copyWith(
          noticeStatus: NoticeStatus.success,
          //새롭게 생성된 게시물 갱신
          noticeList: [noticeModel, ...state.noticeList]);
    } on CustomException catch (_) {
      state = state.copyWith(noticeStatus: NoticeStatus.error);
      rethrow;
    }
  }
}