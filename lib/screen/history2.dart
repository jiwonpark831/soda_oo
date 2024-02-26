import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../login/randomcode.dart';
import '../main2.dart';
import '../theme/color.dart';
import '../theme/text.dart';

String roomCode = RandomRoomScreen.roomCode;

class historyPage2 extends StatefulWidget {
  @override
  _historyPage2State createState() => _historyPage2State();
}

class _historyPage2State extends State<historyPage2> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> collectionNames = [];

  @override
  void initState() {
    super.initState();
    getCollectionNames();
  }

  getCollectionNames() async {
    DocumentSnapshot doc =
        await _firestore.collection('rooms').doc(roomCode).get();
    if (doc.data() != null && doc.get('subcollections') != null) {
      collectionNames = List<String>.from(doc.get('subcollections'));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: AppColor.text,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp2()),
            );
          },
        ),
        title: Text('히스토리', style: b20),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: collectionNames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 320,
              height: 60,
              /*decoration: BoxDecoration(
                  border: Border.all(color: AppColor.secondary),
                  borderRadius: BorderRadius.circular(10)),*/
              child: ListTile(
                title: Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 15),
                    child: Text(
                      collectionNames[index],
                      style: l17,
                    )),
                subtitle: Divider(
                  indent: 10,
                  endIndent: 10,
                  color: AppColor.textt,
                  thickness: 1,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CollectionDetails(collectionNames[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class CollectionDetails extends StatefulWidget {
  final String collectionName;

  CollectionDetails(this.collectionName);

  @override
  _CollectionDetailsState createState() => _CollectionDetailsState();
}

class _CollectionDetailsState extends State<CollectionDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> documents = [];

  @override
  void initState() {
    super.initState();
    getDocuments();
  }

  getDocuments() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('rooms')
        .doc(roomCode)
        .collection(widget.collectionName)
        .get();
    documents = querySnapshot.docs;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
          centerTitle: false,
          backgroundColor: AppColor.background,
          title: Text(
            '히스토리',
            style: b20,
          )),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 25),
              child: Container(
                  width: 350,
                  height: 70,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColor.secondary),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      '${widget.collectionName}',
                      style: l17,
                    ),
                  ))),
          ListView.builder(
            shrinkWrap: true,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Image.asset(
                    '/Users/parkjiwon/Desktop/soda/oo/assets/minipodogreen.png',
                    width: 48,
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    '${documents[index].get('avatar')}',
                    style: l15,
                  ),
                ),
                subtitle: Container(
                    width: 252,
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColor.textbox,
                        border: Border.all(color: AppColor.textboxs),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, top: 10),
                      child: Text(
                        '${documents[index].get('answer')}',
                        style: b18,
                      ),
                    )),
              );
            },
          ),
        ],
      ),
    );
  }
}
