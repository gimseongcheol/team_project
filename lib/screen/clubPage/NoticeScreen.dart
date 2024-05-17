import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/notice_model.dart';
import 'package:team_project/providers/notice/notice_provider.dart';
import 'package:team_project/providers/notice/notice_state.dart';
import 'package:team_project/screen/modify/ModifyNoticeScreen.dart';
import 'package:team_project/screen/modify/createNoticeScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'package:team_project/widgets/noticeItem_widget.dart';

class NoticeScreen extends StatefulWidget {
  final String clubId;

  const NoticeScreen({super.key, required this.clubId});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> with AutomaticKeepAliveClientMixin<NoticeScreen> {
  late final NoticeProvider noticeProvider;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    noticeProvider = context.read<NoticeProvider>();
    _getNoticeList();
  }

  void _getNoticeList() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await noticeProvider.getNoticeList(clubId: widget.clubId);
      } on CustomException catch (e) {
        errorDialogWidget(context, e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _themeManager = Provider.of<ThemeManager>(context);
    NoticeState noticeState = context.watch<NoticeState>();
    List<NoticeModel> noticeList = noticeState.noticeList;

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
                  '게시글 갯수: ${noticeList.length}',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _getNoticeList();
              },
              child: ListView.builder(
                itemCount: noticeList.length,
                itemBuilder: (context, index) {
                  return NoticesItem(
                    noticeModel: noticeList[index],
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
                  builder: (context) => CreateNoticeScreen(
                    onNoticeUploaded: () {},
                    clubId: widget.clubId,
                  )));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}