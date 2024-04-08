import 'package:flutter/material.dart';
import 'ModifyPostScreen.dart';
import 'package:provider/provider.dart';
import 'package:team_project/theme/theme_manager.dart';

class RevisePostScreen extends StatefulWidget {
  final Post post;

  RevisePostScreen({required this.post});

  @override
  _RevisePostScreenState createState() => _RevisePostScreenState();
}

class _RevisePostScreenState extends State<RevisePostScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  bool _hasImage = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.post.title;
    _contentController.text = widget.post.content;
    //_hasImage = widget.post.imageUrl != null;
  }

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '게시글 수정 화면',
          style: TextStyle(
            fontFamily: 'Dongle',
            fontSize: 35,
            fontWeight: FontWeight.w200,
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
                    fontSize: 30.0,
                    color: Colors.white,
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
                              //widget.post.imageUrl,
                              width: 100.0,
                              height: 100.0,
                              //fit: BoxFit.cover,
                              color: _themeManager.themeMode == ThemeMode.dark
                                  ? Colors.white24
                                  : Colors.black54,
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
                                    ? Colors.white24
                                    : Colors.white,
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
                '게시글 세부 사항을 입력해주세요!',
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
          backgroundColor: _themeManager.themeMode == ThemeMode.dark
              ? Color(0xFF212121)
              : Colors.white,
          title: Text(
            "게시글 수정",
            style: TextStyle(
                color: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black),
          ),
          content: Text(
            "게시글을 수정하시겠습니까?",
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
    // 이미지 추가 기능 구현
    print('이미지 추가');
    setState(() {
      _hasImage = true;
    });
  }

  void _removeImage() {
    // 이미지 삭제 기능 구현
    print('이미지 삭제');
    setState(() {
      _hasImage = false;
    });
  }

  void _saveChanges(BuildContext context) {
    // 수정된 내용 저장 및 화면 이동 등의 동작 구현
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
