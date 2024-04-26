import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class EditComment extends StatefulWidget {
  @override
  _EditCommentState createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {
  late List<Slidable> _items;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _items = [
      _buildListTile('동아리1', '내가 쓴 댓글 내용'),
      _buildListTile('동아리2', '내가 쓴 댓글 내용'),
    ];
  }

  Slidable _buildListTile(String title, String subtitle) {
    return Slidable(
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(width: 1),
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              tileColor: Colors.white,
              leading: Container(
                width: 40,
                height: 80,
                color: Colors.greenAccent,
              ),
              title: Text(
                title,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(color: Colors.black),
              ),
              trailing: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,color: Colors.black),
                color: Colors.white,
                onSelected: (value) {
                  switch (value) {
                    case 'editComment':
                      break;
                    case 'deleteComment':
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'editComment',
                    child: TextButton(
                      child: Text(
                        '수정하기',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () => _fixDialog(context, '수정'),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'deleteComment',
                    child: TextButton(
                      child: Text(
                        '삭제하기',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () => _showdialog(context, '삭제'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 8),
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: '검색하세요.',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 17,
                      color: Colors.black87,
                    ),
                    suffixIcon: Icon(Icons.search, color: Colors.black),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thickness: 7,
                child: ListView(
                  children: _items,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showdialog(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor:
            Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                ? Color(0xFF212121)
                : Colors.white,
        title: Text(
          '$text' + '하기',
          style: TextStyle(
              color:
                  Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
        ),
        content: Text(
          '$text' + '하시겠습니까?',
          style: TextStyle(
              color:
                  Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
        ),
        actions: [
          ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white70,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '아니요',
                style: TextStyle(color: Colors.black),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Provider.of<ThemeManager>(context).themeMode ==
                        ThemeMode.dark
                    ? Color(0xff1c213a)
                    : Color(0xff1e2b67),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '예',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }

  Future<dynamic> _fixDialog(BuildContext context, String text) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor:
            Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                ? Color(0xFF212121)
                : Colors.white,
        title: Text(
          '$text' + '하기',
          style: TextStyle(
              color:
                  Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: '댓글내용',
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                            ? Colors.black
                            : Color(0xFF2195F2)), // 선택된 색상
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소', style: TextStyle(color: Colors.black),)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                    ? Color(0xff1c213a)
                    : Color(0xff1e2b67),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인', style: TextStyle(color: Colors.white),)),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
