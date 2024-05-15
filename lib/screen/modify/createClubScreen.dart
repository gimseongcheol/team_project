import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/providers/club/club_provider.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/screen/mainPage/clubSearch.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/screen/clubPage/event.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';

class CreateClubScreen extends StatefulWidget {
  final VoidCallback onClubUploaded;

  const CreateClubScreen({
    super.key,
    required this.onClubUploaded,
  });

  @override
  State<CreateClubScreen> createState() => _CreateClubScreenState();
}

class _CreateClubScreenState extends State<CreateClubScreen> {
  final List<String> imagePaths = [];
  String? _selectedClubType;
  String? _selectDepartment;
  final TextEditingController selectedClubType = TextEditingController();
  final TextEditingController selectedDepartment = TextEditingController();
  final TextEditingController clubNameController = TextEditingController();
  final TextEditingController presidentNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController professorNameController = TextEditingController();
  final TextEditingController shortIntroController = TextEditingController();
  final TextEditingController fullIntroController = TextEditingController();
  final List<String> _files = [];

  @override
  void dispose() {
    clubNameController.dispose();
    presidentNameController.dispose();
    phoneNumberController.dispose();
    professorNameController.dispose();
    shortIntroController.dispose();
    fullIntroController.dispose();
    selectedClubType.dispose();
    selectedDepartment.dispose();
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

  @override
  Widget build(BuildContext context) {
    final clubStatus = context.watch<ClubState>().clubStatus;
    final _themeManager = Provider.of<ThemeManager>(context);
    final List<String> _departmentList = <String>[
      '프란치스코칼리지',
      '글로벌비즈니스대학',
      '신학대학',
      '바이오메디대학',
      '공과대학',
      '반도체대학',
      '소프트웨어융합대학',
      '의과대학',
      '간호대학',
      '약학대학',
      '사회과학대학',
      '사범대학',
      '음악공연예술대학',
      '디자인대학',
      '유스티아노자유대학',
    ];

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
                        fontSize: 30.0,
                      ),
                    ),
                  ],
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
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '동아리 종류를 선택하세요',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_selectedClubType == '과동아리')
                    DropdownButton(
                        //선택시 내부 색상 변경이 가능한지 확인하기
                        hint: const Text('학부 선택'),
                        value: _selectDepartment,
                        items: _departmentList.map((String item) {
                          return DropdownMenuItem<String>(
                            child: Text('$item'),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectDepartment = value;
                            selectedDepartment.text = value ?? '';
                          });
                        }),
                ],
              ),
            ),
            RadioListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              tileColor: _themeManager.themeMode == ThemeMode.dark
                  ? Color(0xff505050)
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
                  selectedClubType.text = value ?? '중앙동아리';
                  selectedDepartment.text = value ?? '';
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
                  ? Color(0xff505050)
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
                  selectedClubType.text = value ?? '과동아리';
                });
              },
              activeColor: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Color(0xFF2195F2), // 선택된 색상
            ),
            SizedBox(height: 4),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: clubNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.black12
                    : Colors.white,
                border: OutlineInputBorder(),
                labelText: '동아리 명',
                prefixIcon: Icon(
                  Icons.home,
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
              keyboardType: TextInputType.name,
              controller: presidentNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.black12
                    : Colors.white,
                border: OutlineInputBorder(),
                labelText: '회장 이름',
                prefixIcon: Icon(Icons.account_circle),
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
              keyboardType: TextInputType.number,
              controller: phoneNumberController,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.black12
                    : Colors.white,
                border: OutlineInputBorder(),
                labelText: '연락처',
                prefixIcon: Icon(Icons.phone),
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
              keyboardType: TextInputType.name,
              controller: professorNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.black12
                    : Colors.white,
                border: OutlineInputBorder(),
                labelText: '담당 교수',
                prefixIcon: Icon(Icons.account_circle),
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
              controller: shortIntroController,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.black12
                    : Colors.white,
                border: OutlineInputBorder(),
                labelText: '한줄 소개',
                prefixIcon: Icon(Icons.textsms_outlined),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2195F2)), // 선택된 색상
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: fullIntroController,
              decoration: InputDecoration(
                filled: true,
                fillColor: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.black12
                    : Colors.white,
                border: OutlineInputBorder(),
                labelText: '동아리 소개',
                prefixIcon: Icon(Icons.text_snippet_outlined),
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
    final clubStatus = context.read<ClubState>().clubStatus;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _themeManager = Provider.of<ThemeManager>(context);
        return AlertDialog(
          backgroundColor: _themeManager.themeMode == ThemeMode.dark
              ? Color(0xFF212121)
              : Colors.white,
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
                backgroundColor: Colors.white70,
              ),
              child: Text("취소", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: (_files.length == 0 ||
                      clubStatus == ClubStatus.submitting ||
                      _selectedClubType == null)
                  ? null
                  : () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClubSearch()
                        ));
                      try {
                        FocusScope.of(context).unfocus();

                        await context.read<ClubProvider>().uploadClub(
                              files: _files,
                              clubName: clubNameController.text,
                              professorName: professorNameController.text,
                              call: phoneNumberController.text,
                              shortComment: shortIntroController.text,
                              fullComment: fullIntroController.text,
                              presidentName: presidentNameController.text,
                              depart: selectedDepartment.text,
                              clubType: selectedClubType.text,

                              //uid: uid,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('동아리 등록했습니다.')),
                        );
                        widget.onClubUploaded();
                      } on CustomException catch (e) {
                        errorDialogWidget(context, e);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeManager.themeMode == ThemeMode.dark
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
