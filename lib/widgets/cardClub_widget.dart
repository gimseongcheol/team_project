import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/screen/clubPage/ClubMainScreen.dart';
import 'package:team_project/theme/theme_manager.dart';

class CardClubWidget extends StatefulWidget {
  final ClubModel clubModel;

  const CardClubWidget({
    super.key,
    required this.clubModel,
  });

  @override
  State<CardClubWidget> createState() => _CardClubWidgetState();
}

class _CardClubWidgetState extends State<CardClubWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ClubModel clubModel = widget.clubModel;
    final _themeManager = Provider.of<ThemeManager>(context);
//동아리 타입과 부서 조건문 짜야함
    return Expanded(
      child: Scrollbar(
        controller: _scrollController,
        thickness: 5,
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                // 네비게이션을 통해 클럽 메인 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClubMainScreen(),
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
                                    'assets/images/university_circle.jpg')
                                as ImageProvider
                            : ExtendedNetworkImageProvider(
                                clubModel.profileImageUrl[0]),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
