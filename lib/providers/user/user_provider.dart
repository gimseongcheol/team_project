import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/providers/user/user_state.dart';
import 'package:team_project/repositories/profile_repository.dart';

class UserProvider extends StateNotifier<UserState> with LocatorMixin{
  UserProvider() : super(UserState.init());//UserProvider 객체 생성할때, UserState도 같이 생성한다.

  //현재 접속중인 userid를 가져와서
  //firestore users collection을 가져와서 동일한 문서id를 갖는 데이터를 가져오는 작업
  Future<void> getUserInfo() async{
  //profile_state 코드를 그대로 호출해서 사용할 계획 -> uid(userid)를 가져와서 UserModel로 반환시키는 코드 재사용
    try{
      String uid = read<User>().uid;
      UserModel userModel = await read<ProfileRepository>().getProfile(uid: uid);
      state = state.copyWith(userModel: userModel); //state에 대입해준 후 상태관리에 저장 됨
    }on CustomException catch(_){
      rethrow;
    }
  }
}