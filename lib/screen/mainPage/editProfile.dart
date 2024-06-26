import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/providers/auth/auth_provider.dart'
as myAuthProvider;
import 'package:team_project/providers/profile/profile_provider.dart';
import 'package:team_project/providers/profile/profile_state.dart';
import 'package:team_project/providers/user/user_state.dart';
import 'package:team_project/screen/auth/search_password2.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:team_project/utils/logger.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    super.key,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ScrollController _scrollController = ScrollController();
  late final ProfileProvider profileProvider;

  @override
  void initState() {
    super.initState();
    //_scrollController.addListener(scrollListener);
    profileProvider = context.read<ProfileProvider>();
    _getProfile();
  }

  // @override
  // void dispose() {
  //   _scrollController.removeListener(scrollListener);
  //  _scrollController.dispose();
  //   super.dispose();
  // }


  void _getProfile() {
    String uid = context.read<UserState>().userModel.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await profileProvider.getProfile(uid: uid);
      } on CustomException catch (e) {
        errorDialogWidget(context, e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            _buildProfileInfo(),
            _buildNotificationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    ProfileState profileState = context.watch<ProfileState>();
    // 프로필을 확인하려는 유저의 정보
    UserModel userModel = profileState.userModel;
    //UserModel userModel = context.read<ProfileState>().userModel;
    logger.d(context.watch<ProfileState>().userModel);
    return Container(
      //하단부분 둥근 형태로 제작
      color: Colors.white,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 8,
                    height: 100,
                  ),
                  Text(
                    userModel.name,
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  SizedBox(width: 17),
                  Text(
                    userModel.userid,
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    userModel.email,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 128),
          Column(
            children: [
              CircleAvatar(
                backgroundImage: userModel.profileImage == null ||
                    userModel.profileImage!.isEmpty
                    ? ExtendedAssetImageProvider('assets/images/profile.png')
                as ImageProvider
                    : ExtendedNetworkImageProvider(userModel.profileImage!),
                radius: 45,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.black,
                  iconSize: 30,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen2()),
                    );
                  },
                ),
                SizedBox(width: 6),
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  color: Colors.black,
                  iconSize: 30,
                  onPressed: () async {
                    await context.read<myAuthProvider.AuthProvider>().signOut();
                  },
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Expanded(
      flex: 4,
      child: Container(
        color: Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
            ? Color(0xff505050)
            : Colors.grey[500],
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    '알림',
                    style: TextStyle(
                        fontFamily: 'YeongdeokSea',
                        fontSize: 26,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thickness: 5,
                child: ListView(
                  children: [
                    _buildNotificationCard('제목', '시간 작성'),
                    _buildNotificationCard('제목2', '시간 작성2'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(String title, String time) {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        tileColor: Colors.white,
        title: Text(title, style: TextStyle(fontSize: 20, color: Colors.black)),
        subtitle:
        Text(time, style: TextStyle(fontSize: 15, color: Colors.black)),
      ),
    );
  }
}