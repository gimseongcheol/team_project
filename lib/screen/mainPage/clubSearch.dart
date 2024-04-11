import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/models/club_model.dart';
import 'package:team_project/providers/club/club_provider.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/screen/clubPage/ClubMainScreen.dart';
import 'package:team_project/screen/modify/ModifyClubScreen.dart';
import 'package:team_project/screen/modify/createClubScreen.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';

class ClubSearch extends StatefulWidget {
  @override
  _ClubSearchState createState() => _ClubSearchState();
}

class _ClubSearchState extends State<ClubSearch> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ClubSearch>  {
  late final ClubProvider clubProvider;
  late TabController _tabController;
  @override
  bool get wantKeepAlive => true;

  final List<String> _departmentList = <String>[

    '프란치스코칼리지',
    '글로벌비즈니스대학',
    '신학대학',
    '바이오메디대학',
    '공과대학',
    '반도체대학',
    '소프트웨어융합대학',
    '의과대학',
    '간호대학',
    '약학대학',
    '사회과학대학',
    '사범대학',
    '음악공연예술대학',
    '디자인대학',
    '유스티아노자유대학',
  ];
  String? _selectDepartment;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
    clubProvider = context.read<ClubProvider>();
    _getClubList();
  }

  void _getClubList() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await clubProvider.getClubList();
      } on CustomException catch (e) {
        errorDialogWidget(context, e);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ClubState clubState = context.watch<ClubState>();
    List<ClubModel> clubList = clubState.clubList;
    final _themeManager = Provider.of<ThemeManager>(context);

    // ㄱ
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '동아리 검색',
          style: TextStyle(
              fontFamily: 'Dongle',
              fontSize: 35,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: _themeManager.themeMode == ThemeMode.dark
                ? Color(0xFF313338)
                : Colors.white, //나중에 위왼/위오른쪽 circular 10으로 셋팅할것
            child: TabBar(
              tabs: [
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    '중앙 동아리',
                    style: TextStyle(
                        fontSize: 20,
                        color: _themeManager.themeMode == ThemeMode.dark
                            ? Colors.white70
                            : Colors.black),
                  ),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    '과 동아리',
                    style: TextStyle(
                        fontSize: 20,
                        color: _themeManager.themeMode == ThemeMode.dark
                            ? Colors.white70
                            : Colors.black),
                  ),
                ),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              controller: _tabController,
            ),
          ),
          SizedBox(height: 4),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 8),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                              _themeManager.themeMode == ThemeMode.dark
                                  ? Colors.white24
                                  : Colors.white,
                              hintText: '검색하세요.',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                              suffixIcon:
                              Icon(Icons.search, color: Colors.black),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _themeManager.themeMode == ThemeMode.dark?
                                      Colors.white
                                      : Color(0xFF2195F2),
                                  width: 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Scrollbar(
                          controller: _scrollController,
                          thickness: 5,
                          child: ListView(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //여기서 넘어가는 함수 구현
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ClubMainScreen()));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: _themeManager.themeMode ==
                                            ThemeMode.dark
                                        ? BorderSide(
                                            color: Colors.white, width: 1)
                                        : BorderSide(
                                            color: Colors.black, width: 1),
                                  ),
                                  child: ListTile(
                                    tileColor: _themeManager.themeMode ==
                                            ThemeMode.dark
                                        ? Color(0xFF444444)
                                        : Colors.white,
                                    leading: Container(
                                      width: 40,
                                      height: 80,
                                      color: Colors.greenAccent,
                                    ),
                                    title: Text(
                                      '동아리1',
                                      style: TextStyle(
                                          color: _themeManager.themeMode ==
                                                  ThemeMode.dark
                                              ? Colors.white70
                                              : Colors.black),
                                    ),
                                    subtitle: Text(
                                      '동아리1에 대한 설명',
                                      style: TextStyle(
                                          color: _themeManager.themeMode ==
                                                  ThemeMode.dark
                                              ? Colors.white70
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side:
                                      _themeManager.themeMode == ThemeMode.dark
                                          ? BorderSide(
                                              color: Colors.white, width: 1)
                                          : BorderSide(
                                              color: Colors.black, width: 1),
                                ),
                                child: ListTile(
                                  tileColor:
                                      _themeManager.themeMode == ThemeMode.dark
                                          ? Color(0xFF444444)
                                          : Colors.white,
                                  leading: Container(
                                    width: 40,
                                    height: 80,
                                    color: Colors.green,
                                  ),
                                  title: Text(
                                    '동아리2',
                                    style: TextStyle(
                                        color: _themeManager.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white70
                                            : Colors.black),
                                  ),
                                  subtitle: Text(
                                    '동아리2에 대한 설명',
                                    style: TextStyle(
                                        color: _themeManager.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white70
                                            : Colors.black),
                                  ),
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side:
                                      _themeManager.themeMode == ThemeMode.dark
                                          ? BorderSide(
                                              color: Colors.white, width: 1)
                                          : BorderSide(
                                              color: Colors.black, width: 1),
                                ),
                                child: ListTile(
                                  tileColor:
                                      _themeManager.themeMode == ThemeMode.dark
                                          ? Color(0xFF444444)
                                          : Colors.white,
                                  leading: Container(
                                    width: 40,
                                    height: 80,
                                    color: Colors.lime,
                                  ),
                                  title: Text(
                                    '동아리3',
                                    style: TextStyle(
                                        color: _themeManager.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white70
                                            : Colors.black),
                                  ),
                                  subtitle: Text(
                                    '동아리3에 대한 설명',
                                    style: TextStyle(
                                        color: _themeManager.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white70
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  _themeManager.themeMode == ThemeMode.dark
                                      ? Colors.white24
                                      : Colors.white,
                              hintText: '검색하세요.',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                              suffixIcon:
                                  Icon(Icons.search, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '학부 찾기: ',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: 10),
                          DropdownButton(
                              //선택시 내부 색상 변경이 가능한지 확인하기
                              hint: const Text('학부 선택'),
                              value: _selectDepartment,
                              items: _departmentList.map((String item) {
                                return DropdownMenuItem<String>(
                                  child: Text('$item'),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (dynamic value) {
                                setState(() {
                                  _selectDepartment = value;
                                });
                              }),
                        ],
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: Scrollbar(
                          controller: _scrollController,
                          thickness: 5,
                          child: ListView(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ClubMainScreen()));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: _themeManager.themeMode ==
                                            ThemeMode.dark
                                        ? BorderSide(
                                            color: Colors.white, width: 1)
                                        : BorderSide(
                                            color: Colors.black, width: 1),
                                  ),
                                  child: ListTile(
                                    tileColor: _themeManager.themeMode ==
                                            ThemeMode.dark
                                        ? Color(0xFF444444)
                                        : Colors.white,
                                    leading: Container(
                                      width: 40,
                                      height: 80,
                                      color: Colors.cyan,
                                    ),
                                    title: Text(
                                      '동아리1',
                                      style: TextStyle(
                                          color: _themeManager.themeMode ==
                                                  ThemeMode.dark
                                              ? Colors.white70
                                              : Colors.black),
                                    ),
                                    subtitle: Text(
                                      '동아리1에 대한 설명',
                                      style: TextStyle(
                                          color: _themeManager.themeMode ==
                                                  ThemeMode.dark
                                              ? Colors.white70
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side:
                                      _themeManager.themeMode == ThemeMode.dark
                                          ? BorderSide(
                                              color: Colors.white, width: 1)
                                          : BorderSide(
                                              color: Colors.black, width: 1),
                                ),
                                child: ListTile(
                                  tileColor:
                                      _themeManager.themeMode == ThemeMode.dark
                                          ? Color(0xFF444444)
                                          : Colors.white,
                                  leading: Container(
                                    width: 40,
                                    height: 80,
                                    color: Colors.tealAccent,
                                  ),
                                  title: Text(
                                    '동아리2',
                                    style: TextStyle(
                                        color: _themeManager.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white70
                                            : Colors.black),
                                  ),
                                  subtitle: Text(
                                    '동아리2에 대한 설명',
                                    style: TextStyle(
                                        color: _themeManager.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white70
                                            : Colors.black),
                                  ),
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side:
                                      _themeManager.themeMode == ThemeMode.dark
                                          ? BorderSide(
                                              color: Colors.white, width: 1)
                                          : BorderSide(
                                              color: Colors.black, width: 1),
                                ),
                                child: ListTile(
                                  tileColor:
                                      _themeManager.themeMode == ThemeMode.dark
                                          ? Color(0xFF444444)
                                          : Colors.white,
                                  leading: Container(
                                    width: 40,
                                    height: 80,
                                    color: Colors.orange,
                                  ),
                                  title: Text(
                                    '동아리3',
                                    style: TextStyle(
                                        color: _themeManager.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white70
                                            : Colors.black),
                                  ),
                                  subtitle: Text(
                                    '동아리3에 대한 설명',
                                    style: TextStyle(
                                        color: _themeManager.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white70
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateClubScreen(onClubUploaded: () {  },)));
        }, //화면 연결시 동아리 만드는 파일에 연결하기
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
