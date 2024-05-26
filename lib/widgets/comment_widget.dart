import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/comment_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/providers/comment/comment_provider.dart';
import 'package:team_project/providers/profile/profile_state.dart';
import 'package:team_project/screen/clubPage/ClubMainScreen.dart';
import 'package:team_project/screen/clubPage/CommentScreen.dart';
import 'package:team_project/screen/mainPage/clubSearch.dart';
import 'package:team_project/theme/theme_manager.dart';

class CommentCardClubWidget extends StatefulWidget {
  final CommentModel commentModel;
  final ClubModel clubModel;

  const CommentCardClubWidget({
    super.key,
    required this.commentModel,
    required this.clubModel,
  });

  @override
  State<CommentCardClubWidget> createState() => _CommentCardClubWidgetState();
}

class _CommentCardClubWidgetState extends State<CommentCardClubWidget> {
  final CarouselController carouselController = CarouselController();
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    CommentModel commentModel = widget.commentModel;
    ClubModel clubModel = widget.clubModel;
    final _themeManager = Provider.of<ThemeManager>(context);
    ProfileState profileState = context.watch<ProfileState>();
    UserModel userModel = profileState.userModel;
    final commentProvider = Provider.of<CommentProvider>(context);

//동아리 타입과 부서 조건문 짜야함
    return GestureDetector(
      onTap: () {
        // 네비게이션을 통해 클럽 메인 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClubSearch(),
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
          leading: CircleAvatar(
            backgroundImage: userModel.profileImage == null
                ? ExtendedAssetImageProvider(
                'assets/images/profile.png') as ImageProvider
                : ExtendedNetworkImageProvider(
                userModel.profileImage!),
            radius: 20,
          ),
          title: Text(
            commentModel.comment,
            style: TextStyle(
              color: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.white70
                  : Colors.black,
              fontSize: 17,
            ),
          ),
          subtitle: Text(
            commentModel.writer.userid +' '+ commentModel.writer.name,
            style: TextStyle(
              color: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.white70
                  : Colors.black,
              fontSize: 12,
            ),
          ),
          trailing: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black),
            color: Colors.white,
            onSelected: (value) {
              if (value == 'cancelComment') {
                _showDeleteDialog(context, commentProvider, clubModel, commentModel);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'cancelComment',
                child: Text(
                  '삭제하기',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Future<void> _showDeleteDialog(
    BuildContext context, CommentProvider commentProvider, ClubModel clubModel, CommentModel commentModel) {
  return showDialog(
    context: context,
    builder: (context) {
      final themeManager = Provider.of<ThemeManager>(context);
      return AlertDialog(
        backgroundColor: themeManager.themeMode == ThemeMode.dark
            ? Color(0xFF212121)
            : Colors.white,
        title: Text(
          '재확인',
          style: TextStyle(
            color: themeManager.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        content: Text(
          '삭제하시겠습니까?',
          style: TextStyle(
            color: themeManager.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white70,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('아니요', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: themeManager.themeMode == ThemeMode.dark
                  ? Color(0xff1c213a)
                  : Color(0xff1e2b67),
            ),
            onPressed: () async {
              try {
                await commentProvider.deleteComment(
                    clubModel: clubModel, commentModel: commentModel);
                Navigator.of(context).pop();
              } on CustomException catch (e) {
                _showErrorDialog(context, e);
              }
            },
            child: Text('예', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

void _showErrorDialog(BuildContext context, CustomException e) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(e.message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
