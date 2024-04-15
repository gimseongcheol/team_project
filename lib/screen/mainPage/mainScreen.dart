import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/widgets/Post.dart';
import 'package:team_project/screen/clubPage/PostScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isMoved = false;
  final ScrollController _scrollController = ScrollController();
  final List<Post> posts = [
    Post(
      //imageUrl: 'assets/post_image1.jpeg',
      title: '동아리 쫑파티',
      content: '새학기를 맞아 개최한 쫑파티에서 많은 추억을 쌓으셨나요?',
      date: DateTime.now(),
    ),
  ];

  void initState() {
    super.initState();
    // 4초 후에 이미지를 원래 위치로 되돌립니다.
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _isMoved = !_isMoved;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isMoved = !_isMoved;
                });
              },
              child: AnimatedContainer(
                duration: Duration(seconds: 8),
                curve: Curves.linear,
                transform: Matrix4.translationValues(
                  _isMoved ? MediaQuery.of(context).size.width - 150 : 0,
                  0,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/university.png',
                      height: 60,
                      width: 60,
                    ),
                    Image.asset(
                      'assets/images/university_main_logo_name.png',
                      height: 60,
                      width: 100,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [SizedBox(width: 7), _buildCategoryText('동아리 최신 게시글')],
            ),
            Scrollbar(
              controller: _scrollController,
              child: _buildHorizontalListView(_buildColorContainers()),
            ),
            SizedBox(height: 15),
            Row(
              children: [SizedBox(width: 7), _buildCategoryText('한주간 인기 게시글')],
            ),
            Scrollbar(
              controller: _scrollController,
              child: _buildHorizontalListView(_buildColorContainers()),
            ),
            SizedBox(height: 15),
            Row(
              children: [SizedBox(width: 7), _buildCategoryText('전화 번호')],
            ),
            SizedBox(height: 10),
            _buildPhoneContainer(
              title: '총 학생회',
              phoneNumber: '053) 850-2910',
            ),
            SizedBox(height: 5),
            _buildPhoneContainer(
              title: '총 동아리 연합회',
              phoneNumber: '053) 850-2930',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryText(String text) {
    return Text(
      text,
      style: TextStyle(fontFamily: 'YeongdeokSea', fontSize: 23),
    );
  }

  Widget _buildHorizontalListView(List<Widget> children) {
    //Post들고와서 작업하도록 수정하기
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: children,
      ),
    );
  }

  List<Widget> _buildColorContainers() {
    return List.generate(
      5,
      (index) => Card(
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.yellow[200],
          ),
          width: 180.0,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ListTile(
                    tileColor: Provider.of<ThemeManager>(context).themeMode ==
                        ThemeMode.dark
                        ? Color(0xFFFFFF9F)
                        : Colors.yellow[200],
                    title: Text(
                      '${index + 1} 게시글 제목',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      '게시글 글',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Provider.of<ThemeManager>(context).themeMode ==
                      ThemeMode.dark
                      ? Color(0xFFFFFF9F)
                      : Colors.yellow[200],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: LikeCount(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget LikeCount() {
    return Row(
      children: [
        Icon(
          Icons.thumb_up_alt_outlined,
          color: Colors.black,
        ),
        Text(
          '0',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildPhoneContainer({
    required String title,
    required String phoneNumber,
  }) {
    return GestureDetector(
      onTap: () {
        launch('tel:${phoneNumber}'); //여기 에러가 뜸 권한부여인지 아직 미정 좀더 확인해야함.
      },
      child: Card(
        elevation: 3,
        child: ListTile(
          leading: Icon(
            Icons.call,
            size: 30,
            color:
                Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                    ? Color(0xFF2DC764)
                    : Colors.black,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w200,
              color:
                  Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                      ? Color(0xFF2DC764)
                      : Colors.black,
            ),
          ),
          subtitle: Text(
            phoneNumber,
            style: TextStyle(
              fontSize: 17,
              color:
                  Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                      ? Color(0xFF2DC764)
                      : Colors.black,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
