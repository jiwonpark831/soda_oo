import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../theme/color.dart';
import '../theme/text.dart';

class calendarPage extends StatefulWidget {
  @override
  _calendarPageState createState() => _calendarPageState();
}

class Event {
  final String title;

  const Event(this.title);
}

class _calendarPageState extends State<calendarPage> {
  late ValueNotifier<List<String>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  late Map<DateTime, List<String>> _events;

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier<List<String>>([]);
    _events = {};
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents.value = _events[_selectedDay] ?? [];
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EventDetailPage(_selectedDay, _selectedEvents.value),
        ),
      );
    }
  }

  void _addEvent() {
    if (_selectedDay != null) {
      if (_events[_selectedDay] != null) {
        _events[_selectedDay]!.add(
          'Event ${_events[_selectedDay]!.length + 1}',
        );
      } else {
        _events[_selectedDay] = ['Event 1'];
      }

      _selectedEvents.value = _events[_selectedDay]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            '캘린더',
            style: b20,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                '우리가족 일정 한눈에 보기',
                style: l22,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColor.textbox,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xffF9E7C5), width: 1)),
                height: 450,
                width: 362,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TableCalendar(
                    locale: 'ko_KR',
                    firstDay: DateTime(2010),
                    lastDay: DateTime(2034),
                    focusedDay: _focusedDay,
                    headerStyle: HeaderStyle(
                        formatButtonVisible: false, titleCentered: true),
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    eventLoader: (day) {
                      return _events[day] ?? [];
                    },
                    onDaySelected: _onDaySelected,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                          color: AppColor.primary, shape: BoxShape.circle),
                      todayTextStyle: TextStyle(color: AppColor.text),
                      selectedDecoration: BoxDecoration(
                          color: Color(0xffF9E7C5), shape: BoxShape.circle),
                      selectedTextStyle: TextStyle(color: AppColor.text),
                      markerDecoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Text('해당 날짜를 눌러 일정을 추가해 보세요!', style: l17,),
               /* Padding(
                  padding: const EdgeInsets.only(left: 44, top: 17),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '오늘 날짜',
                        style: b13,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 44, top: 6),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '일정있는 날짜',
                        style: b13,
                      )),
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EventDetailPage extends StatefulWidget {
  final DateTime selectedDay;
  final List<String> events;

  EventDetailPage(this.selectedDay, this.events);

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  List<String> events = [];

  @override
  void initState() {
    super.initState();
    _fetchEventsFromFirebase();
  }

  void _fetchEventsFromFirebase() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc('355389')
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('calendar')) {
          var calendarData = data['calendar'] as List<dynamic>;
          for (var item in calendarData) {
            var itemSelectedDayTimestamp = item['selectedDay'] as Timestamp;
            var itemSelectedDay = itemSelectedDayTimestamp.toDate();
            if (itemSelectedDay.isAtSameMomentAs(widget.selectedDay)) {
              setState(() {
                events = List<String>.from(item['events'] ?? []);
              });
              break;
            }
          }
        }
      }
    } catch (e) {
      print('오류: $e');
    }
  }

  void _addEvent(String event) {
    setState(() {
      events.add(event);
    });
    _updateFirebaseEvents(events);
  }

  void _updateFirebaseEvents(List<String> events) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc('355389')
          .update({
        'calendar': FieldValue.arrayUnion([
          {
            'events': events,
            'selectedDay': Timestamp.fromDate(widget.selectedDay)
          }
        ])
      });
    } catch (e) {
      print('Firebase 업데이트 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Text(''),
      ),
      body: Column(
        children: [
          Text(
            DateFormat('yyyy년 MM월 dd일').format(widget.selectedDay),
            style: b27,
          ),
          Container(
            height: 25,
          ),
          ...events
              .map((event) => Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Card(
                      color: Color(0xffF9E7C5),
                      child: Container(
                        width: 320,
                        height: 45,
                        child: ListTile(
                          title: Text(
                            event,
                            style: b20.copyWith(color: AppColor.textboxs),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Container(
                width: 320,
                height: 55,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColor.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: AppColor.textbox,
                      context: context,
                      builder: (context) {
                        String? newEvent;
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 42, top: 39, bottom: 16),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '새로운 일정을 등록하세요',
                                      style: b23,
                                    )),
                              ),
                              Center(
                                child: Container(
                                  width: 320,
                                  height: 67,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      fillColor: Color(0xffF3F3F3),
                                      filled: true,
                                      focusColor: Color(0xffF3F3F3),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xffF3F3F3),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      hintText: '제목',
                                      hintStyle:
                                          b23.copyWith(color: AppColor.texth),
                                    ),
                                    textAlign: TextAlign.left,
                                    onChanged: (value) {
                                      newEvent = value;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 35, top: 25),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 30,
                                      color: AppColor.fourth,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18),
                                      child: Text(
                                        DateFormat('yyyy년 MM월 dd일')
                                            .format(widget.selectedDay),
                                        style: l22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 41, bottom: 35),
                                      child: Image.asset(
                                        '/Users/parkjiwon/Desktop/soda/yiyung/assets/wink.png',
                                        width: 56,
                                      ),
                                    ),
                                    Container(
                                      width: 311,
                                      height: 50,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: AppColor.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          '일정 등록하기',
                                          style: b20,
                                        ),
                                        onPressed: () {
                                          if (newEvent != null &&
                                              newEvent!.isNotEmpty) {
                                            _addEvent(newEvent!);
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    '+ 새로운 일정 추가',
                    style: b20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void addCardToFirebase(List<String> events, DateTime selectedDay) async {
  try {
    FirebaseFirestore.instance.collection('rooms').doc('355389').update({
      'calendar': FieldValue.arrayUnion([
        {'events': events, 'selectedDay': selectedDay}
      ])
    });
  } catch (e) {
    print('오류: $e');
  }
}
