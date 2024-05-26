import 'package:state_notifier/state_notifier.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/providers/like/feed_like_state.dart';
import 'package:team_project/providers/like/like_state.dart';
import 'package:team_project/providers/user/user_state.dart';
import 'package:team_project/repositories/feed_like_repository.dart';

class FeedLikeProvider extends StateNotifier<FeedLikeState> with LocatorMixin {
  FeedLikeProvider() : super(FeedLikeState.init());

  void deleteFeed({
    required String feedId,
  }) {
    state = state.copyWith(likeStatus: FeedLikeStatus.submitting);

    try {
      List<FeedModel> newLikeList =
      state.likeList.where((element) => element.feedId != feedId).toList();

      state = state.copyWith(
        likeStatus: FeedLikeStatus.success,
        likeList: newLikeList,
      );
    } on CustomException catch (_) {
      state = state.copyWith(likeStatus: FeedLikeStatus.error);
      rethrow;
    }
  }

  void likeFeed({
    required FeedModel newFeedModel,
  }) {
    state = state.copyWith(likeStatus: FeedLikeStatus.submitting);

    try {
      List<FeedModel> newLikeList = [];

      int index = state.likeList
          .indexWhere((feedModel) => feedModel.feedId == newFeedModel.feedId);

      if (index == -1) {
        newLikeList = [newFeedModel, ...state.likeList];
      } else {
        state.likeList.removeAt(index);
        newLikeList = state.likeList.toList();
      }

      state = state.copyWith(
        likeStatus: FeedLikeStatus.success,
        likeList: newLikeList,
      );
    } on CustomException catch (_) {
      state = state.copyWith(likeStatus: FeedLikeStatus.error);
      rethrow;
    }
  }

  Future<void> getLikeList({
    String? feedId,
  }) async {
    final int likeLength = 3;
    state = feedId == null
        ? state.copyWith(likeStatus: FeedLikeStatus.fetching)
        : state.copyWith(likeStatus: FeedLikeStatus.reFetching);

    try {
      String uid = read<UserState>().userModel.uid;
      List<FeedModel> likeList = await read<FeedLikeRepository>().getFeedLikeList(
        uid: uid,
        feedId: feedId,
        likeLength: likeLength,
      );

      List<FeedModel> newLikeList = [
        if (feedId != null) ...state.likeList,
        ...likeList,
      ];

      state = state.copyWith(
        likeStatus: FeedLikeStatus.success,
        likeList: newLikeList,
        hasNext: likeList.length == likeLength,
      );
    } on CustomException catch (_) {
      state = state.copyWith(likeStatus: FeedLikeStatus.error);
      rethrow;
    }
  }
}