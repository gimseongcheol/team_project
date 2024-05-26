import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/widgets/avatar_widget.dart';

class FeedCardWidget extends StatefulWidget {
  final FeedModel feedModel;

  const FeedCardWidget({
    super.key,
    required this.feedModel,
  });

  @override
  State<FeedCardWidget> createState() => _FeedCardWidgetState();
}

class _FeedCardWidgetState extends State<FeedCardWidget> {
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
        fit: BoxFit.contain
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

  @override
  Widget build(BuildContext context) {
    FeedModel feedModel = widget.feedModel;
    UserModel userModel = feedModel.writer;

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //이미지 위 기능(프로필, 더보기)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                AvatarWidget(userModel: userModel),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    userModel.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          //이미지슬라이더 불러오기
          _imageSliderWidget(feedModel.imageUrls),
          //좋아요 댓글기능
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              children: [
                Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Text(
                  feedModel.likeCount.toString(),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                Spacer(),
                Text(
                  feedModel.createAt.toDate().toString().split(' ')[0],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          //게시글
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              feedModel.desc,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
