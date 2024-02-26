// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import '../theme/color.dart';
import '../theme/text.dart';
import 'randomcode.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authentication = FirebaseAuth.instance;
  bool isSignupScreen = false;
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      //onSaved랑 세트
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.background,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              //MediaQuery.of(context).size.height-180;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                padding: const EdgeInsets.all(20.0),
                                height: isSignupScreen ? 450 : 305,
                                width: 320,
                                decoration: BoxDecoration(
                                  color: AppColor.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isSignupScreen = false;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Text(
                                                  '로그인',
                                                  style: b20.copyWith(
                                                    color: !isSignupScreen
                                                        ? AppColor.text
                                                        : AppColor.text,
                                                  ),
                                                ),
                                                if (!isSignupScreen)
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 3),
                                                    height: 1,
                                                    width: 68,
                                                    color: AppColor.text,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isSignupScreen = true;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Text(
                                                  '회원가입',
                                                  style: b20.copyWith(
                                                    color: !isSignupScreen
                                                        ? AppColor.text
                                                        : AppColor.text,
                                                  ),
                                                ),
                                                if (isSignupScreen)
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 3),
                                                    height: 1,
                                                    width: 74,
                                                    color: AppColor.text,
                                                  ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      if (isSignupScreen)
                                        Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            child: Form(
                                              key: _formKey,
                                              child: Column(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 0, 0, 4),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          '*아이디',
                                                          style: b15,
                                                        )),
                                                  ),
                                                  Container(
                                                    height: 40,
                                                    width: 270,
                                                    child: TextFormField(
                                                      key: const ValueKey(1),
                                                      validator: (value) {
                                                        if (value!.isEmpty ||
                                                            value.length < 1) {
                                                          return '1글자 이상의 아이디를 입력하세요';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        userName = value!;
                                                      },
                                                      onChanged: (value) {
                                                        userName = value;
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        fillColor:
                                                            AppColor.textbox,
                                                        filled: true,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        hintText: '아이디를 입력하세요.',
                                                        hintStyle: b15g,
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                      ),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 8, 0, 4),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          '*이메일',
                                                          style: b15,
                                                        )),
                                                  ),
                                                  Container(
                                                    height: 40,
                                                    width: 270,
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      key: const ValueKey(2),
                                                      validator: (value) {
                                                        if (value!.isEmpty ||
                                                            !value.contains(
                                                                '@')) {
                                                          return '유효한 이메일을 입력하세요';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        userEmail = value!;
                                                      },
                                                      onChanged: (value) {
                                                        userEmail = value;
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        fillColor:
                                                            AppColor.textbox,
                                                        filled: true,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        hintText: '이메일을 입력하세요.',
                                                        hintStyle: b15g,
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                      ),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 8, 0, 4),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          '*비밀번호',
                                                          style: b15,
                                                        )),
                                                  ),
                                                  Container(
                                                    height: 40,
                                                    width: 270,
                                                    child: TextFormField(
                                                      obscureText: true,
                                                      key: const ValueKey(3),
                                                      validator: (value) {
                                                        if (value!.isEmpty ||
                                                            value.length < 1) {
                                                          return '비밀번호가 너무 짧아요';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        userPassword = value!;
                                                      },
                                                      onChanged: (value) {
                                                        userPassword = value;
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        fillColor:
                                                            AppColor.textbox,
                                                        filled: true,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        hintText:
                                                            '6자 이상의 비밀번호를 입력하세요.',
                                                        hintStyle: b15g,
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                      ),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 8, 0, 4),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          '*비밀번호 확인',
                                                          style: b15,
                                                        )),
                                                  ),
                                                  Container(
                                                    height: 40,
                                                    width: 270,
                                                    child: TextFormField(
                                                      obscureText: true,
                                                      key: const ValueKey(3),
                                                      validator: (value) {
                                                        if (value!.isEmpty ||
                                                            value.length < 1) {
                                                          return '비밀번호가 너무 짧아요';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        userPassword = value!;
                                                      },
                                                      onChanged: (value) {
                                                        userPassword = value;
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        fillColor:
                                                            AppColor.textbox,
                                                        filled: true,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        hintText:
                                                            '비밀번호를 다시 입력하세요.',
                                                        hintStyle: b15g,
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 25),
                                                    child: TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xffB3C89D),
                                                          minimumSize:
                                                              const Size(
                                                                  270, 40),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          if (isSignupScreen) {
                                                            _tryValidation();

                                                            try {
                                                              final newUser = await _authentication
                                                                  .createUserWithEmailAndPassword(
                                                                      email:
                                                                          userEmail,
                                                                      password:
                                                                          userPassword);

                                                              if (newUser
                                                                      .user !=
                                                                  null) {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          RandomRoomScreen(
                                                                              userEmail: userEmail)),
                                                                );
                                                              }
                                                            } catch (e) {
                                                              print(e);
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                    '필수정보를 입력하세요',
                                                                    style: l15,
                                                                  ),
                                                                  backgroundColor:
                                                                      AppColor
                                                                          .textbox,
                                                                ),
                                                              );
                                                            }
                                                          }
                                                        },
                                                        child: const Text(
                                                          '회원가입',
                                                          style: b20,
                                                        )),
                                                  )
                                                ],
                                              ),
                                            )),
                                      if (!isSignupScreen)
                                        Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            child: Form(
                                                key: _formKey,
                                                child: Column(
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 0, 0, 4),
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '*이메일',
                                                            style: b15,
                                                          )),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      width: 270,
                                                      child: TextFormField(
                                                        key: const ValueKey(4),
                                                        validator: (value) {
                                                          if (value!.isEmpty ||
                                                              value.length <
                                                                  1) {
                                                            return '유효한 이메일을 입력하세요';
                                                          }
                                                          return null;
                                                        },
                                                        onSaved: (value) {
                                                          userEmail = value!;
                                                        },
                                                        onChanged: (value) {
                                                          userEmail = value;
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                          fillColor:
                                                              AppColor.textbox,
                                                          filled: true,
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          hintText:
                                                              '이메일 입력하세요.',
                                                          hintStyle: b15g,
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10),
                                                        ),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 8, 0, 4),
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '*비밀번호',
                                                            style: b15,
                                                          )),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      width: 270,
                                                      child: TextFormField(
                                                        key: const ValueKey(
                                                            5), //State를 엉키게 하는 것을 막아줌
                                                        validator: (value) {
                                                          if (value!.isEmpty ||
                                                              value.length <
                                                                  1) {
                                                            return '유효한 비밀번호를 입력하세요';
                                                          }
                                                          return null;
                                                        },
                                                        onSaved: (value) {
                                                          userPassword = value!;
                                                        },

                                                        onChanged: (value) {
                                                          userPassword = value;
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                          fillColor:
                                                              AppColor.textbox,
                                                          filled: true,
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          hintText:
                                                              '비밀번호를 입력하세요.',
                                                          hintStyle: b15g,
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 25),
                                                      child: TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xffB3C89D),
                                                          minimumSize:
                                                              const Size(
                                                                  270, 40),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          if (!isSignupScreen) {
                                                            _tryValidation();

                                                            try {
                                                              final newUser =
                                                                  await _authentication
                                                                      .signInWithEmailAndPassword(
                                                                email:
                                                                    userEmail,
                                                                password:
                                                                    userPassword,
                                                              );
                                                              if (newUser
                                                                      .user !=
                                                                  null) {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          RandomRoomScreen(
                                                                              userEmail: userEmail)),
                                                                );
                                                              }
                                                            } catch (e) {
                                                              print(e);
                                                            }
                                                          }
                                                        },
                                                        child: const Text(
                                                          '로그인',
                                                          style: b20,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ))),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        Center(
                          child: Container(
                              width: 89,
                              padding:
                                  const EdgeInsets.only(top: 600, bottom: 147),
                              child: Image.asset(
                                  '/Users/parkjiwon/Desktop/soda/yiyung/assets/logo.png')),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
