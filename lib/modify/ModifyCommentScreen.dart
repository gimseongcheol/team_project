import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'ModifyClubScreen.dart';

// 댓글 창 수정
class ModifyCommentScreen extends StatefulWidget {
  @override
  _ModifyCommentScreenState createState() => _ModifyCommentScreenState();
}

class _ModifyCommentScreenState extends State<ModifyCommentScreen> {
  List<Comment> comments = [
    Comment(
      text: '첫 번째 댓글입니다.',
      author: '사용자1',
      date: DateTime.now(),
    ),
    Comment(
      text: '두 번째 댓글입니다.',
      author: '사용자2',
      date: DateTime.now(),
    ),
  ];
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('댓글'),
            Text(
              '댓글 갯수: ${comments.length}',
              style: TextStyle(fontSize: 14.0), // 댓글 개수 텍스트의 크기를 14로 설정
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentItem(
                  comment: comments[index],
                  onDelete: () {
                    _showDeleteConfirmationDialog(comments[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(Comment comment) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
      builder: (BuildContext context) {
        final Brightness brightness = Theme.of(context).brightness;
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Color(0xFF212121),
          title: Text('댓글 삭제'),
          content: Text('해당 댓글을 삭제하시겠습니까?'), // 메시지 출력
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _deleteComment(comment);
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff1e2b67),
              ),
              child: Text('확인', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text('취소', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _deleteComment(Comment comment) {
    setState(() {
      comments.remove(comment); // 댓글 삭제
    });
  }
}

class CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onDelete;

  CommentItem({required this.comment, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: brightness == Brightness.light
              ? Colors.white
              : Colors.grey[800], // 테마에 따라 배경색 조정
          boxShadow: brightness == Brightness.light
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3), // 그림자 위치 조정
                  ),
                ]
              : null, // 다크 모드에서는 그림자 효과 제거
        ),
        child: ListTile(
          title: Text(comment.text),
          subtitle: Text(
            '${comment.author} - ${DateFormat('yyyy-MM-dd HH:mm').format(comment.date)}',
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
