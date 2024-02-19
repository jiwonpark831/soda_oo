import 'package:flutter/material.dart';

import 'screen/album.dart';
import 'screen/calendar.dart';
import 'screen/history.dart';
import 'screen/mainscreen.dart';
import 'screen/setting.dart';
import 'theme/color.dart';
import 'theme/text.dart';

class MyApp2 extends StatefulWidget {
  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    historyPage(),
    //historyPage(questions: [Question(questionText: 'test', answerText: 'test')],),
    const albumPage(),
    const mainPage(),
    calendarPage(),
    const settingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColor.primary,
          selectedItemColor: AppColor.text,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 28),
                  child: Icon(
                    Icons.contact_support_outlined,
                    size: 30,
                    color: AppColor.secondary,
                  ),
                ),
                label: '히스토리'),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 28),
                child: Icon(
                  Icons.perm_media_outlined,
                  size: 30,
                  color: AppColor.secondary,
                ),
              ),
              label: '앨범',
            ),
            BottomNavigationBarItem(
                icon: Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: Image.asset(
                        '/Users/parkjiwon/Desktop/soda/sodapj/assets/oo.png',
                        width: 28)),
                label: '홈'),
            const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 28),
                  child: Icon(
                    Icons.date_range_outlined,
                    size: 30,
                    color: AppColor.secondary,
                  ),
                ),
                label: '캘린더'),
            const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 28),
                  child: Icon(
                    Icons.settings_outlined,
                    size: 30,
                    color: AppColor.secondary,
                  ),
                ),
                label: '설정'),
          ],
          selectedIconTheme: const IconThemeData(color: AppColor.text),
          selectedLabelStyle: b13,
          unselectedLabelStyle: b13.copyWith(color: AppColor.secondary),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
