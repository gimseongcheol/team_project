import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class DescriptionScreen extends StatefulWidget {
  final ClubModel clubModel;

  DescriptionScreen({
    super.key,
    required this.clubModel,
  });

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class Comment {
  final String text;
  final String author;
  final DateTime date;

  Comment({required this.text, required this.author, required this.date});
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  bool _isLiked = false; //나중에 initState로 빼내서 눌렀었는지 확인해야함.
  int _likeCount = 0; //firebase에서 들고와야함
  bool _isReported = false;
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();

  final List<String> imagePaths = [
    'assets/club_image2.jpeg',
    'assets/club_image3.jpg',
    'assets/club_image.jpeg',
  ];

  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    ClubModel clubModel = widget.clubModel;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 250.0,
            child: PageView.builder(
              controller: controller,
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade300,
                    image: DecorationImage(
                      image: AssetImage(imagePaths[index]),
                      fit: BoxFit.cover, // 이미지가 컨테이너에 꽉 차도록 설정
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16), // 간격 조절
          SmoothPageIndicator(
            // 페이지 인디케이터 추가
            controller: controller,
            count: imagePaths.length,
            effect: const WormEffect(
              dotHeight: 16,
              dotWidth: 16,
              type: WormType.thinUnderground,
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 -
                      20, // 화면의 절반 크기로 설정
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isLiked = !_isLiked;
                        if (_isLiked) {
                          _likeCount++;
                        } else {
                          _likeCount--;
                        }
                      });
                    },
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: _isLiked
                              ? Colors.pinkAccent
                              : Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '$_likeCount',
                          style: TextStyle(
                              fontSize: 16.0,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                        ),
                      ],
                    ),
                    tooltip: '좋아요',
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 -
                      20, // 화면의 절반 크기로 설정
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isReported = !_isReported;
                      });
                    },
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.report,
                          color: _isReported
                              ? Colors.red
                              : Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '동아리 신고',
                          style: TextStyle(
                              fontSize: 16.0,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                        ),
                      ],
                    ),
                    tooltip: '동아리 신고',
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 3.0),
          ListTile(
            tileColor: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF444444)
                : Colors.white,
            title: Text(
              '동아리 분류',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(clubModel.clubType,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color)),
          ),
          Divider(),
          SizedBox(height: 3.0),
          ListTile(
            tileColor: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF444444)
                : Colors.white,
            title: Text(
              '회장',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(clubModel.presidentName,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color)),
          ),
          Divider(),
          ListTile(
            tileColor: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF444444)
                : Colors.white,
            title: Text(
              '연락처',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              clubModel.call,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color),
            ),
          ),
          Divider(),
          ListTile(
            tileColor: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF444444)
                : Colors.white,
            title: Text(
              '담당 교수',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              clubModel.professorName,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color),
            ),
          ),
          Divider(),
          ListTile(
            tileColor: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF444444)
                : Colors.white,
            title: Text(
              '한줄 소개',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              clubModel.shortComment,
            ),
          ),
          Divider(),
          ListTile(
            tileColor: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF444444)
                : Colors.white,
            title: Text(
              '동아리 소개',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
             clubModel.fullComment
            ),
          ),
        ],
      ),
    );
  }
}
