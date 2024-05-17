import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/models/user_model.dart';

enum ProfileStatus {
  init, //프로필스테이트를 처음 객체생성했을 때 상태
  submitting, //작업 진행중
  fetching, // 유저 게시물의 정보를 가져오고 있는 상태
  reFetching,
  success,
  error,
}

class ProfileState {
  final ProfileStatus profileStatus;
  final UserModel userModel;
  //final List<FeedModel> feedList; //feedModel 게시물의 정보가 여러개 있음으로 리스트
  final List<ClubModel> clubList;
  final bool hasNext;

  const ProfileState({
    required this.profileStatus,
    required this.userModel,
    //required this.feedList,
    required this.clubList,
    required this.hasNext,
  });

  factory ProfileState.init() {
    return ProfileState(
      profileStatus: ProfileStatus.init,
      userModel: UserModel.init(),
      //feedList: [],
      clubList: [],
      hasNext: true,
    );
  }

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    UserModel? userModel,
    //List<FeedModel>? feedList,
    List<ClubModel>? clubList,
    bool? hasNext,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      userModel: userModel ?? this.userModel,
      //feedList: feedList ?? this.feedList,
      clubList: clubList ?? this.clubList,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}
