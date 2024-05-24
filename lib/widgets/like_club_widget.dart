import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/providers/club/club_provider.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/providers/like/like_provider.dart';
import 'package:team_project/providers/user/user_provider.dart';
import 'package:team_project/screen/clubPage/ClubMainScreen.dart';
import 'package:team_project/screen/modify/ModifyClubScreen.dart';
import 'package:team_project/screen/modify/ModifyNoticeScreen.dart';
import 'package:team_project/screen/modify/ModifyPostScreen.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';

class LikeCardClubWidget extends StatefulWidget {
  final ClubModel clubModel;

  const LikeCardClubWidget({
    super.key,
    required this.clubModel,
  });

  @override
  State<LikeCardClubWidget> createState() => _LikeCardClubWidgetState();
}

class _LikeCardClubWidgetState extends State<LikeCardClubWidget> {
  final CarouselController carouselController = CarouselController();
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    ClubModel clubModel = widget.clubModel;
    final _themeManager = Provider.of<ThemeManager>(context);

//동아리 타입과 부서 조건문 짜야함
    return GestureDetector(
      onTap: () {
        // 네비게이션을 통해 클럽 메인 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClubMainScreen(clubModel: clubModel),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: _themeManager.themeMode == ThemeMode.dark
              ? BorderSide(color: Colors.white, width: 1)
              : BorderSide(color: Colors.black, width: 1),
        ),
        child: ListTile(
          tileColor: _themeManager.themeMode == ThemeMode.dark
              ? Color(0xFF444444)
              : Colors.white,
          leading: Container(
            width: 40,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: clubModel.profileImageUrl == null ||
                    clubModel.profileImageUrl!.isEmpty
                    ? ExtendedAssetImageProvider(
                    'assets/images/university_circle.jpg') as ImageProvider
                    : ExtendedNetworkImageProvider(
                    clubModel.profileImageUrl[clubModel.profileImageUrl.length-1]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            clubModel.clubName,
            style: TextStyle(
              color: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.white70
                  : Colors.black,
            ),
          ),
          subtitle: Text(
            clubModel.shortComment,
            style: TextStyle(
              color: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.white70
                  : Colors.black,
            ),
          ),
          trailing: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,color: Colors.black,),
            color: Colors.white,
            onSelected: (value) {
              switch (value) {
                case 'cancelLike':
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'cancelLike',
                child: TextButton(
                  child: Text(
                    '삭제하기',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () => _showdialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Future<dynamic> _showdialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor:
      Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
          ? Color(0xFF212121)
          : Colors.white,
      title: Text(
        '재확인',
        style: TextStyle(
            color:
            Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black),
      ),
      content: Text(
        '삭제하시겠습니까?',
        style: TextStyle(
            color:
            Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black),
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white70,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('아니요', style: TextStyle(color: Colors.black),)),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                  ? Color(0xff1c213a)
                  : Color(0xff1e2b67),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('예', style: TextStyle(color: Colors.white))),
      ],
    ),
  );
}