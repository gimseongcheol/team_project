import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DescriptionScreen extends StatefulWidget {
  @override
  _DescriptionScreenState createState() => _DescriptionScreenState();
}

class Comment {
  final String text;
  final String author;
  final DateTime date; //이 데이터도 firebase에서 가져와야한다.

  Comment({required this.text, required this.author, required this.date});
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  List<String> imagePaths = []; //firebase에서 들고오는 건가!
  String? _selectedClubType;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(),
          Center(
            child: Text(
              '사진을 추가하려면 + 아이콘을 눌러주세요!', //이것도 스타일 변경 필요 Dongle? 통덕? new? 찾아야겠네. 아님 그냥 가던가
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          // "+" 버튼과 이미지들을 표시할 영역
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _addImage();
                },
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Icon(Icons.add, size: 40.0, color: Colors.grey[600]),
                ),
              ),
              // 이미지들을 표시합니다.
              Expanded(
                child: SizedBox(
                  height: 100.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Stack(
                          // 삭제 아이콘 위치를 두려고 -> 그림위의 아이콘
                          children: [
                            Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Image.asset(
                                imagePaths[index],
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.black), // 아이콘 색상 검은색으로 설정
                                onPressed: () {
                                  _removeImage(index);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          // 사진의 개수를 나타내는 작은 텍스트 추가
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              '사진 개수 : ${imagePaths.length}개',
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
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
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          RadioListTile(
            title: Text('중앙동아리'),
            value: '중앙동아리',
            groupValue: _selectedClubType,
            onChanged: (value) {
              setState(() {
                _selectedClubType = value as String?;
              });
            },
            activeColor: Color(0xFF2195F2), // 선택된 색상
          ),
          RadioListTile(
            title: Text('과동아리'),
            value: '과동아리',
            groupValue: _selectedClubType,
            onChanged: (value) {
              setState(() {
                _selectedClubType = value as String?;
              });
            },
            activeColor: Color(0xFF2195F2), // 선택된 색상
          ),
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '동아리 이름을 입력합니다.',
              prefixIcon: Icon(Icons.home),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2195F2)), // 선택된 색상
              ),
            ),
          ),

          SizedBox(height: 16.0),
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
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
    );
  }

  // 이미지를 추가하는 메서드입니다.
  void _addImage() {
    setState(() {
      imagePaths.add('assets/example_image.jpg');
    });
  }

  // 이미지를 삭제하는 메서드입니다.
  void _removeImage(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final Brightness brightness = Theme.of(context).brightness;
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Color(0xFF212121),
          title: Text('이미지 삭제'),
          content: Text('이미지를 삭제하시겠습니까?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  imagePaths.removeAt(index); // 이미지 삭제
                });
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff1e2b67), // 확인 버튼 색상
              ),
              child: Text('확인', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text('취소', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
