import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:team_project/providers/club/club_provider.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/screen/clubPage/event.dart';

class CreateClubScreen extends StatefulWidget {
  @override
  _CreateClubScreenState createState() => _CreateClubScreenState();

}

class _CreateClubScreenState extends State<CreateClubScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  List<String> imagePaths = [];
  String? _selectedClubType;
  TextEditingController _eventController = TextEditingController();
  TextEditingController clubNameController = TextEditingController();
  TextEditingController presidentNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController professorNameController = TextEditingController();
  TextEditingController shortIntroController = TextEditingController();
  TextEditingController fullIntroController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final List<String> _files = [];
  Uint8List? _image;

  @override
  void dispose() {
    clubNameController.dispose();
    presidentNameController.dispose();
    phoneNumberController.dispose();
    professorNameController.dispose();
    shortIntroController.dispose();
    fullIntroController.dispose();
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
    final clubStatus = context.watch<ClubState>().clubStatus;

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
                onTap: clubStatus == ClubStatus.submitting
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


  Map<DateTime, List<Event>> _selectedEvents = {}; // _selectedEvents 변수 추가

  List<Event> _getEventsForDay(DateTime day) {
    return _selectedEvents[day] ?? [];
  } // _getEventsForDay 메서드 추가

  late DateTime _selectedDay; // _selectedDay 변수 추가

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _selectedDay = DateTime.now(); // Initialize _selectedDay in initState
  }

  void _createClub() {
    // 동아리 생성 함수 구현
    print('동아리를 생성합니다.');
  }

  @override
  Widget build(BuildContext context) {
    final clubStatus = context.watch<ClubState>().clubStatus;
    final _themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '동아리 생성 화면',
          style: TextStyle(
            fontFamily: 'Dongle',
            fontSize: 35,
            color: Colors.white, // 텍스트 색상을 하얀색으로 지정
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
          Row(
            children: [
              TextButton(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.save,
                        color: Colors.white, // 아이콘 색상을 하얀색으로 지정
                      ),
                      SizedBox(width: 4), // 아이콘과 텍스트 사이 간격 추가
                      Text(
                        '저장',
                        style: TextStyle(
                          fontFamily: 'Dongle',
                          color: Colors.white, // 텍스트 색상을 하얀색으로 지정
                          fontSize: 25.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
            // "+" 버튼과 이미지들을 표시할 영역
            Form(
              key: _globalKey,
              autovalidateMode: _autovalidateMode,
              child: Row(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal, //이게 작동을 안함 listview 같은 느낌인데
                    child: Row(
                      children: [
                        InkWell(
                          onTap: clubStatus == ClubStatus.submitting
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
                            child: Icon(Icons.add, size: 40.0,
                              color: _themeManager.themeMode == ThemeMode.dark
                                  ? Colors.white70
                                  : Colors.black,),
                          ),
                        ),
                        ...selectedImageList(),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            // 사진의 개수를 나타내는 작은 텍스트 추가
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
                '동아리 세부 사항을 입력해주세요!',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                '동아리 종류를 선택하세요',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RadioListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              tileColor: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.black26
                  : Colors.white,
              title: Text(
                '중앙동아리',
                style: TextStyle(
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              value: '중앙동아리',
              groupValue: _selectedClubType,
              onChanged: (value) {
                setState(() {
                  _selectedClubType = value as String?;
                });
              },
              activeColor: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Color(0xFF2195F2), // 선택된 색상
            ),
            SizedBox(height: 4),
            RadioListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              tileColor: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.black26
                  : Colors.white,
              title: Text(
                '과동아리',
                style: TextStyle(
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              value: '과동아리',
              groupValue: _selectedClubType,
              onChanged: (value) {
                setState(() {
                  _selectedClubType = value as String?;
                });
              },
              activeColor: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Color(0xFF2195F2), // 선택된 색상
            ),
            SizedBox(height: 4),
            TextFormField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.black12
                    : Colors.white,
                border: OutlineInputBorder(),
                labelText: '동아리 이름을 입력합니다.',
                prefixIcon: Icon(
                  Icons.home,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2195F2)), // 선택된 색상
                ),
              ),
            ),

            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.black12
                    : Colors.white,
                border: OutlineInputBorder(),
                labelText: '회장 이름을 입력합니다.',
                prefixIcon: Icon(Icons.account_circle),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2195F2)), // 선택된 색상
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.black12
                    : Colors.white,
                border: OutlineInputBorder(),
                labelText: '전화번호를 입력합니다.',
                prefixIcon: Icon(Icons.phone),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2195F2)), // 선택된 색상
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.black12
                    : Colors.white,
                border: OutlineInputBorder(),
                labelText: '담당교수 이름을 입력합니다.',
                prefixIcon: Icon(Icons.account_circle),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2195F2)), // 선택된 색상
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.black12
                    : Colors.white,
                border: OutlineInputBorder(),
                labelText: '한줄 소개를 입력합니다.',
                prefixIcon: Icon(Icons.textsms_outlined),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2195F2)), // 선택된 색상
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.black12
                    : Colors.white,
                border: OutlineInputBorder(),
                labelText: '동아리 소개를 입력합니다.',
                prefixIcon: Icon(Icons.text_snippet_outlined),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2195F2)), // 선택된 색상
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
// 이미지를 추가하는 메서드입니다.
  void _addImage() {
    setState(() {
      imagePaths.add('assets/example_image.jpg');
    });
  }
  // 이미지를 추가하는 메서드입니다.
  Future<void> selectImage() async {
    ImagePicker imagePicker = new ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
    );
    if (file != null) {
      Uint8List uint8list = await file.readAsBytes();
      setState(() {
        _image = uint8list;
      });
    }
  }


  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _themeManager = Provider.of<ThemeManager>(context);
        return AlertDialog(
          backgroundColor: _themeManager.themeMode == ThemeMode.dark
              ? Color(0xFF505050)
              : Color(0xFF212121),
          title: Text(
            "동아리 생성",
            style: TextStyle(
                color: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    "동아리를 생성하시겠습니까?",
                    style: TextStyle(
                      color: _themeManager.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  // Add your TextField or any other content here
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _selectedEvents[_selectedDay] = _getEventsForDay(_selectedDay);
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
              child: Text("생성", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
