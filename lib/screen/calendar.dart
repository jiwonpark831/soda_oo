// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../login/randomcode.dart';
import '../theme/color.dart';
import '../theme/text.dart';

String roomCode = RandomRoomScreen.roomCode;

class calendarPage extends StatefulWidget {
  @override
  _calendarPageState createState() => _calendarPageState();
}

class _calendarPageState extends State<calendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

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
                    border: Border.all(color: Color(0xffD9D9D9), width: 1)),
                height: 450,
                width: 362,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('rooms')
                        .doc(roomCode)
                        .collection('calendar')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      List<DateTime> eventDates = snapshot.data!.docs
                          .map((doc) {
                            final data = doc.data() as Map<String, dynamic>?;
                            if (data != null && data.containsKey("date")) {
                              return (data["date"] as Timestamp).toDate();
                            } else {
                              return null;
                            }
                          })
                          .where((date) => date != null)
                          .cast<DateTime>()
                          .toList();

                      return TableCalendar(
                        locale: 'ko_KR',
                        firstDay: DateTime.utc(2010, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        daysOfWeekHeight: 70,
                        daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: b15,
                            weekendStyle:
                                b15.copyWith(color: AppColor.secondary)),
                        headerStyle: HeaderStyle(
                            titleTextStyle: b20,
                            leftChevronIcon:
                                Icon(Icons.chevron_left, color: AppColor.text),
                            rightChevronIcon:
                                Icon(Icons.chevron_right, color: AppColor.text),
                            formatButtonVisible: false,
                            titleCentered: true),
                        calendarStyle: CalendarStyle(
                            defaultTextStyle: b15,
                            weekendTextStyle:
                                b15.copyWith(color: AppColor.secondary),
                            todayDecoration: BoxDecoration(
                                color: AppColor.primary,
                                shape: BoxShape.circle),
                            todayTextStyle: b15,
                            selectedDecoration: BoxDecoration(
                                color: Color(0xffF9E7C5),
                                shape: BoxShape.circle),
                            selectedTextStyle: b15),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventDetailPage(selectedDay: selectedDay),
                            ),
                          );
                        },
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, _) {
                            if (eventDates.any(
                                (eventDate) => isSameDay(eventDate, date))) {
                              return Positioned(
                                bottom: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffB0CFA3)),
                                  width: 7,
                                  height: 7,
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    '해당 날짜를 눌러 일정을 추가해 보세요!',
                    style: l17.copyWith(color: AppColor.textt),
                  ),
                ),
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

  EventDetailPage({Key? key, required this.selectedDay}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyyMMdd').format(widget.selectedDay);

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        centerTitle: false,
        title: Text(
          '등록된 일정',
          style: b20,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 56),
              child: Text(
                DateFormat('yyyy년 MM월 dd일').format(widget.selectedDay),
                style: b27,
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(roomCode)
                  .collection('calendar')
                  .doc(formattedDate)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                var userDocument = snapshot.data;

                if (userDocument?.exists == true) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Color(0xffF9E7C5),
                    child: Container(
                      width: 320,
                      height: 50,
                      child: ListTile(
                          title: Text(
                        userDocument?.get("event") != null
                            ? userDocument?.get("event")
                            : 'No event',
                        style: b20,
                      )),
                    ),
                  );
                } else {
                  return Center(
                      child: Text(
                    "아직 등록된 일정이 없어요",
                    style: b20.copyWith(color: AppColor.secondary),
                  ));
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 107, right: 30),
              child: Image.asset(
                '/Users/parkjiwon/Desktop/soda/oo/assets/startlogo.png',
                width: 310,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 60, right: 38),
                child: Container(
                  width: 78,
                  height: 78,
                  child: FloatingActionButton(
                      shape: CircleBorder(),
                      backgroundColor: AppColor.primary,
                      elevation: 2,
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: AppColor.textbox,
                          context: context,
                          builder: (context) {
                            return Column(
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
                                        controller: _controller,
                                        style: b23,
                                        decoration: InputDecoration(
                                          fillColor: Color(0xffF3F3F3),
                                          filled: true,
                                          focusColor: AppColor.texth,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: AppColor.texth,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColor.texth,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          hintText: '제목',
                                          hintStyle: b23.copyWith(
                                              color: AppColor.texth),
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 35, top: 25),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          size: 30,
                                          color: AppColor.fourth,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 18),
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
                                            top: 40, bottom: 38),
                                        child: Image.asset(
                                          '/Users/parkjiwon/Desktop/soda/yiyung/assets/wink.png',
                                          width: 60,
                                        ),
                                      ),
                                      Container(
                                        width: 320,
                                        height: 55,
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
                                            FirebaseFirestore.instance
                                                .collection('rooms')
                                                .doc(roomCode)
                                                .collection('calendar')
                                                .doc(formattedDate)
                                                .set({
                                              'date': widget.selectedDay,
                                              'event': _controller.text,
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ))
                                ]);
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Icon(
                              Icons.add,
                              size: 29,
                              color: AppColor.text,
                            ),
                          ),
                          Text(
                            '일정추가',
                            style: b15,
                          )
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
