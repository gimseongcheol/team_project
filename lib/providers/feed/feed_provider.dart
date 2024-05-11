import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/providers/feed/feed_state.dart';
import 'package:team_project/repositories/feed_repository.dart';

class FeedProvider extends StateNotifier<FeedState> with LocatorMixin {
  FeedProvider() : super(FeedState.init());

  Future<void> getFeedList() async {
    try{
      state = state.copyWith(feedStatus: FeedStatus.fetching);

      List<FeedModel> feedList = await read<FeedRepository>().getFeedList();

      state = state.copyWith(
        feedList: feedList,
        feedStatus: FeedStatus.success,
      );

    }on CustomException catch (_) {
      state = state.copyWith(feedStatus: FeedStatus.error);
      rethrow;
    }
  }

  Future<void> uploadFeed({
    required List<String> files,
    required String desc,
    required String title,
  }) async {
    try {
      state = state.copyWith(feedStatus: FeedStatus.submitting);

      String clubId = read<ClubModel>().clubId;
      await read<FeedRepository>().uploadFeed(
        files: files,
        desc: desc,
        title: title,
        clubId: clubId,
      );
      state = state.copyWith(feedStatus: FeedStatus.success);
    } on CustomException catch (_) {
      state = state.copyWith(feedStatus: FeedStatus.error);
      rethrow;
    }
  }
}
