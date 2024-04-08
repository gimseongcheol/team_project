import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/screen/modify/createPostScreen.dart';
import 'package:team_project/widgets/Post.dart';

class PostScreen extends StatelessWidget {
  final List<Post> posts = [
    Post(
      //imageUrl: 'assets/post_image1.jpeg',
      title: '동아리 쫑파티',
      content: '새학기를 맞아 개최한 쫑파티에서 많은 추억을 쌓으셨나요?',
      date: DateTime.now(),
    ),
    Post(
      //imageUrl: 'assets/post_image2.jpg',
      title: '대학생 게임대전 수상자 "홍길동"',
      content: '우리 동아리의 홍길동 학우가 게임대전에서 우승을 차지하였습니다.',
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 60.0,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.white24
                      : Colors.white,
                  hintText: '게시글 검색',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 17,
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.black
                        : Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.black
                        : Colors.black87,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _themeManager.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Color(0xff2195f2), width: 1),
                  ),
                ),
                onChanged: (value) {
                  // 검색 기능 추가. => 나중에 추가할것.
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '게시글 갯수: ${posts.length}',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostItem(post: posts[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreatePostScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PostDetailScreen extends StatefulWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
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
                    '게시일: ${DateFormat('yyyy.MM.dd').format(widget.post.date)}',
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
                widget.post.title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.post.content,
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final Post post;

  PostItem({required this.post});

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(post: post),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: _themeManager.themeMode == ThemeMode.dark
                ? Colors.grey[800]
                : Colors.white,
            boxShadow: _themeManager.themeMode == ThemeMode.dark
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    //post.imageUrl,
                    width: 100.0,
                    height: 100.0,
                    color: Colors.green, //fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        post.content,
                        style: TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.thumb_up,
                                size: 16.0,
                                color: Colors.black,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                '${post.likeCount}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '게시일: ${DateFormat('yyyy.MM.dd').format(post.date)}',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
