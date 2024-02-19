import 'package:flutter/material.dart';

import '../login/randomcode.dart';
import '../theme/color.dart';
import '../theme/text.dart';
import 'album.dart';
import 'question.dart';

void main() {
  runApp(const mainPage());
}

class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1078,
        color: AppColor.primary,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(children: [
                Container(
                  height: 319,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 79),
                    child: Center(
                      child: Image.asset(
                        '/Users/parkjiwon/Desktop/soda/sodapj/assets/logo.png',
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
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 103),
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
                                            20, 17, 0, 0),
                                        child: Text('오늘의 질문', style: b20),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      questionPage(
                                                        roomCode:
                                                            RandomRoomScreen
                                                                .roomCode,
                                                      )));
                                        },
                                        child: Text(
                                          '$currentQuestion',
                                          style: l15,
                                        ))
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
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 17, 0, 15),
                                        child: Text('공유앨범', style: b20),
                                      ),
                                    ),
                                    Container(
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const albumPage()));
                                          },
                                          icon: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 50),
                                            child: Icon(
                                              Icons.add,
                                              size: 33,
                                              color: AppColor.texth,
                                            ),
                                          )),
                                    )
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
                                child: Column(
                                  children: [
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
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 0, 0, 0),
                                        child: Text(
                                          '우리가족 일정 한눈에 보기',
                                          style: l13.copyWith(
                                              color: Color(0xff403D3D)),
                                        ),
                                      ),
                                    ),
                                    Text('//캘린더 들어갈 자리'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                    )),
              ]),
            )));
  }
}
