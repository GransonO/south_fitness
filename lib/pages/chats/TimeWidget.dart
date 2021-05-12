import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../common.dart';

class TimeWidget extends StatefulWidget {

  String GroupId;
  TimeWidget(chatID){
    GroupId = chatID;
  }

  @override
  _TimeWidgetState createState() => _TimeWidgetState(GroupId);
}

class _TimeWidgetState extends State<TimeWidget> {

  var groupID;
  _TimeWidgetState(GroupId){
    groupID = GroupId;
  }

  String value;
  checkLastMessage() async {
    CollectionReference chats =
    FirebaseFirestore.instance.collection(groupID);
    var data = await chats.orderBy("epoch_time", descending: true).limit(1).get();
    setState(() {
      value = data.docs[0].data()["created_at"];
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
        value != null ? Common().timeStringFormatter(value).toString() : "--",
        style: TextStyle(fontSize: 8, color: Colors.grey)
    );
  }
}
