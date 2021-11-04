import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../common.dart';

class TimeWidget extends StatefulWidget {

  String GroupId = "";
  bool isGeneral = false;

  TimeWidget(chatID, general){
    GroupId = chatID;
    isGeneral = general;
  }

  @override
  _TimeWidgetState createState() => _TimeWidgetState(GroupId, isGeneral);
}

class _TimeWidgetState extends State<TimeWidget> {

  var groupID = "";
  bool isGeneral = false;

  _TimeWidgetState(GroupId, general){
    groupID = GroupId;
    isGeneral = general;
  }

  String value = "";
  checkLastMessage() async {
    CollectionReference chats =
    FirebaseFirestore.instance.collection(groupID);
    var data = await chats.orderBy("epoch_time", descending: true).limit(1).get();
    var result = data.docs[0].data();
    setState(() {
      // value = result != null ? result["created_at"] : "--";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLastMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        // value != null ? Common().timeStringFormatter(value).toString() : "--",
        "--",
        style: TextStyle(fontSize: 8, color: isGeneral ? Colors.white : Colors.grey)
    );
  }
}
