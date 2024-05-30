import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/providers/feed/feed_provider.dart';
import 'package:team_project/providers/feed/feed_state.dart';
import 'package:team_project/providers/like/feed_like_provider.dart';
import 'package:team_project/providers/user/user_provider.dart';
import 'package:team_project/providers/user/user_state.dart';
import 'package:team_project/widgets/avatar_widget.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'package:team_project/widgets/heart_anime_widget.dart';
import 'package:team_project/theme/theme_manager.dart';

class FeedCardWidget extends StatefulWidget {
  final FeedModel feedModel;
  final bool isProfile;

  const FeedCardWidget({
    super.key,
    required this.feedModel,
    this.isProfile = false,
  });

  @override
  State<FeedCardWidget> createState() => _FeedCardWidgetState();
}

class _FeedCardWidgetState extends State<FeedCardWidget> {
  final CarouselController carouselController = CarouselController();
  int _indicatorIndex = 0;
  bool isAnimating = false;

  Widget _imageZoomInOutWidget(String imageUrl) {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (context, _, __) {
            return InteractiveViewer(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: ExtendedImage.network(imageUrl),
              ),
            );
          },
        );
      },
      child: ExtendedImage.network(
        imageUrl,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _imageSliderWidget(List<String> imageUrls) {
    return GestureDetector(
      onDoubleTap: () async {
        await _likeFeed();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CarouselSlider(
            carouselController: carouselController,
            items: imageUrls.map((url) => _imageZoomInOutWidget(url)).toList(),
            options: CarouselOptions(
              viewportFraction: 1.0,
              height: MediaQuery.of(context).size.height * 0.35,
              onPageChanged: (index, reason) {
                setState(() {
                  _indicatorIndex = index;
                });
              },
            ),
          ),
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
                Icons.thumb_up,
                color: Colors.black,
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

  Future<void> _likeFeed() async {
    if (context.read<FeedState>().feedStatus == FeedStatus.submitting) {
      return;
    }
    try {
      isAnimating = true;
      FeedModel newFeedModel = await context.read<FeedProvider>().likeFeed(
        feedId: widget.feedModel.feedId,
        feedLikes: widget.feedModel.likes,
      );


      context.read<FeedLikeProvider>().likeFeed(newFeedModel: newFeedModel);

      await context.read<UserProvider>().getUserInfo();
    } on CustomException catch (e) {
      errorDialogWidget(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = context.read<UserState>().userModel.uid;
    FeedModel feedModel = widget.feedModel;
    UserModel userModel = feedModel.writer;
    bool isLike = feedModel.likes.contains(currentUserId);
    final _themeManager = Provider.of<ThemeManager>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                if (currentUserId == feedModel.uid)
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: TextButton(
                              child: Text(
                                '삭제',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () async {
                                try {
                                  // 삭제 로직
                                  await context
                                      .read<FeedProvider>()
                                      .deleteFeed(feedModel: feedModel);

                                  context
                                      .read<FeedLikeProvider>()
                                      .deleteFeed(feedId: feedModel.feedId);


                                  // await context
                                  //     .read<FeedProvider>().getFeedList();

                                  Navigator.pop(context);
                                } on CustomException catch (e) {
                                  errorDialogWidget(context, e);
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.more_vert),
                  ),
              ],
            ),
          ),
          _imageSliderWidget(feedModel.imageUrls),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    await _likeFeed();
                  },
                  child: HeartAnimationWidget(
                    isAnimating: isAnimating,
                    child: isLike
                        ? Icon(
                      Icons.thumb_up,
                      color: Colors.black,
                    )
                        : Icon(
                      Icons.thumb_up_alt_outlined,
                      color: Colors.black,
                    ),
                  ),
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