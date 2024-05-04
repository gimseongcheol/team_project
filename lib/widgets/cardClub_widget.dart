import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/models/club_model.dart';
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
  final CarouselController carouselController = CarouselController();
  int _indicatorIndex = 0;

  Widget _imageZoomInOutWidget(String profileImageUrl) {
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
                  child: ExtendedImage.network(profileImageUrl)),
            );
          },
        );
      },
      //이미지
      child: ExtendedImage.network(
        profileImageUrl,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
    );
  }

//이미지 슬라이더
  Widget _imageSliderWidget(List<String> profileImageUrl) {
    return Stack(
      children: [
        CarouselSlider(
          carouselController: carouselController,
          items: profileImageUrl.map((url) => _imageZoomInOutWidget(url)).toList(),
          options: CarouselOptions(
            viewportFraction: 1.0,
            height: MediaQuery.of(context).size.height * 0.35,
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
              children: profileImageUrl.asMap().keys.map((e) {
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
        ),
      ),
    );
  }
}
