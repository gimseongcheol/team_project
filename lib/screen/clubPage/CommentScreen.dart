import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'DescriptionScreen.dart';
import 'package:provider/provider.dart';
import 'package:team_project/theme/theme_manager.dart';

class CommentScreen extends StatefulWidget {
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '댓글 갯수: ${comments.length}',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ],
          ),
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
          Container(
            margin: EdgeInsets.only(bottom: 30.0), // 아래쪽으로 20.0만큼 마진 추가
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                // 클릭시 색상 변경
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: TextField(
                controller: commentController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: '댓글을 입력하세요',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF2195F2), width: 1.0), // 클릭 시 테두리 색상 설정
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        comments.add(Comment(
                          text: commentController.text,
                          author: '작성자',
                          date: DateTime.now(),
                        ));
                        commentController.clear();
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(Comment comment) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final _themeManager = Provider.of<ThemeManager>(context);
        return AlertDialog(
          backgroundColor: _themeManager.themeMode == ThemeMode.dark
              ? Color(0xFF212121)
              : Colors.white,
          title: Text('댓글 삭제'),
          content: Text('해당 댓글을 삭제하시겠습니까?'), // 메시지 출력
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _deleteComment(comment);
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white70,
              ),
              child: Text('취소', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              style: ElevatedButton.styleFrom(
                primary: _themeManager.themeMode == ThemeMode.dark
                    ? Color(0xff1c213a)
                    : Color(0xff1e2b67),
              ),
              child: Text('확인', style: TextStyle(color: Colors.white)),
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
    final _themeManager = Provider.of<ThemeManager>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: _themeManager.themeMode == ThemeMode.dark
              ? Colors.grey[800]
              : Colors.white, // 테마에 따라 배경색 조정
          boxShadow: _themeManager.themeMode == ThemeMode.dark
              ? null
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3), // 그림자 위치 조정
                  ),
                ], // 다크 모드에서는 그림자 효과 제거
        ),
        child: ListTile(
          tileColor: _themeManager.themeMode == ThemeMode.dark
              ? Color(0xff505050)
              : Colors.white,
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
