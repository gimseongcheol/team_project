import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/providers/profile/profile_state.dart';
import 'package:team_project/repositories/profile_repository.dart';

class ProfileProvider extends StateNotifier<ProfileState> with LocatorMixin {
  ProfileProvider() : super(ProfileState.init());

  Future<void> getProfile({
    required String uid,
  }) async {
    state = state.copyWith(profileStatus: ProfileStatus.fetching);
    try {
      //read를 사용하기 위해 with LocatorMixin추가
      UserModel userModel = await read<ProfileRepository>().getProfile(
          uid: uid);

      state = state.copyWith(
        profileStatus: ProfileStatus.success,
        userModel: userModel,
      );
    } on CustomException catch (_) {
      state = state.copyWith(profileStatus: ProfileStatus.error);
    }
  }
}
