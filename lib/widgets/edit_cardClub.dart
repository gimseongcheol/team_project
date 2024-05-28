import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/providers/club/club_provider.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/screen/clubPage/ClubMainScreen.dart';
import 'package:team_project/screen/modify/ModifyClubScreen.dart';
import 'package:team_project/screen/modify/ModifyNoticeScreen.dart';
import 'package:team_project/screen/modify/ModifyPostScreen.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';

class EditCardClubWidget extends StatefulWidget {
  final ClubModel clubModel;

  const EditCardClubWidget({
    super.key,
    required this.clubModel,
  });

  @override
  State<EditCardClubWidget> createState() => _EditCardClubWidgetState();
}

class _EditCardClubWidgetState extends State<EditCardClubWidget> {
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    ClubModel clubModel = widget.clubModel;
    final _themeManager = Provider.of<ThemeManager>(context);
    final clubProvider = Provider.of<ClubProvider>(context);

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
            icon: Icon(Icons.more_vert, color: Colors.black),
            color: Colors.white,
            onSelected: (value) {
              switch (value) {
                case 'editInfo':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ModifyClubScreen()));
                  break;
                  break;
                 case 'delClub':
                   _showDeleteDialog(context, clubProvider, clubModel);
                   break;
                 case 'manageNotices':
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) => ModifyNoticeScreen(clubId: clubModel.clubId,)));
                   break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'editInfo',
                child: Text(
                  '정보 수정하기',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              PopupMenuItem<String>(
                value: 'delClub',
                child: Text(
                  '동아리 삭제',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              PopupMenuItem<String>(
                value: 'manageNotices',
                child: Text(
                  '공지 관리하기',
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

void _showDeleteDialog(BuildContext context, ClubProvider clubProvider, ClubModel clubModel) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: TextButton(
          child: Text(
            '삭제',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () async {
            try {
              await clubProvider.deleteClub(clubModel: clubModel);
              Navigator.pop(context);
            } on CustomException catch (e) {
              // Show error dialog
              errorDialogWidget(context, e);
            }
          },
        ),
      );
    },
  );
}