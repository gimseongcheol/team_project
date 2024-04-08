import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:team_project/screen/clubPage/Event.dart';
import 'package:provider/provider.dart';
import 'package:team_project/theme/theme_manager.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  Future<void> _confirmDeleteEvent(BuildContext context, int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final _themeManager = Provider.of<ThemeManager>(context);
        return AlertDialog(
          backgroundColor: _themeManager.themeMode == ThemeMode.dark
              ? Colors.white
              : Color(0xFF212121),
          title: Text(
            "일정 삭제",
            style: TextStyle(
              color: _themeManager.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black12,
            ),
          ),
          content: Text("일정을 삭제하시겠습니까?"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedEvents.value.removeAt(index);
                  if (_selectedEvents.value.isEmpty) {
                    events.remove(_selectedDay);
                  }
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff1e2b67),
              ),
              child: Text("삭제", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text("취소", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addEvent(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
          Provider
              .of<ThemeManager>(context)
              .themeMode == ThemeMode.dark
              ? Color(0xFF212121)
              : Colors.white,
          title: Text("일정 추가",
              style: TextStyle(
                  color: Provider
                      .of<ThemeManager>(context)
                      .themeMode ==
                      ThemeMode.dark
                      ? Colors.white
                      : Colors.black)),
          content: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(4),
              child: TextField(
                controller: _eventController,
                style: TextStyle(
                    color: Provider
                        .of<ThemeManager>(context)
                        .themeMode ==
                        ThemeMode.dark
                        ? Colors.white
                        : Colors.black),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2195F2)),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final eventName = _eventController.text ?? "";
                events.update(
                    _selectedDay!, (value) => [...value, Event(eventName)],
                    ifAbsent: () => [Event(eventName)]);
                Navigator.of(context).pop();
                _selectedEvents.value = _getEventsForDay(_selectedDay!);
                // Update circle color when adding event
                if (events[_selectedDay!]!.length == 1) {
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff1e2b67),
              ),
              child: Text("추가", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text(
                "취소",
                style: TextStyle(
                  //이거 보고 수정하자 굳이 이렇게 쓸 필요가 없는데 이러면
                    color: Provider
                        .of<ThemeManager>(context)
                        .themeMode ==
                        ThemeMode.dark
                        ? Colors.black
                        : Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            locale: 'en_US',
            firstDay: DateTime.utc(2010, 3, 14),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            availableCalendarFormats: {
              CalendarFormat.month: '1주', //3번
              CalendarFormat.twoWeeks: '1달', //1번
              CalendarFormat.week: '2주', //2번
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            rowHeight: 45,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: _themeManager.themeMode == ThemeMode.dark
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: Colors.black),
            ),
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${value[index]}'),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor:
                                        _themeManager.themeMode ==
                                            ThemeMode.dark
                                            ? Color(0xFF212121)
                                            : Colors.white,
                                        title: Text("일정 수정",
                                            style: TextStyle(
                                                color:
                                                _themeManager.themeMode ==
                                                    ThemeMode.dark
                                                    ? Colors.white
                                                    : Colors.black)),
                                        content: SingleChildScrollView(
                                          // SingleChildScrollView로 content 감싸기
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: TextField(
                                              controller: _eventController,
                                              style: TextStyle(
                                                  color:
                                                  _themeManager.themeMode ==
                                                      ThemeMode.dark
                                                      ? Colors.white
                                                      : Colors.black),
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(
                                                          0xFF2195F2)), // 클릭 시 테두리 색상 설정
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _selectedEvents.value =
                                                  _getEventsForDay(
                                                      _selectedDay!);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xff1e2b67),
                                            ),
                                            child: Text("수정",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors
                                                  .white, // 라이트 모드일 때는 흰색, 다크 모드일 때는 검은색으로 설정
                                            ),
                                            child: Text("취소",
                                                style: TextStyle(
                                                    color: _themeManager
                                                        .themeMode ==
                                                        ThemeMode.dark
                                                        ? Colors.white
                                                        : Colors
                                                        .black)), // 라이트 모드일 때는 검은색, 다크 모드일 때는 흰색 텍스트 색상
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _confirmDeleteEvent(context, index);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("나 실행중이다.");
          _addEvent(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
