import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/providers/club/club_provider.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/providers/like/like_provider.dart';
import 'package:team_project/providers/report/report_provider.dart';
import 'package:team_project/providers/user/user_provider.dart';
import 'package:team_project/providers/user/user_state.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'package:team_project/widgets/heart_anime_widget.dart';


class DescriptionScreen extends StatefulWidget {
  final ClubModel clubModel;

  DescriptionScreen({
    super.key,
    required this.clubModel,
  });

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}


class _DescriptionScreenState extends State<DescriptionScreen> {
  bool _isReported = false;
  TextEditingController commentController = TextEditingController();
  final CarouselController carouselController = CarouselController();
  int _indicatorIndex = 0;
  bool isAnimating = false;

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
    return GestureDetector(
        onDoubleTap: () async {
          await _likeClub();
        },
      child: Stack(
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
          ),
          Opacity(
            opacity: isAnimating ? 1 : 0,
            child: HeartAnimationWidget(
              isAnimating: isAnimating,
              child: Icon(
                Icons.favorite,
                color: Colors.redAccent,
                size: 100,
              ),
              onEnd: () => setState(() {
                isAnimating = false;
              }),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _likeClub() async {
    if (context.read<ClubState>().clubStatus == ClubStatus.submitting) {
      return;
    }
    try {
      isAnimating = true;
      ClubModel newClubModel = await context.read<ClubProvider>().likeClub(
        clubId: widget.clubModel.clubId,
        clubLikes: widget.clubModel.likes,
      );

      context.read<LikeProvider>().likeClub(newClubModel: newClubModel);

      await context.read<UserProvider>().getUserInfo();
    } on CustomException catch (e) {
      errorDialogWidget(context, e);
    }
  }
  //final controller = PageController(viewportFraction: 0.8, keepPage: true);
  Future<void> _reportClub() async {
    if (context.read<ClubState>().clubStatus == ClubStatus.submitting) {
      return;
    }
    try {
      ClubModel newClubModel = await context.read<ClubProvider>().reportClub(
        clubId: widget.clubModel.clubId,
        clubReports: widget.clubModel.reports,
      );

      context.read<ReportProvider>().reportClub(newClubModel: newClubModel);

      await context.read<UserProvider>().getUserInfo();
    } on CustomException catch (e) {
      errorDialogWidget(context, e);
    }
  }
  @override
  Widget build(BuildContext context) {
    String currentUserId = context.read<UserState>().userModel.uid;
    final _themeManager = Provider.of<ThemeManager>(context);
    ClubModel clubModel = widget.clubModel;
    bool isLike = clubModel.likes.contains(currentUserId);
    bool isReport = clubModel.reports.contains(currentUserId);

    //User? currentUser = FirebaseAuth.instance.currentUser;
    //ProfileState profileState = context.watch<ProfileState>();
    // 프로필을 확인하려는 유저의 정보
    //UserModel userModel = profileState.userModel;
    //UserModel userModel = context.read<ProfileState>().userModel;
    //logger.d(context.watch<ProfileState>().userModel);

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
                    onPressed: () {},
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async{
                            await _likeClub();
                          },
                          child: HeartAnimationWidget(
                            isAnimating: isAnimating,
                            child: isLike
                                ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                                : Icon(
                              Icons.favorite_border,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),

                        SizedBox(width: 4.0),
                        Text(
                          clubModel.likeCount.toString(),
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
                    onPressed: () async{
                      await _reportClub();
                      },
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isReport
                            ? Icon(
                          Icons.report_problem,
                          color: Colors.red,
                        )
                            : Icon(
                          Icons.report_problem_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),

                        SizedBox(width: 4.0),
                        Text(
                          clubModel.reportCount.toString(),
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
              '동아리 분류 (' + clubModel.clubType+')',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(clubModel.depart,
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
