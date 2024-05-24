import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/providers/user/user_state.dart';
import 'package:team_project/repositories/club_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class ClubProvider extends StateNotifier<ClubState> with LocatorMixin {
  ClubProvider() : super(ClubState.init());

  Future<void> cancelLike({
    required ClubModel clubModel,
  }) async {
    state = state.copyWith(clubStatus: ClubStatus.submitting);

    try {
      await read<ClubRepository>().cancelLike(clubModel: clubModel);

      List<ClubModel> newClubList = state.clubList
          .where((element) => element.clubId != clubModel.clubId)
          .toList();

      state = state.copyWith(
        clubStatus: ClubStatus.success,
        clubList: newClubList,
      );
    } on CustomException catch (_) {
      state = state.copyWith(clubStatus: ClubStatus.error);
      rethrow;
    }
  }
  Future<void> deleteClub({
    required ClubModel clubModel,
  }) async {
    state = state.copyWith(clubStatus: ClubStatus.submitting);

    try {
      await read<ClubRepository>().deleteClub(clubModel: clubModel);

      List<ClubModel> newClubList = state.clubList
          .where((element) => element.clubId != clubModel.clubId)
          .toList();

      state = state.copyWith(
        clubStatus: ClubStatus.success,
        clubList: newClubList,
      );
    } on CustomException catch (_) {
      state = state.copyWith(clubStatus: ClubStatus.error);
      rethrow;
    }
  }

  Future<ClubModel> likeClub({
    required String clubId,
    required List<String> clubLikes,
  }) async {
    state = state.copyWith(clubStatus: ClubStatus.submitting);

    try {
      UserModel userModel = read<UserState>().userModel;

      ClubModel clubModel = await read<ClubRepository>().likeClub(
        clubId: clubId,
        clubLikes: clubLikes,
        uid: userModel.uid,
        userLikes: userModel.likes,
      );

      List<ClubModel> newClubList = state.clubList.map((club) {
        return club.clubId == clubId ? clubModel : club;
      }).toList();

      state = state.copyWith(
        clubStatus: ClubStatus.success,
        clubList: newClubList,
      );

      return clubModel;
    } on CustomException catch (_) {
      state = state.copyWith(clubStatus: ClubStatus.error);
      rethrow;
    }
  }

  Future<void> getClubList() async {
    try {
      state = state.copyWith(clubStatus: ClubStatus.fetching);

      List<ClubModel> clubList = await read<ClubRepository>().getClubList();
      state = state.copyWith(
        clubList: clubList,
        clubStatus: ClubStatus.success,
      );
    } on CustomException catch (_) {
      state = state.copyWith(clubStatus: ClubStatus.error);
      rethrow;
    }
  }

  Future<void> uploadClub({
    required List<String> files,
    required String clubName,
    required String professorName,
    required String presidentName,
    required String shortComment,
    required String fullComment,
    required String clubType,
    required String depart,
    required String call,
  }) async {
    try {
      state = state.copyWith(clubStatus: ClubStatus.submitting);

      String uid = read<User>().uid;
      ClubModel clubModel = await read<ClubRepository>().uploadClub(
        files: files,
        clubName: clubName,
        professorName: professorName,
        presidentName: presidentName,
        shortComment: shortComment,
        fullComment: fullComment,
        clubType: clubType,
        depart: depart,
        call: call,
        uid: uid,
      );
      //상태관리 갱신
      state = state.copyWith(
          clubStatus: ClubStatus.success,
          //새롭게 생성된 게시물 갱신
          clubList: [clubModel, ...state.clubList]);
    } on CustomException catch (_) {
      state = state.copyWith(clubStatus: ClubStatus.error);
      rethrow;
    }
  }
}
