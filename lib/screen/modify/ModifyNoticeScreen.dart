import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/notice_model.dart';
import 'package:team_project/providers/notice/notice_provider.dart';
import 'package:team_project/providers/notice/notice_state.dart';
import 'package:team_project/screen/mainPage/mainForm.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_project/widgets/edit_notice_widget.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'createNoticeScreen.dart';
import 'revise_notice_screen.dart';
import 'package:provider/provider.dart';

class ModifyNoticeScreen extends StatefulWidget {
  final String clubId;

  const ModifyNoticeScreen({super.key, required this.clubId});

  @override
  State<ModifyNoticeScreen> createState() => _ModifyNoticeScreenState();
}
class _ModifyNoticeScreenState extends State<ModifyNoticeScreen> with AutomaticKeepAliveClientMixin<ModifyNoticeScreen> {
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
    //final _themeManager = Provider.of<ThemeManager>(context);
    super.build(context);
    NoticeState noticeState = context.watch<NoticeState>();
    List<NoticeModel> noticeList = noticeState.noticeList;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '공지사항',
          style: TextStyle(
              fontFamily: 'Dongle', fontWeight: FontWeight.w200, fontSize: 35),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '공지사항 갯수: ${noticeList.length}',
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Divider(),
          Center(
            child: Text(
              '공지사항을 추가하려면 아래 + 아이콘을 눌러주세요!',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: noticeList.length,
              itemBuilder: (context, index) {
                return NoticeItem(clubId: widget.clubId ,noticeModel: noticeList[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainForm()),
          );
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

