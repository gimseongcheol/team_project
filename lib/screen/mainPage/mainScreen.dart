import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/feed_model.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/providers/feed/feed_provider.dart';
import 'package:team_project/providers/feed/feed_state.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/widgets/Post.dart';
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
    _getFeedList();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _getFeedList() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final clubList = context.read<ClubState>().clubList;
        for (var club in clubList) {
          await feedProvider.getFeedList(clubId: club.clubId);
        }
      } on CustomException catch (e) {
        errorDialogWidget(context, e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    super.build(context);
    FeedState feedState = context.watch<FeedState>();
    List<FeedModel> feedList = feedState.feedList;

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
                itemCount: feedList.length,
                itemBuilder: (context, index) {
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
