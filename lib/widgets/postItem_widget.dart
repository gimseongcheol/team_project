import 'package:carousel_slider/carousel_controller.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/screen/clubPage/post_screen_detail.dart';
import 'package:team_project/theme/theme_manager.dart';

class PostItem extends StatefulWidget {
  final FeedModel feedModel;

  const PostItem({super.key, required this.feedModel});
  @override
  State<PostItem> createState() => _PostItemState();
}
class _PostItemState extends State<PostItem> {
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    FeedModel feedModel = widget.feedModel;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(feedModel: feedModel),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: _themeManager.themeMode == ThemeMode.dark
                ? Colors.grey[800]
                : Colors.white,
            boxShadow: _themeManager.themeMode == ThemeMode.dark
                ? null
                : [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: feedModel.imageUrls == null ||
                            feedModel.imageUrls!.isEmpty
                            ? ExtendedAssetImageProvider(
                            'assets/images/university_circle.jpg') as ImageProvider
                            : ExtendedNetworkImageProvider(
                            feedModel.imageUrls[feedModel.imageUrls.length-1]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedModel.title,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        feedModel.desc,
                        style: TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.thumb_up,
                                size: 16.0,
                                color: Colors.black,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                '${feedModel.likeCount}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '게시일: ${DateFormat('yyyy-MM-dd HH:mm').format(feedModel.createAt.toDate().add(Duration(hours: 9)))}',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
