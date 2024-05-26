import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
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
  int _indicatorIndex = 0;
  final CarouselController carouselController = CarouselController();

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
  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    FeedModel feedModel = widget.feedModel;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          feedModel.title,
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
                    '게시일: ${DateFormat('yyyy-MM-dd HH:mm').format(feedModel.createAt.toDate().add(Duration(hours: 9)))}',
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
              _imageSliderWidget(feedModel.imageUrls),
              SizedBox(height: 8.0),
              Text(
                widget.feedModel.desc,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}