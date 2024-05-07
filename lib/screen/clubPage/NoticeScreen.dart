import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/screen/modify/createNoticeScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class NoticeScreen extends StatefulWidget {
  final ClubModel clubModel;

  NoticeScreen({super.key, required this.clubModel});
  @override
  State<NoticeScreen> createState() => _NoticeScreen();
}
class _NoticeScreen extends State<NoticeScreen> {
  final List<Notice> notices = [
    Notice(
      imageUrl: 'assets/notice_image1.jpg',
      title: '학사 일정 안내',
      content: '2024년도 1학기 학사 일정이 공지되었습니다. 확인해주세요.',
      date: DateTime.now(),
    ),
    Notice(
      imageUrl: 'assets/notice_image2.jpg',
      title: '게임 대회 신청 안내',
      content: '게임 대회 신청 기한이 다가왔습니다. 기한을 확인하고 신청해주세요.',
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    ClubModel clubModel = widget.clubModel;
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 60.0,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.white24
                      : Colors.white,
                  hintText: '공지사항 검색',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 17,
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.black
                        : Colors.black87,
                  ),
                  suffixIcon: Icon(Icons.search,
                      color: _themeManager.themeMode == ThemeMode.dark
                          ? Colors.black
                          : Colors.black87),
                  // 검색 아이콘을 오른쪽에 배+치합니다.
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _themeManager.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Color(0xFF2195F2),
                        width: 1),
                  ),
                ),
                onChanged: (value) {
                  // 검색 기능 추가.
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '공지사항 갯수: ${notices.length}',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: NoticeItem(notice: notices[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // 현재 사용자가 있고, 그 사용자의 UID가 'clubModel.writer'와 같은 경우에만 FloatingActionButton 활성화
      floatingActionButton: currentUser != null && currentUser.uid == clubModel.writer.uid ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateNoticeScreen()));
        },
        child: Icon(Icons.add),
      ): null,
    );
  }
}

class NoticeDetailScreen extends StatefulWidget {
  final Notice notice;

  NoticeDetailScreen({required this.notice});

  @override
  _NoticeDetailScreenState createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '공지사항 상세 정보',
          style: TextStyle(
            fontFamily: 'Dongle',
            fontWeight: FontWeight.w200,
            fontSize: 35,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // 뒤로가기 버튼 색상을 하얀색으로 지정
          ),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 기능
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), // 둥근 사각형 모양 적용
            color: _themeManager.themeMode == ThemeMode.dark
                ? Colors.grey[800]
                : Colors.white, // 배경색을 테마에 따라 지정
            boxShadow: _themeManager.themeMode == ThemeMode.dark
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3), // 그림자 위치 조정
                    ),
                  ], // 다크 모드에서는 그림자 효과 제거
          ),
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ //widget.notice.date
              SizedBox(height: 8.0),
              Text(
                '게시일: ${DateFormat('yyyy.MM.dd').format(widget.notice.date)}',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black), // 텍스트 색상을 테마에 따라 지정
              ),
              SizedBox(height: 16.0),
              //ClipRRect(
              //borderRadius: BorderRadius.circular(15.0),
              //child: Image.asset(
              //widget.notice.imageUrl,
              //width: double.infinity,
              //height: 230.0,
              //fit: BoxFit.cover,
              //),
              //),
              SizedBox(height: 16.0),
              Text(
                widget.notice.title,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black), // 텍스트 색상을 테마에 따라 지정
              ),
              SizedBox(height: 8.0),
              Text(
                widget.notice.content,
                style: TextStyle(
                    fontSize: 14.0,
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black), // 텍스트 색상을 테마에 따라 지정
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Notice {
  final String title;
  final String content;
  final DateTime date;
  final String imageUrl; // Added imageUrl property

  Notice({
    required this.title,
    required this.content,
    required this.date,
    required this.imageUrl,
  });
}

class NoticeItem extends StatelessWidget {
  final Notice notice;

  NoticeItem({required this.notice});

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeDetailScreen(notice: notice),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: _themeManager.themeMode == ThemeMode.dark
                ? Colors.grey[800]
                : Colors.white,
            boxShadow: _themeManager.themeMode == ThemeMode.dark
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    //notice.imageUrl,
                    width: 100.0,
                    height: 100.0,
                    color: Colors.lime, //fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notice.title,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        notice.content,
                        style: TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        '게시일: ${DateFormat('yyyy.MM.dd').format(notice.date)}',
                        style: TextStyle(fontSize: 12.0, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
