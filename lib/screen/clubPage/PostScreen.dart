import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/models/user_model.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/providers/feed/feed_provider.dart';
import 'package:team_project/providers/feed/feed_state.dart';
import 'package:team_project/providers/user/user_state.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/screen/modify/createPostScreen.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'package:team_project/widgets/postItem_widget.dart';

class PostScreen extends StatefulWidget {
  final ClubModel clubModel;

  const PostScreen({super.key, required this.clubModel});

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
        await feedProvider.getFeedList();
      } on CustomException catch (e) {
        errorDialogWidget(context, e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //UserModel currentUserModel = context.read<UserState>().userModel;
    FeedState feedState = context.watch<FeedState>();
    List<FeedModel> feedList = feedState.feedList;
    List<FeedModel> filteredFeedList = feedList
        .where((feed) => feed.clubId == widget.clubModel.clubId)
        .toList();
    ClubModel clubModel = widget.clubModel;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '게시글 갯수: ${filteredFeedList.length}',
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
                  if(widget.clubModel.clubId == feedList[index].clubId)
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
                    clubModel: clubModel,
                  )));
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}