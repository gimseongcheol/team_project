import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/providers/feed/feed_provider.dart';
import 'package:team_project/providers/feed/feed_state.dart';
import 'package:team_project/screen/clubPage/ClubMainScreen.dart';
import 'package:team_project/screen/clubPage/PostScreen.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';

class CreatePostScreen extends StatefulWidget {
  final VoidCallback onFeedUploaded;

  const CreatePostScreen({
    super.key,
    required this.onFeedUploaded,
  });

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final List<String> _files = [];
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    _contentEditingController.dispose();
    super.dispose();
  }

  Future<List<String>> selectImages() async {
    List<XFile> images = await ImagePicker().pickMultiImage(
      maxHeight: 100,
      maxWidth: 100,
    );
    return images.map((e) => e.path).toList();
  }

  List<Widget> selectedImageList() {
    final feedStatus = context.watch<FeedState>().feedStatus;
    return _files.map((data) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          // Position the delete icon on top of the image
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Image.file(
                File(data),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.4,
                width: 100,
              ),
            ),
            Positioned(
              top: 1,
              right: 1,
              child: InkWell(
                onTap: feedStatus == FeedStatus.submitting
                    ? null
                    : () {
                        setState(() {
                          _files.remove(data);
                        });
                      },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  height: 20,
                  width: 20,
                  child: Icon(
                    color: Colors.black.withOpacity(0.6),
                    size: 20,
                    Icons.highlight_remove_outlined,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    final feedStatus = context.watch<FeedState>().feedStatus;

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
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: feedStatus == FeedStatus.submitting
                              ? null
                              : () async {
                            final _images = await selectImages();
                            setState(() {
                              _files.addAll(_images);
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: _themeManager.themeMode == ThemeMode.dark
                                  ? Colors.white24
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 40.0,
                              color: _themeManager.themeMode == ThemeMode.dark
                                  ? Colors.white70
                                  : Colors.black,
                            ),
                          ),
                        ),
                        ...selectedImageList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0, top: 8.0),
              child: Text(
                '사진 개수 : ${_files.length}개',
                style: TextStyle(
                  fontSize: 12.0,
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.white70
                      : Colors.black,
                ),
              ),
            ),
            Center(
              child: Text(
                '게시글 항목을 입력해주세요',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            TextFormField(
              controller: _textEditingController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.white24
                    : Colors.grey[100],
                border: OutlineInputBorder(),
                hintText: '제목을 입력합니다.',
                labelStyle: TextStyle(
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.black
                      : Colors.black87,
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
              controller: _contentEditingController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.white24
                    : Colors.grey[100],
                border: OutlineInputBorder(),
                hintText: '내용을 입력합니다.',
                labelStyle: TextStyle(
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.black
                      : Colors.black87,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.black
                        : Color(0xFF2195F2),
                  ),
                ),
              ),
              maxLines: 10,
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    final feedStatus = context.read<FeedState>().feedStatus;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _themeManager = Provider.of<ThemeManager>(context);
        return AlertDialog(
          backgroundColor: _themeManager.themeMode == ThemeMode.dark
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
                backgroundColor: Colors.white70,
              ),
              child: Text("취소", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: (_files.length == 0 ||
                      feedStatus == FeedStatus.submitting ||
                      _textEditingController.text.isEmpty ||
                      _contentEditingController.text.isEmpty)
                  ? null
                  : () async {
                  Navigator.of(context).pop();
                      try {
                        FocusScope.of(context).unfocus();
                        // uploadFeed 메서드의 실행이 완료될 때까지 기다림
                        await context.read<FeedProvider>().uploadFeed(
                              files: _files,
                              desc: _textEditingController.text,
                              title: _contentEditingController.text,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('게시물을 등록했습니다.')),
                        );
                        widget.onFeedUploaded();
                      } on CustomException catch (e) {
                        errorDialogWidget(context, e);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeManager.themeMode == ThemeMode.dark
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
