import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'login/login.dart';
import 'theme/color.dart';
import 'theme/text.dart';

//도욱
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ko_KR');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: startPage());
  }
}

class startPage extends StatelessWidget {
  const startPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 145),
              child: Text(
                '앱이름',
                style: b27.copyWith(fontSize: 30),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 34),
              child: Text(
                '소개',
                style: b20,
              ),
            ),
            Image.asset('/Users/parkjiwon/Desktop/soda/yiyung/assets/podo.png',
                width: 256),
            Container(
              width: 320,
              height: 56,
              child: TextButton(
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 55, 0),
                      child: Icon(
                        Icons.mail,
                        color: AppColor.textbox,
                        size: 22,
                      ),
                    ),
                    Text('이메일로 로그인',
                        style: b20.copyWith(color: AppColor.textbox)),
                  ],
                ),
                style: TextButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    minimumSize: const Size(320, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const secondPage()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class secondPage extends StatelessWidget {
  const secondPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginSignupScreen());
  }
}
