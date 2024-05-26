import 'package:team_project/models/feed_model.dart';

enum FeedLikeStatus {
  init,
  submitting,
  fetching,
  reFetching,
  success,
  error,
}

class FeedLikeState {
  final FeedLikeStatus likeStatus;
  final List<FeedModel> likeList;
  final bool hasNext;

  const FeedLikeState({
    required this.likeStatus,
    required this.likeList,
    required this.hasNext,
  });

  factory FeedLikeState.init() {
    return FeedLikeState(
      likeStatus: FeedLikeStatus.init,
      likeList: [],
      hasNext: true,
    );
  }

  FeedLikeState copyWith({
    FeedLikeStatus? likeStatus,
    List<FeedModel>? likeList,
    bool? hasNext,
  }) {
    return FeedLikeState(
      likeStatus: likeStatus ?? this.likeStatus,
      likeList: likeList ?? this.likeList,
      hasNext: hasNext ?? this.hasNext,
    );
  }

  @override
  String toString() {
    return 'FeedLikeState{likeStatus: $likeStatus, likeList: $likeList, hasNext: $hasNext}';
  }
}