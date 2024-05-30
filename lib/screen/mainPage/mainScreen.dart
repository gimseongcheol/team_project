import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/providers/feed/feed_provider.dart';
import 'package:team_project/providers/feed/feed_state.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'package:team_project/widgets/post_card_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with AutomaticKeepAliveClientMixin<MainScreen> {
  bool _isMoved = false;
  final ScrollController _scrollController = ScrollController();
  late final FeedProvider feedProvider;

  @override
  bool get wantKeepAlive => true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _isMoved = !_isMoved;
      });
    });
    feedProvider = context.read<FeedProvider>();
    _scrollController.addListener(scrollListener);
    _getFeedList();
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListener);
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }
  void scrollListener() {
    FeedState feedState = context.read<FeedState>();

    if (feedState.feedStatus == FeedStatus.reFetching) {
      return;
    }
    bool hasNext = feedState.hasNext;
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        hasNext) {
      FeedModel lastFeedModel = feedState.feedList.last;
      context.read<FeedProvider>().getFeedList(
        feedId: lastFeedModel.feedId,
      );
    }
  }
  void _getFeedList() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        //final clubList = context.read<ClubState>().clubList;
        await feedProvider.getFeedList();
      } on CustomException catch (e) {
        errorDialogWidget(context, e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    FeedState feedState = context.watch<FeedState>();
    List<FeedModel> feedList = feedState.feedList;

    if (feedState.feedStatus == FeedStatus.fetching) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (feedState.feedStatus == FeedStatus.success && feedList.length == 0) {
      return Center(
        child: Text('게시물이 존재하지 않습니다.'),
      );
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _isMoved = !_isMoved;
              });
            },
            child: AnimatedContainer(
              duration: Duration(seconds: 8),
              curve: Curves.linear,
              transform: Matrix4.translationValues(
                _isMoved ? MediaQuery.of(context).size.width - 150 : 0,
                0,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/university_main_logo.png',
                    height: 60,
                    width: 200,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _getFeedList();
              },
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: feedList.length + 1,
                itemBuilder: (context, index) {
                  if (feedList.length == index) {
                    return feedState.hasNext
                        ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : Container();
                  }

                  return FeedCardWidget(feedModel: feedList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryText(String text) {
    return Text(
      text,
      style: TextStyle(fontFamily: 'YeongdeokSea', fontSize: 23),
    );
  }
}
