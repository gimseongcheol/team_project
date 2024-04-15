import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:team_project/theme/theme_manager.dart';

class SubClub extends StatefulWidget {
  const SubClub({Key? key}) : super(key: key);

  @override
  _SubClubState createState() => _SubClubState();
}

class _SubClubState extends State<SubClub> {
  late List<Slidable> _items;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeItems();
  }

  void _initializeItems() {
    _items = List.generate(
      2,
      (index) => Slidable(
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
                  color: Colors.blueAccent,
                ),
                title: Text(
                  '동아리${index + 1}',
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  '동아리${index + 1} 소개글',
                  style: TextStyle(color: Colors.black),
                ),
                trailing: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert,color: Colors.black,),
                  color: Colors.white,
                  onSelected: (value) {
                    switch (value) {
                      case 'cancelLike':
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'cancelLike',
                      child: TextButton(
                        child: Text(
                          '삭제하기',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () => _showdialog(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  Future<dynamic> _showdialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor:
            Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                ? Color(0xFF212121)
                : Colors.white,
        title: Text(
          '재확인',
          style: TextStyle(
              color:
                  Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
        ),
        content: Text(
          '삭제하시겠습니까?',
          style: TextStyle(
              color:
                  Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
        ),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white70,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('아니요', style: TextStyle(color: Colors.black),)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Provider.of<ThemeManager>(context).themeMode == ThemeMode.dark
                    ? Color(0xff1c213a)
                    : Color(0xff1e2b67),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('예', style: TextStyle(color: Colors.white))),
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
