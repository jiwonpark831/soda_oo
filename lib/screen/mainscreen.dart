import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oo/screen/calendar.dart';
import 'package:oo/screen/setting.dart';
import 'package:table_calendar/table_calendar.dart';

import '../login/randomcode.dart';
import '../theme/color.dart';
import '../theme/text.dart';
import 'album.dart';
import 'question.dart';

String roomCode = RandomRoomScreen.roomCode;
String fm = settingPage.fm;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(mainPage());
}

class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  Stream<String> getLastImage() {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(RandomRoomScreen.roomCode)
        .snapshots()
        .map((snapshot) {
      List<dynamic> images = snapshot.data()!['images'];
      if (images.isNotEmpty) {
        return images.last;
      } else {
        return '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1200,
        color: AppColor.primary,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 319,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 79),
                    child: Center(
                      child: Image.asset(
                        '/Users/parkjiwon/Desktop/soda/oo/assets/logo.png',
                        width: 108,
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                  ),
                  child: Container(
                    width: double.infinity,
                    color: AppColor.background,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 35),
                          child: Text(
                            settingPage.fm,
                            style: b27.copyWith(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 45),
                          child: Container(
                            width: 350,
                            height: 120,
                            child: Card(
                              elevation: 0,
                              color: AppColor.textbox,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xffD9D9D9),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 17, 0, 4),
                                        child: Text(
                                          '오늘의 질문',
                                          style: b20,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  questionPage(),
                                            ),
                                          );
                                        },
                                        child: Text('오늘의 질문이 도착했어요!',
                                            style: l17.copyWith(
                                                decoration:
                                                    TextDecoration.underline))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            width: 350,
                            height: 264,
                            child: Card(
                              elevation: 0,
                              color: AppColor.textbox,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xffD9D9D9),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: StreamBuilder<String>(
                                          stream: getLastImage(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data!.isNotEmpty) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          albumPage(),
                                                    ),
                                                  );
                                                },
                                                child: Image.network(
                                                  snapshot.data!,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            } else {
                                              return IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          albumPage(),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  size: 33,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '공유앨범',
                                          style: b20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            width: 350,
                            height: 479,
                            child: Card(
                              elevation: 0,
                              color: AppColor.textbox,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xffD9D9D9),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 17, 0, 4),
                                      child: Text(
                                        '캘린더',
                                        style: b20,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 350,
                                    height: 400,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                calendarPage(),
                                          ),
                                        );
                                      },
                                      icon: TableCalendar(
                                        locale: 'ko_KR',
                                        firstDay: DateTime(2010),
                                        lastDay: DateTime(2034),
                                        focusedDay: DateTime.now(),
                                        daysOfWeekHeight: 70,
                                        daysOfWeekStyle: DaysOfWeekStyle(
                                            weekdayStyle: b15,
                                            weekendStyle: b15.copyWith(
                                                color: AppColor.secondary)),
                                        headerStyle: HeaderStyle(
                                          titleTextStyle: b20,
                                          leftChevronVisible: false,
                                          rightChevronVisible: false,
                                          formatButtonVisible: false,
                                          titleCentered: true,
                                        ),
                                        calendarStyle: CalendarStyle(
                                          defaultTextStyle: b15,
                                          weekendTextStyle: b15.copyWith(
                                              color: AppColor.secondary),
                                          todayDecoration: BoxDecoration(
                                              color: AppColor.primary,
                                              shape: BoxShape.circle),
                                          todayTextStyle:
                                              TextStyle(color: AppColor.text),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  color: AppColor.background,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
