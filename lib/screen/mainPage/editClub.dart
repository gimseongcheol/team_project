import 'package:flutter/material.dart';
import 'package:team_project/screen/modify/ModifyPostScreen.dart';
import 'package:team_project/screen/modify/ModifyNoticeScreen.dart';
import 'package:team_project/screen/modify/ModifyClubScreen.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class EditClub extends StatefulWidget {
  @override
  _EditClubState createState() => _EditClubState();
}

class _EditClubState extends State<EditClub> {
  final ScrollController _scrollController = ScrollController();
  List<ClubInfo> clubList = [
    ClubInfo(
      name: '동아리1',
      description: '동아리 한줄 소개글',
    ),
    ClubInfo(
      name: '동아리2',
      description: '동아리 한줄 소개글',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 8),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '검색하세요.',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  suffixIcon: Icon(Icons.search, color: Colors.black),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thickness: 5,
              child: ListView.builder(
                itemCount: clubList.length,
                itemBuilder: (context, index) {
                  return ClubListItem(clubInfo: clubList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClubInfo {
  final String name;
  final String description;

  ClubInfo({required this.name, required this.description});
}

class ClubListItem extends StatelessWidget {
  final ClubInfo clubInfo;

  ClubListItem({required this.clubInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(width: 1),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            tileColor: Colors.white,
            leading: Container(
              //여기도 이미지 들어감 사이즈는 이대로 두기
              width: 40,
              height: 80,
              color: Colors.lime,
            ),
            title: Text(
              clubInfo.name,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              clubInfo.description,
              style: TextStyle(color: Colors.black),
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.black),
              color: Colors.white,
              onSelected: (value) {
                switch (value) {
                  case 'editInfo':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModifyClubScreen()));
                    break;
                  case 'managePosts':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModifyPostScreen()));
                    break;
                  case 'manageNotices':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModifyNoticeScreen()));
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'editInfo',
                  child: Text(
                    '정보 수정하기',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'managePosts',
                  child: Text(
                    '게시글 관리하기',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'manageNotices',
                  child: Text(
                    '공지 관리하기',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
