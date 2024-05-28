import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/screen/clubPage/DescriptionScreen.dart';
import 'package:team_project/screen/clubPage/PostScreen.dart';
import 'package:team_project/screen/clubPage/ScheduleScreen.dart';
import 'package:team_project/screen/clubPage/NoticeScreen.dart';
import 'package:team_project/screen/clubPage/CommentScreen.dart';

class ClubMainScreen extends StatefulWidget {
  final ClubModel clubModel;

  const ClubMainScreen({
    super.key,
    required this.clubModel,
  });

  @override
  State<ClubMainScreen> createState() => _ClubMainScreenState();
}

class _ClubMainScreenState extends State<ClubMainScreen> {
  int _selectedPage = 0;

  List<Map<String, dynamic>> _bottomItems = [
    {"icon": Icons.description, "text": "설명"},
    {"icon": Icons.message, "text": "게시글"},
    {"icon": Icons.calendar_today, "text": "일정"},
    {"icon": Icons.notification_important, "text": "공지사항"},
    {"icon": Icons.comment, "text": "댓글"},
  ];

  void _onItemTapped(int index) {
    //아래 네비게이션바를 눌러서 이동할때 필요한 함수
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    ClubState clubState = context.watch<ClubState>();
    List<ClubModel> clubList = clubState.clubList;
    ClubModel clubModel = widget.clubModel;
    final List<String> _appbarNameList = [
      //이거 나중에 동아리명 받아서 작업해야해서 ${}이 방식으로 수정.
      clubModel.clubName,
      clubModel.clubName +' 게시글',
      clubModel.clubName+' 일정',
      clubModel.clubName+' 공지사항',
      clubModel.clubName+' 댓글',
    ];
    List<Widget> _screens = [
      DescriptionScreen(clubModel: clubModel), //동아리 메인 화면
      PostScreen(clubId: widget.clubModel.clubId), // 게시글 화면
      ScheduleScreen(clubId: widget.clubModel.clubId), //달력 화면
      NoticeScreen(clubId: widget.clubModel.clubId), //공지 화면
      CommentScreen(clubId: clubModel.clubId), //댓글 화면
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _appbarNameList[_selectedPage],
          style: TextStyle(
            fontFamily: 'Dongle',
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.w200,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _screens[_selectedPage],
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: Container(
          height: 66,
          padding: EdgeInsets.symmetric(horizontal: 1),
          margin: EdgeInsets.fromLTRB(24, 0, 24, 10),
          decoration: BoxDecoration(
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
              SizedBox(width: 1),
              ..._bottomItems.asMap().entries.map((entry) {
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
                      SizedBox(height: 2),
                      Text(
                        item["text"],
                        style: TextStyle(
                          color: _selectedPage == index
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
              SizedBox(width: 1),
            ],
          ),
        ),
      ),
    );
  }
}