import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/providers/auth/auth_provider.dart'
as myAuthProvider;
import 'package:team_project/providers/profile/profile_state.dart';
import 'package:team_project/providers/user/user_provider.dart';
import 'package:team_project/screen/auth/signup_screen.dart';
import 'package:team_project/screen/mainPage/editProfile.dart';
import 'package:team_project/screen/mainPage/editClub.dart';
import 'package:team_project/screen/mainPage/eidtSubscribeClub.dart';
import 'package:team_project/screen/mainPage/editComment.dart';
import 'package:team_project/screen/mainPage/mainScreen.dart';
import 'package:team_project/screen/mainPage/clubSearch.dart';
import 'package:team_project/screen/mainPage/aboutExplain.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';

class MainForm extends StatefulWidget {
  @override
  _MainFormState createState() => _MainFormState();
}

class _MainFormState extends State<MainForm> {

  int _selectedPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> _pageOptions = [
    MainScreen(),
    EditProfile(),
    SubClub(),
    EditClub(),
    EditComment(),
  ];
  void initState(){
    super.initState();
    _getProfile();
  }
  final List<String> _appbarNameList = [
    '메인 화면',
    '개인정보 수정',
    '관심 동아리',
    '만든 동아리 수정',
    '댓글 수정',
  ];

  List<Map<String, dynamic>> _bottomItems1 = [
    {"icon": Icons.home, "text": "메인"},
    {"icon": Icons.person, "text": "프로필"},
    {"icon": Icons.class_outlined, "text": "구독"},
    {"icon": Icons.edit, "text": "동아리"},
    {"icon": Icons.comment, "text": "댓글"},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  Future<void> _getProfile()async{
    try{
      await context.read<UserProvider>().getUserInfo();
    }on CustomException catch(e){
      errorDialogWidget(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = context.read<ProfileState>().userModel;
    User? user = FirebaseAuth.instance.currentUser;

    final _themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            size: 25,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(
          _appbarNameList[_selectedPage],
          style: const TextStyle(
            fontFamily: 'Dongle',
            fontSize: 35,
            fontWeight: FontWeight.w200,
          ),
        ),
        actions: [
          Icon(
            _themeManager.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode,
          ),
          Switch(
            value: _themeManager.themeMode == ThemeMode.dark,
            onChanged: (newValue) {
              setState(() {
                _themeManager.toggleTheme(newValue);
              });
            },
            activeColor: Colors.grey[600],
            inactiveTrackColor: Colors.white,
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: _themeManager.themeMode == ThemeMode.dark
            ? Color(0xff454545)
            : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: userModel.profileImage == null
                    ? ExtendedAssetImageProvider('assets/images/profile.png')
                as ImageProvider
                    : ExtendedNetworkImageProvider(userModel.profileImage!),
              ),
              otherAccountsPictures: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  //나중에 backgroundImage이용해서 사진 지정.
                ),
              ],
              accountName: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  userModel.name,
                  style: TextStyle(
                      fontFamily: 'YeongdeokSea',
                      fontSize: 25,
                      color: Colors.white),
                ),
              ),
              accountEmail: Text(
                userModel.email,
                style: TextStyle(
                    fontFamily: 'YeongdeokSea',
                    fontSize: 18,
                    color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: _themeManager.themeMode == ThemeMode.dark
                    ? Color(0xFF1E1E1E)
                    : Color(0xff1e2b67),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
            ),
            _buildDrawerCard(
              user != null && user.isAnonymous
                  ? Icons.login
                  : Icons.account_circle_rounded,
              user != null && user.isAnonymous ? "회원가입하기" : "인증 완료",
              Colors.black12,
                  () {
                // 클릭 이벤트 처리하는 함수 람다 전달
                if (user != null && user.isAnonymous) {
                  // 익명 로그인 유저인 경우에만 회원가입화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                }
              },
            ),
            _buildDrawerCard(
                Icons.question_mark_outlined, 'About', Colors.black12, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutExplain()));
            }),
            _buildDrawerCard(Icons.output, '로그아웃', Colors.black12, () async {
              await context.read<myAuthProvider.AuthProvider>().signOut();
            }),
          ],
        ),
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: Container(
          height: 66,
          padding: EdgeInsets.symmetric(horizontal: 1),
          margin: EdgeInsets.fromLTRB(24, 0, 24, 10),
          decoration: BoxDecoration(
            //네비게이션 바의 박스 색
            color: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF303030)
                : Color(0xFF004285),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 1), // 첫 번째 아이콘 왼쪽 여백
              ..._bottomItems1.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item["icon"],
                        color: _selectedPage == index
                            ? _themeManager.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black
                            : Colors.white,
                      ),
                      SizedBox(height: 2), // 아이콘과 텍스트 사이의 간격 조정
                      Text(
                        item["text"],
                        style: TextStyle(
                          color: _selectedPage ==
                              index //여기서 라이트모드일때 선택안한 아이콘이 하얀색이었으면 하는데...
                              ? _themeManager.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(width: 1), // 마지막 아이콘 오른쪽 여백
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ClubSearch()));
        },
        child: Icon(Icons.search, color: Colors.black),
      ),
    );
  }

  Widget _buildDrawerCard(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
          ? color
          : Colors.white,
      leading: Icon(
        icon,
        color: Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
            ? Colors.white
            : Colors.black,
      ),
      title: Text(title,
          style: TextStyle(
              color:
              Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black)),
      onTap: onTap,
      trailing: Icon(Icons.navigate_next,
          color: Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
              ? Colors.white
              : Colors.black),
    );
  }
}