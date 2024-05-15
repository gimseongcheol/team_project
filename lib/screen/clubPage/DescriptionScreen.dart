import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/profile/profile_state.dart';
import '../../utils/logger.dart';

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
  int _likeCount = 0; //firebase에서 들고와야함 //현재 사용안함 일단은 냅두고
  bool _isReported = false;
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();
  final CarouselController carouselController = CarouselController();
  int _indicatorIndex = 0;

  Widget _imageZoomInOutWidget(String imageUrl) {
    //터치했을 때 보이는 이미지
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (context, _, __) {
            //확대
            return InteractiveViewer(
              //다시 클릭시 화면 닫힘
              child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: ExtendedImage.network(imageUrl)),
            );
          },
        );
      },
      //이미지
      child: ExtendedImage.network(
        imageUrl,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.contain,
      ),
    );
  }

//이미지 슬라이더
  Widget _imageSliderWidget(List<String> imageUrls) {
    return Stack(
      children: [
        CarouselSlider(
          carouselController: carouselController,
          items: imageUrls.map((url) => _imageZoomInOutWidget(url)).toList(),
          options: CarouselOptions(
            viewportFraction: 1.0,
            height: MediaQuery.of(context).size.height * 0.4,
            onPageChanged: (index, reason) {
              _indicatorIndex = index;
            },
          ),
        ),
        //이미지 수에 따라 동그라미 추가
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageUrls.asMap().keys.map((e) {
                return Container(
                  width: 8,
                  height: 8,
                  margin:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                        .withOpacity(_indicatorIndex == e ? 0.9 : 0.4),
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    ClubModel clubModel = widget.clubModel;
    User? currentUser = FirebaseAuth.instance.currentUser;
    ProfileState profileState = context.watch<ProfileState>();
    // 프로필을 확인하려는 유저의 정보
    UserModel userModel = profileState.userModel;
    //UserModel userModel = context.read<ProfileState>().userModel;
    logger.d(context.watch<ProfileState>().userModel);

    return SingleChildScrollView(
      child: Column(
        children: [
          _imageSliderWidget(clubModel.profileImageUrl),
          Divider(),
          //좋아요
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
                              ? Colors.red
                              : Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '${clubModel.likes.length}',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                          ),
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
