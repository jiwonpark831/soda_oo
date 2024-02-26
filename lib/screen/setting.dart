import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oo/main.dart';
import 'package:oo/main2.dart';
import '../login/randomcode.dart';
import '../theme/color.dart';
import '../theme/text.dart';

String roomCode = RandomRoomScreen.roomCode;

class settingPage extends StatefulWidget {
  const settingPage({super.key});
  static String fm = '';

  @override
  State<settingPage> createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _nicknameController2 = TextEditingController();

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .get()
            .then((doc) {
          if (doc.exists) {
            setState(() {
              _nicknameController.text = doc['nickname'] ?? '';
            });
          } else {
            FirebaseFirestore.instance.collection('users').doc(user.email).set({
              'profileImage': '',
              'nickname': '',
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            '설정',
            style: b20,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColor.background,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: AppColor.background,
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 15, left: 38),
                  child: Text(
                    '우리 가족방 코드',
                    style: l22,
                  )),
              Center(
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 27),
                      child: Container(
                        width: 240,
                        height: 45,
                        child: TextButton(
                          child: Text(
                            roomCode,
                            style: b23,
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: Color(0xffF9E7C5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          onPressed: () {},
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 30),
                    child: Text(
                      '코드를 복사해 가족에게 공유하세요!',
                      style: l15,
                    ),
                  ),
                ]),
              ),
              Divider(
                color: Color(0xffD9D9D9),
                indent: 25,
                endIndent: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 38, top: 10, bottom: 10),
                child: TextButton(
                    child: Row(
                      children: [
                        Text(
                          '닉네임 설정',
                          style: l22,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 190),
                          child: Icon(
                            Icons.chevron_right,
                            size: 25,
                            color: AppColor.text,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                  color: AppColor.textbox),
                              height: 800,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 35, left: 30),
                                    child: Text(
                                      '닉네임 설정',
                                      style: l22,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Center(
                                      child: Column(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30),
                                          child: Image.asset(
                                            '/Users/parkjiwon/Desktop/soda/oo/assets/logo.png',
                                            width: 100,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 72),
                                          child: Container(
                                            height: 60,
                                            width: 250,
                                            child: TextField(
                                              controller: _nicknameController,
                                              decoration: InputDecoration(
                                                hintText: '설정할 닉네임을 입력하세요',
                                                hintStyle: l15g,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: AppColor.textt),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: AppColor.textt),
                                                ),
                                              ),
                                              maxLength: 10,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 24),
                                          child: TextButton(
                                            onPressed: () async {
                                              final user = FirebaseAuth
                                                  .instance.currentUser;
                                              final email = user?.email;

                                              if (email != null) {
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(email)
                                                    .update({
                                                  'nickname':
                                                      _nicknameController.text
                                                });

                                                setState(() {
                                                  _nicknameController.text =
                                                      _nicknameController.text;
                                                });

                                                await FirebaseFirestore.instance
                                                    .collection('rooms')
                                                    .doc(roomCode)
                                                    .update({
                                                  'nicknames':
                                                      FieldValue.arrayUnion([
                                                    _nicknameController.text
                                                  ]),
                                                  'qna': FieldValue.arrayUnion([
                                                    {
                                                      'userEmail': email,
                                                      'nickname':
                                                          _nicknameController
                                                              .text
                                                    }
                                                  ])
                                                });
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: AppColor.primary,
                                              minimumSize: const Size(250, 38),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: Text(
                                              '설정하기',
                                              style: b20,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
              Divider(
                color: Color(0xffD9D9D9),
                indent: 25,
                endIndent: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 38, top: 10, bottom: 10),
                child: TextButton(
                    child: Row(
                      children: [
                        Text(
                          '가족방 이름 설정',
                          style: l22,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 146),
                          child: Icon(
                            Icons.chevron_right,
                            size: 25,
                            color: AppColor.text,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                  color: AppColor.textbox),
                              height: 800,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 35, left: 30),
                                    child: Text(
                                      '가족방 이름 설정',
                                      style: l22,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1),
                                    child: Center(
                                      child: Column(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 25),
                                          child: Image.asset(
                                            '/Users/parkjiwon/Desktop/soda/oo/assets/familylogo.png',
                                            width: 274,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50),
                                          child: Container(
                                            height: 60,
                                            width: 250,
                                            child: TextField(
                                              controller: _nicknameController2,
                                              decoration: InputDecoration(
                                                hintText: '설정할 가족방 이름을 입력하세요',
                                                hintStyle: l15g,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: AppColor.textt),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: AppColor.textt),
                                                ),
                                              ),
                                              maxLength: 10,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 24),
                                          child: TextButton(
                                            onPressed: () async {
                                              settingPage.fm =
                                                  _nicknameController2.text;
                                              final user = FirebaseAuth
                                                  .instance.currentUser;
                                              final email = user?.email;

                                              if (email != null) {
                                                setState(() {
                                                  _nicknameController2.text =
                                                      _nicknameController2.text;

                                                  settingPage.fm =
                                                      _nicknameController2.text;
                                                });

                                                await FirebaseFirestore.instance
                                                    .collection('rooms')
                                                    .doc(roomCode)
                                                    .update({
                                                  'familyname':
                                                      _nicknameController2.text,
                                                });
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: AppColor.primary,
                                              minimumSize: const Size(250, 38),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: Text(
                                              '설정하기',
                                              style: b20,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
              Divider(
                color: Color(0xffD9D9D9),
                indent: 25,
                endIndent: 25,
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 57),
                      child: Image.asset(
                        '/Users/parkjiwon/Desktop/soda/oo/assets/wink.png',
                        width: 105,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 65),
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppColor.textbox,
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Center(
                                        child: Container(
                                            height: 80,
                                            child: Text(
                                              '로그아웃 하시겠습니까?',
                                              style: l22,
                                            ))),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  startPage()),
                                        );
                                      },
                                      child: Text(
                                        '예',
                                        style: l22.copyWith(fontSize: 20),
                                      ),
                                    ),
                                    TextButton(
                                      child: Text(
                                        '아니요',
                                        style: l22.copyWith(fontSize: 20),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              '로그아웃',
                              style: l17.copyWith(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ))),
                    Text(
                      '버전 1.0',
                      style: l13,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
