import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/randomcode.dart';
import '../theme/color.dart';
import '../theme/text.dart';
import 'history.dart';
import 'history2.dart';

String roomCode = RandomRoomScreen.roomCode;
int currentQuestionIndex = 0;
String currentQuestion = '';

class questionPage extends StatefulWidget {
  questionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<questionPage> createState() => _questionPageState();
}

class _questionPageState extends State<questionPage> {
  final List<String> questionList = [
    "#01. 가장 기억에 남는 여행은 언제였나요?",
    "#02. 오늘 먹은 점심 메뉴는 무엇인가요?",
    "#03. 오늘 저녁 메뉴 추천해주세요!",
    "#04. 나의 인생 영화는 무엇인가요?",
    "#05. 가족과 함께 가고싶은 여행지가 있다면 어디인가요?",
    "#06. 가장 좋아하는 아이스크림은 무엇인가요?",
    "#07. 가장 좋아하는 음식은 무엇인가요?",
    "#08. 가장 기억에 남은 자신의 학창시절의 별명이 있다면 무엇인가요?",
    "#09. 코카콜라 vs 펩시",
    "#10. 추천해 주고 싶은 책은 무엇인가요?",
    "#11. 인상깊게 읽었던 책은 무엇이었나요?",
    "#12. 나는 민초파, 반민초파?",
    "#13. 가지고 싶은 초능력이 있다면 어떤 능력인가요?",
    "#14. 이것 하나만큼은 자신있다! 하는 것은?",
    "#15. 현재 가장 가지고 싶은 것은 무엇인가요?",
    "#16. 현재 자신이 가지고 있는 것중 제일 쓸데없는 것은?",
    "#17. 우리가족을 한~두 단어로 표현하자면?",
    "#18. 최애 과자는?",
    "#19. 지금 가장 먹고 싶은 것은?",
    "#20. 최근 빠진 드라마는?",
    "#21. 엄마가 해줬던 음식 중 가장 기억에 남는 음식은?",
    "#22. 가족과 함께 이루고 싶은 버킷리스트는?",
    "#23. 엄마에게 한 마디",
    "#24. 아빠에게 한 마디",
    "#25. 자녀/형제자매 에게 한 마디",
    "#26. 우리 가족을 떠올리면 생각나는 노래는?",
    "#27. 이제는 말할 수 있다! 그동안 말하지 못했던 것이 있다면?",
    "#28. 가족에게 가장 미웠던 순간",
    "#29. 가족에게가장 고마웠던 순간",
    "#30. 가장 돌아가고 싶은 순간이 있다면 언제인가?",
    "#31. 만약 전쟁이 나서 헤어지게 된다면, 어디서 다시 만날까요?",
    "#32. 엄마 칭찬해주기",
    "#33. 아빠 칭찬해주기",
    "#34. 엄마/아빠(아내/남편)에게 가장 듣고 싶었던 말",
    "#35. 되돌리고 싶은 일이 있다면 무엇인가?",
    "#36. 가족에게 가장 고마웠던 순간은?",
    "#37. 오늘 하루를 생각하며 가족에게 해주고 싶은 말은?",
    "#38. 언제 가족이 필요하다고 느꼈나요?",
    "#39. 가족에게 사랑받는다고 느낀 순간은 언제인가요?",
    "#40. 가족끼리 한달 간 오로지 쉴 수 있는 기회가 생긴다면 무엇을 하고 싶나요?",
    "#41. 우리가족을 ‘맛’으로 표현하자면?",
    "#42. 언제 제일 마음이 아팠나요?",
    "#43. 가족에게 사과하고 싶은 일이 있나요?",
    "#44. 올해 가족과 함께 이루고 싶은 목표는?",
    "#45. 우리집에서 내가 가장 좋아하는 공간은? ",
    "#46. 위급한 상황에 처한다면 가장 먼저 누구에게 전화를 할 것 같나요?",
    "#47. 매일 하는 것 중 가장 많은 시간을 할애하는 것은?",
    "#48. 하루아침에 100억이 생긴다면?",
    "#49. 방귀소리 우렁차기 vs 방귀냄새 지독하기",
    "#50. 요즘 자주 듣는 노래는?",
  ];

  TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentQuestion = questionList[currentQuestionIndex];
  }

  void submitAnswer(BuildContext context) async {
    String answer = answerController.text.trim();

    if (answer.isNotEmpty) {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      String? userNickname = await getNickname(userEmail);
      if (userEmail != null && userNickname != null) {
        FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomCode)
            .collection('$currentQuestion')
            .add({
          'question': currentQuestion,
          'useremail': userEmail,
          'answer': answer,
          'timestamp': DateTime.now(),
          'avatar': userNickname,
        }).then((_) async {
          await FirebaseFirestore.instance
              .collection('rooms')
              .doc(roomCode)
              .set({
            'subcollections': FieldValue.arrayUnion(['$currentQuestion'])
          }, SetOptions(merge: true));

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnswerPage(
                question: currentQuestion,
                answer: answer,
              ),
            ),
          );

          answerController.clear();
        }).catchError((error) {
          print('Failed to submit answer: $error');
        });
      }
    }
  }

  void goToNextQuestion() {
    currentQuestionIndex = (currentQuestionIndex + 1) % questionList.length;
    setState(() {
      currentQuestion = questionList[currentQuestionIndex];
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          '오늘의 질문',
          style: b20,
        ),
        backgroundColor: AppColor.background,
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset(
                '/Users/parkjiwon/Desktop/soda/oo/assets/logo.png',
                width: 80,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Container(
                width: 325,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.secondary)),
                child: Center(
                  child: Text(
                    '$currentQuestion',
                    style: b18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: SizedBox(
                height: 215,
                width: 325,
                child: TextField(
                  maxLines: 6,
                  maxLength: 30,
                  controller: answerController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: AppColor.texth), // 포커스된 상태의 테두리 색
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: AppColor.texth), // 비활성화된 상태의 테두리 색
                    ),
                    fillColor: AppColor.textbox,
                    filled: true,
                    hintText: '답변을 입력하세요',
                    hintStyle: l22.copyWith(color: AppColor.textboxs),
                  ),
                ),
              ),
            ),
            Text(
              '답변 등록시, 수정이 불가하니 신중하게!',
              style: b13.copyWith(color: Color(0xff9D9D9D)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 15),
              child: Container(
                width: 320,
                height: 50,
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () => submitAnswer(context),
                    child: Text('답변 등록하기', style: b20)),
              ),
            ),
            Container(
              width: 320,
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: goToNextQuestion,
                child: Text(
                  '다음 질문으로',
                  style: b20.copyWith(color: AppColor.texth),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerPage extends StatefulWidget {
  final String question;
  final String answer;

  AnswerPage({required this.question, required this.answer});

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  late Stream<QuerySnapshot> answersStream;
  late Stream<DocumentSnapshot> userStream;
  late Stream<DocumentSnapshot> roomStream;

  @override
  void initState() {
    super.initState();
    answersStream = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomCode)
        .collection('$currentQuestion')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getUserStream(String userId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomCode)
        .collection('$currentQuestion')
        .doc(userId)
        .snapshots();
  }

  Stream<DocumentSnapshot> getRoomStream() {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomCode)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    if (answersStream == null) {
      return Text('answerStream is null');
    }
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Text(
          '오늘의 질문',
          style: b20,
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 0),
        child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 23),
              child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xffB0CFA3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => historyPage2(),
                          ));
                    },
                    child: Text(
                      '히스토리',
                      style: b18.copyWith(color: AppColor.background),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 36),
              child: Container(
                height: 90,
                width: 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.secondary)),
                child: Center(
                  child: Text(
                    '${widget.question}',
                    style: l17,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: answersStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Text('아직 답변이 없습니다');
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      userStream = getUserStream(document.id);
                      roomStream = getRoomStream();
                      return StreamBuilder<DocumentSnapshot>(
                        stream: userStream,
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData ||
                              !userSnapshot.data!.exists) {
                            return CircularProgressIndicator();
                          }

                          var data = userSnapshot.data!.data()
                              as Map<String, dynamic>?;
                          if (data == null || !data.containsKey('avatar')) {
                            return Text('Error: No qna found');
                          }

                          var answer = document.get('answer');
                          var userNickname = document.get('avatar');
                          return ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Image.asset(
                                '/Users/parkjiwon/Desktop/soda/oo/assets/minipodogreen.png',
                                width: 48,
                              ),
                            ),
                            title: Text(
                              userNickname,
                              style: l15,
                            ),
                            subtitle: Container(
                              width: 252,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColor.textbox,
                                border: Border.all(color: AppColor.textboxs),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, top: 10),
                                child: Text(
                                  '$answer',
                                  style: b18,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> getNickname(String? userEmail) async {
  String nickname = '';
  if (userEmail == null) return '';
  DocumentSnapshot roomSnapshot =
      await FirebaseFirestore.instance.collection('rooms').doc(roomCode).get();
  Map<String, dynamic>? roomData = roomSnapshot.data() as Map<String, dynamic>?;
  List<dynamic>? qnaField = roomData?['qna'] as List<dynamic>?;
  if (qnaField != null) {
    for (var item in qnaField) {
      Map<String, dynamic> userMap = item as Map<String, dynamic>;

      nickname = userMap['nickname'];
    }
  }

  return nickname ?? '';
}
