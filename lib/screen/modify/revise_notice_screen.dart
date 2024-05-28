import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/notice_model.dart';
import 'package:team_project/providers/notice/notice_provider.dart';
import 'package:team_project/providers/notice/notice_state.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'ModifyNoticeScreen.dart';
import 'package:provider/provider.dart';
import 'package:team_project/theme/theme_manager.dart';

class ReviseNoticeScreen extends StatefulWidget {
  final VoidCallback onEditNoticeUploaded;
  final NoticeModel noticeModel;
  final String clubId;

  const ReviseNoticeScreen({
    super.key,
    required this.onEditNoticeUploaded,
    required this.noticeModel,
    required this.clubId,
  });

  @override
  State<ReviseNoticeScreen> createState() => _ReviseNoticeScreenState();
}

//-> 이것도 굳이 화면을 따로 만들지 말고 체크해서 작업할수 있게 하는 방법으로 하면 좋을듯 check를 해서 data가 있으면 가져오거나 혹은 없으면 백지상태로 작업할수 있게.
class _ReviseNoticeScreenState extends State<ReviseNoticeScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  final List<String> _files = [];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
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
    final noticeStatus = context.watch<NoticeState>().noticeStatus;
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
                onTap: noticeStatus == NoticeStatus.submitting
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
    final noticeStatus = context.watch<NoticeState>().noticeStatus;

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
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: noticeStatus == NoticeStatus.submitting
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
              controller: _titleController,
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
              controller: _contentController,
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
    final noticeStatus = context.read<NoticeState>().noticeStatus;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _themeManager = Provider.of<ThemeManager>(context);
        return AlertDialog(
          backgroundColor: _themeManager.themeMode == ThemeMode.dark
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
              onPressed: (_files.length == 0 ||
                      noticeStatus == NoticeStatus.submitting ||
                      _titleController.text.isEmpty ||
                      _contentController.text.isEmpty)
                  ? null
                  : () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ModifyNoticeScreen(clubId: widget.clubId),
                          ));
                      try {
                        FocusScope.of(context).unfocus();
                        // uploadNotice 메서드의 실행이 완료될 때까지 기다림
                        await context.read<NoticeProvider>().updateNotice(
                              files: _files,
                              desc: _contentController.text,
                              title: _titleController.text,
                              clubId: widget.clubId,
                              noticeId: widget.noticeModel.noticeId,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('게시물을 등록했습니다.')),
                        );
                        widget.onEditNoticeUploaded();
                      } on CustomException catch (e) {
                        errorDialogWidget(context, e);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeManager.themeMode == ThemeMode.dark
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
                backgroundColor: Colors.white70,
              ),
              child: Text("취소", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeManager.themeMode == ThemeMode.dark
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
