import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/providers/feed/feed_provider.dart';
import 'package:team_project/providers/feed/feed_state.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/screen/modify/createPostScreen.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'package:team_project/widgets/postItem_widget.dart';

class PostScreen extends StatefulWidget {
  final String clubId;

  const PostScreen({super.key, required this.clubId});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with AutomaticKeepAliveClientMixin<PostScreen> {
  late final FeedProvider feedProvider;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    feedProvider = context.read<FeedProvider>();
    _getFeedList();
  }

  void _getFeedList() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await feedProvider.getFeedList(clubId: widget.clubId);
      } on CustomException catch (e) {
        errorDialogWidget(context, e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _themeManager = Provider.of<ThemeManager>(context);
    FeedState feedState = context.watch<FeedState>();
    List<FeedModel> feedList = feedState.feedList;

    //if (feedState.feedStatus == FeedStatus.fetching) {
    //  return Center(
    //    child: CircularProgressIndicator(),
    //  );
    //}
    //if (feedState.feedStatus == FeedStatus.success && feedList.length == 0) {
     // return Center(
     //   child: Text('게시물이 존재하지 않습니다.'),
     // );
   // }
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 60.0,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.white24
                      : Colors.white,
                  hintText: '게시글 검색',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 17,
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.black
                        : Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: _themeManager.themeMode == ThemeMode.dark
                        ? Colors.black
                        : Colors.black87,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _themeManager.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Color(0xff2195f2),
                        width: 1),
                  ),
                ),
                onChanged: (value) {
                  // 검색 기능 추가. => 나중에 추가할것.
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '게시글 갯수: ${feedList.length}',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _getFeedList();
              },
              child: ListView.builder(
                itemCount: feedList.length,
                itemBuilder: (context, index) {
                  return PostItem(
                    feedModel: feedList[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePostScreen(
                        onFeedUploaded: () {},
                        clubId: widget.clubId,
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
