import 'package:team_project/models/feed_model.dart';

enum FeedStatus {
  init,
  submitting,
  fetching, //목록을 가져오고 있는 중
  success,
  error,
}

class FeedState {
  final FeedStatus feedStatus;
  final List<FeedModel> feedList;

  const FeedState({
    required this.feedStatus,
    required this.feedList,
  });

  factory FeedState.init() {
    return FeedState(
      feedStatus: FeedStatus.init,
      feedList: [],
    );
  }

  FeedState copyWith({
    FeedStatus? feedStatus,
    List<FeedModel>? feedList,
  }) {
    return FeedState(
      feedStatus: feedStatus ?? this.feedStatus,
      feedList: feedList ?? this.feedList,
    );
  }
}
