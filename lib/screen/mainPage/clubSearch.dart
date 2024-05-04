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
import 'package:team_project/widgets/cardClub_widget.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';

class ClubSearch extends StatefulWidget {
  @override
  _ClubSearchState createState() => _ClubSearchState();
}

class _ClubSearchState extends State<ClubSearch>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ClubSearch> {
  late final ClubProvider clubProvider;
  late TabController _tabController;
  final TextEditingController departmentList = TextEditingController();

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
    if(clubState.clubStatus == ClubStatus.fetching){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if(clubState.clubStatus == ClubStatus.success && clubList.length == 0){
      return Center(
        child: Text('게시물이 존재하지 않습니다.'),
      );
    }
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
                  fontFamily: 'Dongle', fontSize: 35, color: Colors.white),
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
                                        color: _themeManager.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white
                                            : Color(0xFF2195F2),
                                        width: 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      SizedBox(height: 10),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _getClubList();
                          },
                          child: ListView.builder(
                              itemCount: clubList.length,
                              itemBuilder: (context, index) {
                                final clubModel = clubList[index];
                                // Check if the club type is '중앙동아리'
                                if (clubModel.clubType == '중앙동아리') {
                                  // If it's '중앙동아리', return the CardClubWidget
                                  return CardClubWidget(clubModel: clubModel);
                                } else {
                                  // If it's not '중앙동아리', return a SizedBox to indicate no clubs
                                  return SizedBox.shrink();
                                }
                              }),
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
                                      departmentList.text = value;
                                    });
                                  }),
                            ],
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                _getClubList();
                              },
                              child: ListView.builder(
                                  itemCount: clubList.length,
                                  itemBuilder: (context, index) {
                                    final clubModel = clubList[index];
                                    // Check if the club type is '중앙동아리'
                                    if (clubModel.clubType != '중앙동아리') {
                                      // If it's '중앙동아리', return the CardClubWidget
                                      if (_selectDepartment == null || clubModel.depart == _selectDepartment) {
                                        // If it matches, return the CardClubWidget
                                        return CardClubWidget(clubModel: clubModel);
                                      } else {
                                        // If it doesn't match, return a SizedBox to indicate no clubs
                                        return SizedBox.shrink();
                                      }
                                    } else {
                                      // If it's '중앙동아리', return a SizedBox to indicate no clubs
                                      return SizedBox.shrink();
                                    }
                                  }),
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateClubScreen(
                            onClubUploaded: () {},
                          )));
            }, //화면 연결시 동아리 만드는 파일에 연결하기
            child: Icon(Icons.add, color: Colors.black),
          ),

    );
  }
}
