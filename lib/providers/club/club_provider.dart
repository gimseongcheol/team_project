import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/repositories/club_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class ClubProvider extends StateNotifier<ClubState> with LocatorMixin {
  ClubProvider() : super(ClubState.init());

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
        clubName : clubName,
        professorName : professorName,
        presidentName: presidentName,
        shortComment: shortComment,
        fullComment: fullComment,
        clubType: clubType,
        depart: depart,
        call : call,
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
