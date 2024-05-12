import 'package:team_project/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'createNoticeScreen.dart';
import 'revise_notice_screen.dart';
import 'package:provider/provider.dart';

class ModifyNoticeScreen extends StatelessWidget {
  final List<Notice> notices = [
    Notice(
      title: '이번 주 모임 안내',
      content: '이번 주 토요일에 모임이 있습니다. 시간은 오후 2시입니다. 참석 부탁드립니다.',
      date: DateTime(2024, 2, 16),
      //imageUrl: 'assets/meeting.jpeg', // 예시로 이미지 URL을 제공
    ),
    Notice(
      title: '이번 주 모임 안내2',
      content: '이번 주 일요일에 모임이 있습니다. 시간은 오후 2시입니다. 참석 부탁드립니다.',
      date: DateTime(2024, 2, 17),
      //imageUrl: 'assets/post1.jpg', // 예시로 이미지 URL을 제공
    ),
  ];

  @override
  Widget build(BuildContext context) {
    //final _themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '공지사항',
          style: TextStyle(
              fontFamily: 'Dongle', fontWeight: FontWeight.w200, fontSize: 35),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '공지사항 갯수: ${notices.length}',
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Divider(),
          Center(
            child: Text(
              '공지사항을 추가하려면 아래 + 아이콘을 눌러주세요!',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                return NoticeItem(notice: notices[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNoticeScreen()),
          );
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
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
            fontSize: 35,
            fontWeight: FontWeight.w200,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
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
            children: [
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
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  //widget.notice.imageUrl,
                  width: double.infinity,
                  height: 230.0,
                  color: Colors.greenAccent,
                ),
              ),
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

  //final String imageUrl; // Added imageUrl property

  Notice({
    required this.title,
    required this.content,
    required this.date,
    //required this.imageUrl,
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
        padding: const EdgeInsets.all(8.0),
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
                    color: Colors.greenAccent,
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
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // 수정 버튼 클릭 시 처리할 동작 추가
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReviseNoticeScreen(notice: notice)),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // 삭제 버튼 클릭 시 처리할 동작 추가
                                  _showDeleteConfirmationDialog(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 3.0),
                      Text(
                        notice.content,
                        style: TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '게시일: ${DateFormat('yyyy.MM.dd').format(notice.date)}',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
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

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _themeManager = Provider.of<ThemeManager>(context);
        return AlertDialog(
          backgroundColor: _themeManager.themeMode == ThemeMode.dark
              ? Color(0xFF212121)
              : Colors.white,
          title: Text(
            '공지 삭제',
            style: TextStyle(
                color: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black),
          ),
          content: Text(
            '공지를 삭제하시겠습니까?',
            style: TextStyle(
              color: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ), // 메시지 출력
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70,
              ),
              child: Text('취소', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeManager.themeMode == ThemeMode.dark
                    ? Color(0xff1c213a)
                    : Color(0xff1e2b67),
              ),
              child: Text('삭제', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
