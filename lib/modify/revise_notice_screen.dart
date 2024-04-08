import 'package:flutter/material.dart';
import 'ModifyNoticeScreen.dart';
import 'package:provider/provider.dart';
import 'package:team_project/theme/theme_manager.dart';

class ReviseNoticeScreen extends StatefulWidget {
  final Notice notice;

  ReviseNoticeScreen({required this.notice});

  @override
  _RevisePostScreenState createState() => _RevisePostScreenState();
}

//-> 이것도 굳이 화면을 따로 만들지 말고 체크해서 작업할수 있게 하는 방법으로 하면 좋을듯 check를 해서 data가 있으면 가져오거나 혹은 없으면 백지상태로 작업할수 있게.
class _RevisePostScreenState extends State<ReviseNoticeScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  bool _hasImage = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.notice.title;
    _contentController.text = widget.notice.content;
    //_hasImage = widget.notice.imageUrl != null;
  }

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '공지사항 수정 화면',
          style: TextStyle(
            fontFamily: 'Dongle',
            fontWeight: FontWeight.w200,
            fontSize: 35,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // 아이콘 색상을 하얀색으로 지정
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _showConfirmationDialog(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.save,
                  color: Colors.white, // 아이콘 색상 변경
                ),
                SizedBox(width: 4), // 아이콘과 텍스트 사이 간격 추가
                Text(
                  '저장',
                  style: TextStyle(
                    fontFamily: 'Dongle',
                    fontWeight: FontWeight.w200,
                    color: Colors.white, // 텍스트 색상 변경
                    fontSize: 30.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Divider(),
            Center(
              child: Text(
                '사진을 추가하려면 + 아이콘을 눌러주세요!',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            SizedBox(height: 16.0),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (!_hasImage) {
                    _addImage();
                  } else {
                    _showDeleteConfirmationDialog(context);
                  }
                },
                child: Stack(
                  children: [
                    SizedBox(height: 16.0),
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: _themeManager.themeMode == ThemeMode.dark
                            ? Colors.white24
                            : Colors.black54,
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: _hasImage
                          ? Container(
                              //widget.notice.imageUrl,
                              width: 100.0,
                              height: 100.0,
                              //fit: BoxFit.cover,
                              color: _themeManager.themeMode == ThemeMode.dark
                                  ? Colors.white24
                                  : Colors.white54,
                            )
                          : Container(),
                    ),
                    _hasImage
                        ? Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: _themeManager.themeMode == ThemeMode.dark
                                    ? Colors.white70
                                    : Colors.black,
                              ),
                              onPressed: () {
                                _showDeleteConfirmationDialog(context);
                              },
                            ),
                          )
                        : Positioned(
                            right: 0,
                            bottom: 0,
                            child: Icon(Icons.add),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Divider(),
            Center(
              child: Text(
                '공지사항 세부 사항을 입력해주세요!',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.white24
                    : Colors.grey[100],
                border: OutlineInputBorder(),
                labelText: '제목을 입력합니다.',
                labelStyle: TextStyle(
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.black
                      : Colors.black87,
                ),
                prefixIcon: Icon(
                  Icons.text_fields,
                  color: Colors.black
                ),
                focusedBorder: OutlineInputBorder(
                  //focus라 이벤트 처리시 발생하는 색상
                  borderSide: BorderSide(
                      color: _themeManager.themeMode == ThemeMode.dark
                          ? Colors.black
                          : Color(0xFF2195F2)), // 선택된 색상
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.white24
                    : Colors.grey[100],
                border: OutlineInputBorder(),
                labelText: '내용을 입력합니다.',
                labelStyle: TextStyle(
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.black
                      : Colors.black87,
                ),
                prefixIcon: Icon(
                  Icons.text_snippet_outlined,
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.black
                      : Colors.black87,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.black
                        : Color(0xFF2195F2),
                  ), // 선택된 색상
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _themeManager = Provider.of<ThemeManager>(context);
        return AlertDialog(
          backgroundColor:  _themeManager.themeMode == ThemeMode.dark
              ? Color(0xFF212121)
              : Colors.white,
          title: Text(
            "공지사항 수정",
            style: TextStyle(
                color: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black),
          ),
          content: Text(
            "공지사항을 수정하시겠습니까?",
            style: TextStyle(
              color: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
              fontSize: 14,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white70,
              ),
              child: Text("취소", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: _themeManager.themeMode == ThemeMode.dark
                    ? Color(0xff1c213a)
                    : Color(0xff1e2b67),
              ),
              child: Text("수정", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _addImage() {
    // 이미지 추가 기능 구현 => 파베에 추가를 진행해야함. 저장시 처리하던지 아니면 realtime으로 진행을 하면됨 좋을 대로 작업할것
    print('이미지 추가');
    setState(() {
      _hasImage = true;
    });
  }

  void _removeImage() {
    // 이미지 삭제 기능 구현 => 파베에서 삭제 같이 진행해야함. 위에 작성한 텍스트 처럼 같이 진해하면 됨.
    print('이미지 삭제');
    setState(() {
      _hasImage = false;
    });
  }

  void _saveChanges(BuildContext context) {
    // 수정된 내용 저장 및 화면 이동 등의 동작 구현 여기서 아예 파베에 집어넣는 작업을 진행해도 됨
    print('수정된 내용을 저장합니다.');
    Navigator.of(context).pop(); // 화면 닫기
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
            "사진 삭제",
            style: TextStyle(
                color: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black),
          ),
          content: Text(
            "사진을 삭제하시겠습니까?",
            style: TextStyle(
                color: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white70,
              ),
              child: Text("취소", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: _themeManager.themeMode == ThemeMode.dark
                    ? Color(0xff1c213a)
                    : Color(0xff1e2b67),
              ),
              child: Text("삭제", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
