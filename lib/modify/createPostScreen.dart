import 'package:flutter/material.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  void _addImage() {
    // 이미지 추가 기능 구현
    print('이미지 추가');
  }

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '게시글 생성 화면',
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
                '사진을 추가하려면 아래 아이콘을 눌러주세요!',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            SizedBox(height: 16.0),
            Center(
              child: GestureDetector(
                onTap: () {
                  _addImage();
                },
                child: Stack(
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: _themeManager.themeMode == ThemeMode.dark
                            ? Colors.white24
                            : Colors.black54,
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 40.0,
                        color: _themeManager.themeMode == ThemeMode.dark
                            ? Colors.white24
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [],
            ),
            Divider(),
            Center(
              child: Text(
                '게시글 항목을 입력해주세요!',
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
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.black
                        : Color(0xFF2195F2),
                  ),
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
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.black
                        : Color(0xFF2195F2),
                  ),
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
            "게시글 저장",
            style: TextStyle(
                color: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black),
          ),
          content: Text(
            "게시글을 저장하시겠습니까?",
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
              child: Text("저장", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
