import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/theme/theme_manager.dart';

class PostDetailScreen extends StatefulWidget {
  final FeedModel feedModel;

  const PostDetailScreen({super.key, required this.feedModel});
  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}
class _PostDetailScreenState extends State<PostDetailScreen> {
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    FeedModel feedModel = widget.feedModel;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '게시물 상세 정보',
          style: TextStyle(
            fontFamily: 'Dongle',
            color: Colors.white, // 텍스트 색상을 하얀색으로 지정
            fontSize: 35,
            fontWeight: FontWeight.w200,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // 뒤로가기 버튼 색상을 하얀색으로 지정
          ),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 기능
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), // 둥근 사각형 모양 적용
            color: _themeManager.themeMode == ThemeMode.dark
                ? Colors.grey[800]
                : Colors.white, // 배경색을 테마에 따라 지정
            boxShadow: _themeManager.themeMode == ThemeMode.dark
                ? null
                : [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3), // 그림자 위치 조정
              ),
            ], // 다크 모드에서는 그림자 효과 제거
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '게시일: ${DateFormat('yyyy-MM-dd HH:mm').format(feedModel.createAt.toDate())}',
                    style:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up),
                        color: _isLiked ? Colors.blue : null,
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
                      ),
                      Text(
                        '$_likeCount',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              //ClipRRect( -> 이거 게시물 사진 보이는 건데 firebase연동해서 가져오는 방식으로 짜기
              //borderRadius: BorderRadius.circular(15.0),
              //child: Image.asset(
              //widget.post.imageUrl,
              //width: double.infinity,
              //height: 230.0,
              //fit: BoxFit.cover,
              //),
              //),
              SizedBox(height: 16.0),
              Text(
                widget.feedModel.title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.feedModel.desc,
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}