import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/theme/theme_manager.dart';

class PostCardWidget extends StatefulWidget {
  final FeedModel feedModel;

  const PostCardWidget({
    super.key,
    required this.feedModel,
  });

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  @override
  Widget build(BuildContext context) {
    FeedModel feedModel = widget.feedModel;

    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.yellow[200],
        ),
        width: 180.0,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ListTile(
                  tileColor: Provider.of<ThemeManager>(context).themeMode ==
                      ThemeMode.dark
                      ? Color(0xFFFFFF9F)
                      : Colors.yellow[200],
                  title: Text(
                    feedModel.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    feedModel.desc,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Provider.of<ThemeManager>(context).themeMode ==
                    ThemeMode.dark
                    ? Color(0xFFFFFF9F)
                    : Colors.yellow[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: LikeCount(), // 이 부분은 LikeCount 위젯이 어디서 가져오는지에 대한 정보가 없어서 대체하였습니다. 실제 사용하는 위젯을 추가해야 합니다.
            ),
          ],
        ),
      ),
    );
  }
}
Widget LikeCount() {
  return Row(
    children: [
      Icon(
        Icons.thumb_up_alt_outlined,
        color: Colors.black,
      ),
      Text(
        '0',
        style: TextStyle(color: Colors.black),
      ),
    ],
  );
}
