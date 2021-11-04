import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../common.dart';

class ChatCount extends StatefulWidget {

  String GroupId = "";
  ChatCount(chatID){
    GroupId = chatID;
  }

  @override
  _ChatCount createState() => _ChatCount(GroupId);
}

class _ChatCount extends State<ChatCount> {

  var groupID = "";
  _ChatCount(GroupId){
    groupID = GroupId;
  }

  String value = "";
  checkLastMessage() async {
    CollectionReference chats =
    FirebaseFirestore.instance.collection(groupID);
    setState(() {
      // value = data.docs[0].data()["created_at"];
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
