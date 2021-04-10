import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/services/net.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../common.dart';

class chatView extends StatefulWidget {

  var groupId;
  var groupName;

  chatView(id, name){
    groupId = id;
    groupName = name;
  }

  @override
  _chatViewState createState() => _chatViewState(groupId, groupName);
}

class _chatViewState extends State<chatView> {

  var groupId;
  var groupName;

  _chatViewState(id, name){
    groupId = id;
    groupName = name;
  }

  var username = "";
  var email = "";
  SharedPreferences prefs;
  bool clubs = false;
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1565367393/jade/profiles/user.jpg";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String message;
  final _controller = TextEditingController();

  var photoUrl = "";
  var chats = [];
  bool loading = true;
  bool posting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("--------------------------- $groupId");
    setPrefs();
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image");
    });
    // getGroupChats();
  }

  @override
  Widget build(BuildContext context) {

    Query query = FirebaseFirestore.instance.collection('$groupId');
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: _height(9)),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: _width(4), right: _width(4)),
                      child: Row(
                          children: [
                            Text(
                              "$groupName",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Spacer()
                          ]
                      ),
                    ),
                    SizedBox( height: _height(1)),
                    Container(
                      height: _height(85),
                      width: _width(100),
                      padding: EdgeInsets.only(left: _width(4), right: _width(4)),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                      ),
                      child: Stack(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: query.orderBy("epoch_time").snapshots(),
                            builder: (context, stream) {
                              if (stream.connectionState == ConnectionState.none) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (stream.hasError) {
                                return Center(child: Text(stream.error.toString()));
                              }

                              QuerySnapshot querySnapshot = stream.data;

                              return ListView.builder(
                                padding: EdgeInsets.only(bottom: _height(10)),
                                itemCount: querySnapshot != null ? querySnapshot.size : 0,
                                itemBuilder: (context, index) => chatItem(querySnapshot.docs[index]),
                              );
                            },
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                margin: EdgeInsets.only(bottom: _height(3), left: _width(1), right: _width(1)),
                                width: _width(100),
                                child: Container(
                                  height: _height(6),
                                  width: _width(100),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),

                                  child: Row(
                                    children: [
                                      Container(
                                        width: _width(80),
                                        child: TextField(
                                          controller: _controller,
                                          onChanged: (value){
                                            setState(() {
                                              message = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(fontSize: 15, color: Color.fromARGB(200, 169, 169, 169)),
                                              hintText: "Write something..."
                                          ),
                                          style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                          onTap: (){
                                            setState(() {
                                              postChat();
                                            });
                                          },
                                          child: Container(
                                              width: _width(5),
                                              child: posting ? SpinKitThreeBounce(color: Colors.lightGreen, size: 12,) : Icon(
                                                Icons.send, size: 25, color: Colors.lightGreen,
                                              )
                                          )),
                                      Spacer()
                                    ],
                                  ),

                                ),
                            ),
                          ),
                        ]
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: _height(7),
              color: Colors.white,
              child: Row(
                children: [
                  Common().logoOnBar(context),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Icon(Icons.menu, size: 30, color: Colors.lightGreen,),
                  ),
                  SizedBox(width: _width(4),),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Common().navDrawer(context, username, email, "chat", image),
    );
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }

  chatItem(element){
    return Row(
      children: [
        checkUser(element["user_id"]) ? Spacer() : Container(),
        InkWell(
          onTap: (){
          },
          child: Container(
              width: _width(70),
              margin: EdgeInsets.only(
                top: _height(3),
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: checkUser(element["user_id"]) ? Colors.lightGreen : Colors.white,
                borderRadius: BorderRadius.only(topLeft: checkUser(element["user_id"]) ? Radius.circular(15) : Radius.circular(0), topRight: checkUser(element["user_id"]) ? Radius.circular(0) : Radius.circular(15), bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Container(
                            width: _width(50),
                            child: Text("${element["username"]}", style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: checkUser(element["user_id"]) ? Colors.white : Colors.black
                            ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Spacer(),
                        ],
                      )
                  ),
                  SizedBox(height: 5,),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${element["message"]}",  style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: checkUser(element["user_id"]) ? Colors.white : Colors.black
                      ),
                        textAlign: TextAlign.left,
                        maxLines: 50,
                        overflow: TextOverflow.ellipsis,)
                  ),
                  SizedBox(height: 4,),
                  Row(
                    children: [
                      Spacer(),
                      Container(
                        width: _width(30),
                        child: Text("${dateChecker(element["created_at"])}", style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: checkUser(element["user_id"]) ? Colors.white : Colors.black
                        ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  )
                ],
              )
          ),
        ),
        checkUser(element["user_id"]) ? Container() : Spacer(),
      ],
    );
  }

  checkUser(theEmail){
    return(theEmail == email);
  }

  dateChecker(dateTimeString) {
    return Common().dateStringFormatter(dateTimeString);
  }

  postChat() async {
    CollectionReference chats = FirebaseFirestore.instance.collection('$groupId');
    if(message == null){
      Fluttertoast.showToast(msg: "Cant post an empty message");
    }else{
      setState(() {
        posting = true;
      });
      var theDate = DateTime.now();

      await chats.add({
        "group_id": groupId,
        "user_id":email,
        "message":message,
        "reply_body":"",
        "message_id": Uuid().v4().toString(),
        "username": username,
        "created_at": "${theDate.year}-${theDate.month}-${theDate.day} ${theDate.hour}:${theDate.minute}:${theDate.second}",
        "epoch_time": theDate.microsecondsSinceEpoch
      });

        setState(() {
          posting = false;
        });
        _controller.clear();
    }
  }
}
