import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../theme/text.dart';


class settingPage extends StatefulWidget {
  const settingPage({super.key});

  @override
  State<settingPage> createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          'coooode',
                          style: TextStyle(
                              color: AppColor.text,
                              fontSize: 25,
                              fontFamily: 'Kangwonedu'),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xffB0CFA3),
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
                    style: l13,
                  ),
                ),
              ]),
            ),
            Divider(
              color: Color(0xffD9D9D9),
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 38, top: 10, bottom: 10),
              child: TextButton(
                  child: Row(
                    children: [
                      Text(
                        '내 프로필 수정',
                        style: l22,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 160),
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
                                  padding:
                                      const EdgeInsets.only(top: 35, left: 30),
                                  child: Text(
                                    '개인 프로필 수정',
                                    style: b20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Image.asset(
                                            '/Users/parkjiwon/Desktop/soda/yiyung/assets/editindipro.png',
                                            width: 160,
                                          ),
                                        ),
                                        Text(
                                          '프로필 사진',
                                          style: l13.copyWith(
                                              color: Color(0xffA1A1A1)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 24),
                                      child: Container(
                                        height: 50,
                                        width: 250,
                                        child: TextFormField(
                                          key: const ValueKey(1),
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                value.length < 4) {
                                              return 'Please enter at least 4 characters.';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            userName = value!;
                                          },
                                          onChanged: (value) {
                                            userName = value;
                                          },
                                          maxLength: 10,
                                          decoration: const InputDecoration(
                                            fillColor: AppColor.textbox,
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColor.texth,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColor.texth,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            hintText: '사용할 닉네임을 입력하세요.',
                                            hintStyle: l15g,
                                            contentPadding: EdgeInsets.all(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 41),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: AppColor.primary,
                                          minimumSize: const Size(250, 38),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          '수정하기',
                                          style: b20,
                                        ),
                                      ),
                                    )
                                  ]),
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
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 38, top: 10, bottom: 10),
              child: TextButton(
                child: Row(
                  children: [
                    Text(
                      '가족 프로필 수정',
                      style: l22,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 143),
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
                                padding:
                                    const EdgeInsets.only(top: 35, left: 30),
                                child: Text(
                                  '가족 프로필 수정',
                                  style: b20,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Center(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Image.asset(
                                          '/Users/parkjiwon/Desktop/soda/yiyung/assets/editfampro.png',
                                          width: 330,
                                        ),
                                      ),
                                      Text(
                                        '배너에 등록할 사진을 첨부하세요',
                                        style: l13.copyWith(
                                            color: Color(0xffA1A1A1)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: Container(
                                      height: 50,
                                      width: 250,
                                      child: TextFormField(
                                        key: const ValueKey(1),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value.length < 4) {
                                            return 'Please enter at least 4 characters.';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          userName = value!;
                                        },
                                        onChanged: (value) {
                                          userName = value;
                                        },
                                        maxLength: 10,
                                        decoration: const InputDecoration(
                                          fillColor: AppColor.textbox,
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColor.texth,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColor.texth,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          hintText: '등록할 가족방 이름을 입력하세요.',
                                          hintStyle: l15g,
                                          contentPadding: EdgeInsets.all(5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: AppColor.primary,
                                        minimumSize: const Size(250, 38),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        '수정하기',
                                        style: b20,
                                      ),
                                    ),
                                  )
                                ]),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Divider(
              color: Color(0xffD9D9D9),
              indent: 15,
              endIndent: 15,
            ),
            Center(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 57),
                  child: Image.asset(
                    '/Users/parkjiwon/Desktop/soda/yiyung/assets/wink.png',
                    width: 105,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 72),
                  child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColor.textbox,
                            actions: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Center(
                                    child: Container(
                                        height: 80,
                                        child: Text(
                                          '로그아웃 하시겠습니까?',
                                          style: l22,
                                        ))),
                              ),
                              Divider(
                                color: AppColor.texth,
                                thickness: 1,
                              ),
                              Container(
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      child: Text(
                                        '예',
                                        style: l22.copyWith(fontSize: 20),
                                      ),
                                      onPressed: () {},
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
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        '로그아웃',
                        style: l17.copyWith(
                            fontSize: 16, decoration: TextDecoration.underline),
                      )),
                ),
                Text(
                  '버전 1.0',
                  style: l13,
                ),
              ],
            )),
          ]),
        ),
      ),
    );
  }
}
