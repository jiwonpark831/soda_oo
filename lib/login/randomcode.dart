import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../main2.dart';
import '../theme/color.dart';
import '../theme/text.dart';


class RandomRoomScreen extends StatefulWidget {
  final String userEmail;

  static String roomCode = '';
  static String profilePicture = '';
  static String profileField = '';
  
  RandomRoomScreen({required this.userEmail});

  @override
  State<RandomRoomScreen> createState() => _RandomRoomScreenState();
}

class _RandomRoomScreenState extends State<RandomRoomScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _roomCodeController = TextEditingController();

  String _textFieldValue = '';
  bool _isTextFieldEmpty = true;

  void _updateTextFieldValue(String value) {
    setState(() {
      _textFieldValue = value;
      _isTextFieldEmpty = value.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: AppColor.background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '우리 가족 방 입장하기',
                style: b20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 26),
                child: Container(
                  width: 272,
                  height: 46,
                  child: TextField(
                    onChanged: _updateTextFieldValue,
                    controller: _roomCodeController,
                    decoration: InputDecoration(
                      fillColor: AppColor.textbox,
                      filled: true,
                      focusColor: AppColor.textboxs,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.textboxs),
                          borderRadius: BorderRadius.circular(13)),
                      hintText: '가족코드를 입력하세요',
                      hintStyle: l15g,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Container(
                  width: 272,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: BorderSide(color: AppColor.textboxs)),
                    ),
                    onPressed: () {
                      String roomCode = _roomCodeController.text;
                      if (roomCode.isNotEmpty) {
                        joinRoom(roomCode);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyApp2()));
                      }
                    },
                    child: Text(
                      '입장',
                      style: l17.copyWith(
                          color: _isTextFieldEmpty
                              ? AppColor.texth
                              : AppColor.text),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 220),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String roomCode = generateRandomCode();
                        return AlertDialog(
                          backgroundColor: AppColor.textbox,
                          title: Text(
                            '가족방 코드가 생성되었습니다.',
                            style: l22.copyWith(fontSize: 20),
                          ),
                          content: Container(
                            height: 53,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Container(
                                      height: 32,
                                      width: 224,
                                      color: AppColor.textt,
                                      child: Center(
                                          child: Text(
                                        '가족코드: $roomCode',
                                        style: l17.copyWith(fontSize: 18),
                                      ))),
                                ),
                                Text(
                                  '코드를 복사하여 가족들에게 공유해보세요!',
                                  style: l15g.copyWith(fontSize: 11),
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: AppColor.primary),
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: roomCode)); //클립보드 복사
                                Navigator.of(context).pop();
                                createRoom(roomCode);
                                //joinRoom(roomCode);
                              },
                              child: Text(
                                '복사하기',
                                style: l13,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('가족 방이 없으신가요?',
                      style: l17.copyWith(
                          color: Color(0xff424242),
                          decoration: TextDecoration.underline)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String generateRandomCode() {
    Random random = Random();
    int randomNumber = random.nextInt(900000) + 100000;
    return randomNumber.toString();
  }

  void createRoom(String roomCode) {
    _firestore.collection('rooms').doc(roomCode).set({
      'createdAt': DateTime.now(),
      'users': [],
    });
  }

  void joinRoom(String roomCode) async {
    DocumentReference roomRef = _firestore.collection('rooms').doc(roomCode);
    DocumentSnapshot roomSnapshot = await roomRef.get();

    if (roomSnapshot.exists) {
      dynamic data = roomSnapshot.data();
      if (data != null && data.containsKey('users')) {
        List<dynamic> users = List.from(data['users']);
        users.add(widget.userEmail); // 사용자 ID를 추가해야 합니다.
        roomRef.update({'users': users});
      }
    }
  }
}

void main() {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      runApp(MaterialApp(
        home: RandomRoomScreen(userEmail: user.email!),
      ));
    }
  });
}
