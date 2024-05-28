import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/models/notice_model.dart';
import 'package:team_project/providers/notice/notice_provider.dart';
import 'package:team_project/screen/clubPage/notice_screen_detail.dart';
import 'package:team_project/screen/modify/ModifyNoticeScreen.dart';
import 'package:team_project/screen/modify/revise_notice_screen.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';

class NoticeItem extends StatefulWidget {
  final NoticeModel noticeModel;
  final String clubId;

  const NoticeItem({super.key, required this.noticeModel, required this.clubId});

  @override
  State<NoticeItem> createState() => _NoticeItemState();
}
class _NoticeItemState extends State<NoticeItem>{
@override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    NoticeModel noticeModel = widget.noticeModel;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeDetailsScreen(noticeModel: noticeModel),
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
                        image: noticeModel.imageUrls == null ||
                            noticeModel.imageUrls!.isEmpty
                            ? ExtendedAssetImageProvider(
                            'assets/images/university_circle.jpg') as ImageProvider
                            : ExtendedNetworkImageProvider(
                            noticeModel.imageUrls[noticeModel.imageUrls.length-1]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              noticeModel.title,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // 수정 버튼 클릭 시 처리할 동작 추가
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReviseNoticeScreen(noticeModel: noticeModel,clubId: widget.clubId,onEditNoticeUploaded: () {

                                            },)),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // 삭제 버튼 클릭 시 처리할 동작 추가
                                  _showDeleteConfirmationDialog(context, noticeModel, widget.clubId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 3.0),
                      Text(
                        noticeModel.desc,
                        style: TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '게시일: ${DateFormat('yyyy-MM-dd HH:mm').format(noticeModel.createAt.toDate().add(Duration(hours: 9)))}',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
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

  void _showDeleteConfirmationDialog(BuildContext context, NoticeModel noticeModel, String clubId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _themeManager = Provider.of<ThemeManager>(context);
        return AlertDialog(
          backgroundColor: _themeManager.themeMode == ThemeMode.dark
              ? Color(0xFF212121)
              : Colors.white,
          title: Text(
            '공지 삭제',
            style: TextStyle(
                color: _themeManager.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black),
          ),
          content: Text(
            '공지를 삭제하시겠습니까?',
            style: TextStyle(
              color: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ), // 메시지 출력
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70,
              ),
              child: Text('취소', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () async{
                try {
                  // 삭제 로직
                  await context
                      .read<NoticeProvider>()
                      .deleteNotice(clubId: clubId,noticeModel: noticeModel);

                  // await context
                  //     .read<FeedProvider>().getFeedList();

                  Navigator.pop(context);
                } on CustomException catch (e) {
                  errorDialogWidget(context, e);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeManager.themeMode == ThemeMode.dark
                    ? Color(0xff1c213a)
                    : Color(0xff1e2b67),
              ),
              child: Text('삭제', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}