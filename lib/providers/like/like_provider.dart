import 'package:state_notifier/state_notifier.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/providers/like/like_state.dart';
import 'package:team_project/providers/user/user_state.dart';
import 'package:team_project/repositories/like_repository.dart';

class LikeProvider extends StateNotifier<LikeState> with LocatorMixin {
  LikeProvider() : super(LikeState.init());

  void deleteClub({
    required String clubId,
  }) {
    state = state.copyWith(likeStatus: LikeStatus.submitting);

    try {
      List<ClubModel> newLikeList =
      state.likeList.where((element) => element.clubId != clubId).toList();

      state = state.copyWith(
        likeStatus: LikeStatus.success,
        likeList: newLikeList,
      );
    } on CustomException catch (_) {
      state = state.copyWith(likeStatus: LikeStatus.error);
      rethrow;
    }
  }

  void likeClub({
    required ClubModel newClubModel,
  }) {
    state = state.copyWith(likeStatus: LikeStatus.submitting);

    try {
      List<ClubModel> newLikeList = [];

      int index = state.likeList
          .indexWhere((clubModel) => clubModel.clubId == newClubModel.clubId);

      if (index == -1) {
        newLikeList = [newClubModel, ...state.likeList];
      } else {
        state.likeList.removeAt(index);
        newLikeList = state.likeList.toList();
      }

      state = state.copyWith(
        likeStatus: LikeStatus.success,
        likeList: newLikeList,
      );
    } on CustomException catch (_) {
      state = state.copyWith(likeStatus: LikeStatus.error);
      rethrow;
    }
  }

  Future<void> getLikeList({
    String? clubId,
  }) async {
    final int likeLength = 3;
    state = clubId == null
        ? state.copyWith(likeStatus: LikeStatus.fetching)
        : state.copyWith(likeStatus: LikeStatus.reFetching);

    try {
      String uid = read<UserState>().userModel.uid;
      List<ClubModel> likeList = await read<LikeRepository>().getLikeList(
        uid: uid,
        clubId: clubId,
        likeLength: likeLength,
      );

      List<ClubModel> newLikeList = [
        if (clubId != null) ...state.likeList,
        ...likeList,
      ];

      state = state.copyWith(
        likeStatus: LikeStatus.success,
        likeList: newLikeList,
        hasNext: likeList.length == likeLength,
      );
    } on CustomException catch (_) {
      state = state.copyWith(likeStatus: LikeStatus.error);
      rethrow;
    }
  }
}