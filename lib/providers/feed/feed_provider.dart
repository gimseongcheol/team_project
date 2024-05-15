import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/providers/feed/feed_state.dart';
import 'package:team_project/repositories/feed_repository.dart';

class FeedProvider extends StateNotifier<FeedState> with LocatorMixin {
  FeedProvider() : super(FeedState.init());

  Future<void> getFeedList() async {
    try {
      state = state.copyWith(feedStatus: FeedStatus.fetching);
      List<FeedModel> feedList = await read<FeedRepository>().getFeedList();

      state = state.copyWith(
        feedList: feedList,
        feedStatus: FeedStatus.success,
      );
    } on CustomException catch (_) {
      state = state.copyWith(feedStatus: FeedStatus.error);
      rethrow;
    }
  }

  Future<void> uploadFeed({
    required List<String> files,
    required String title,
    required String desc,
  }) async {
    try {
      state = state.copyWith(feedStatus: FeedStatus.submitting);

      String uid = read<User>().uid;
      FeedModel feedModel = await read<FeedRepository>().uploadFeed(
        files: files,
        desc: desc,
        title: title,
        uid: uid,
      );
      //상태관리 갱신
      state = state.copyWith(
          feedStatus: FeedStatus.success,
          //새롭게 생성된 게시물 갱신
          feedList: [feedModel, ...state.feedList]);
    } on CustomException catch (_) {
      state = state.copyWith(feedStatus: FeedStatus.error);
      rethrow;
    }
  }
}