import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/services/net.dart';

import '../common.dart';
import 'chat_view.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  var username = "";
  var email = "";
  SharedPreferences prefs;
  bool chats = true;
  bool clubs = false;
  bool loading = true;
  bool posting = false;
  bool addGroup = false;
  bool creating = false;
  var groupTitle = "";
  var description = "";
  var groups = [];
  var image =
      "https://res.cloudinary.com/dolwj4vkq/image/upload/v1565367393/jade/profiles/user.jpg";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image");
    });
    getAllGroup();
  }

  getAllGroup() async {
    var results = await ChatService().allGroups();
    setState(() {
      groups = results;
      loading = false;
      posting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    SizedBox(
                      height: _height(3),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: _width(4), right: _width(4)),
                      child: Row(children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              clubs = false;
                              chats = true;
                            });
                          },
                          child: Text(
                            "Chats",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: chats ? Colors.green : Colors.black),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "|",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              clubs = false;
                              chats = true;
                            });
                          },
                          child: Text(
                            "Clubs",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            setState(() {
                              addGroup = true;
                            });
                          },
                          child: Container(
                              height: _height(6),
                              width: _height(6),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )),
                        )
                      ]),
                    ),
                    SizedBox(height: _height(2)),
                    Container(
                      height: _height(80),
                      padding: EdgeInsets.only(left: _width(4), right: _width(4)),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: SingleChildScrollView(
                        child: Column(
                          children: loading ? [
                            SizedBox( height: _height(3),),
                            Center(child: SpinKitThreeBounce(color: Colors.lightGreen, size: 30))
                          ] : populateGroups(),
                        )
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
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      size: 30,
                      color: Colors.lightGreen,
                    ),
                  ),
                  SizedBox(
                    width: _width(4),
                  ),
                ],
              ),
            ),
            addGroup ? Container(
              height: _height(100),
              width: _width(100),
              color: Colors.black54,
              child: Center(
                child: Container(
                  height: _height(55),
                  width: _width(100),
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(
                    children: [

                      Container(
                        width: _width(80),
                        margin: EdgeInsets.only(right: _width(1), top: _width(3)),
                        child: Row(
                          children: [
                            Spacer(),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  addGroup = false;
                                });
                              },
                                child: Icon(Icons.close, color: Colors.grey,)
                            ),
                          ],
                        )
                      ),
                      Container(
                        width: _width(80),
                        margin: EdgeInsets.only(right: _width(2), top: _height(3),  bottom: _height(1)),
                        child: Text(
                          "Group Title: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ),
                      Container(
                        height: _height(5),
                        width: _width(80),
                        margin: EdgeInsets.only(right: _width(2),),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                                width: 0.5,
                                color: Colors.grey
                            )
                        ),
                        child: Container(
                          width: _width(80),
                          child: TextField(
                            onChanged: (value){
                              setState(() {
                                groupTitle = value;
                              });
                            },
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 13, color: Color.fromARGB(200, 169, 169, 169)),
                            ),
                            style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ),
                      Container(
                        height: _height(25),
                        width: _width(80),
                        margin: EdgeInsets.only(right: _width(2), top: _height(3)),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                                width: 0.5,
                                color: Colors.grey
                            )
                        ),
                        child: TextField(
                          maxLines: 5,
                          onChanged: (value){
                            setState(() {
                              description = value;
                            });
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 13, color: Color.fromARGB(200, 169, 169, 169)),
                              hintText: "Group description"
                          ),
                          style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),

                      SizedBox( height: _height(2)),
                      Center(
                        child: InkWell(
                          onTap: (){
                            createGroup();
                          },
                          child: Container(
                            height: _height(5),
                            width: _width(80),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255,110,180,63),
                                borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            child: Center(
                              child: creating ? SpinKitThreeBounce(color: Colors.white, size: 20,) : Text(
                                "Create",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ) : Container()
          ],
        ),
      ),
      drawer: Common().navDrawer(context, username, email, "clubs", image),
    );
  }

  _height(size) {
    return Common().componentHeight(context, size);
  }

  _width(size) {
    return Common().componentWidth(context, size);
  }

  groupItem(element) {
    return InkWell(
      onTap: () {
        Common().newActivity(context,
            chatView(element["group_id"], "${element["group_title"]}"));
      },
      child: Container(
        height: _height(10),
        width: _width(100),
        padding: EdgeInsets.only(left: _width(3), right: _width(2)),
        margin: EdgeInsets.only(bottom: _height(3),),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Row(children: [
          Container(
            height: _height(7),
            width: _height(7),
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(50))),
          ),
          SizedBox(
            width: _width(3),
          ),
          Container(
            height: _height(5),
            width: _width(55),
            child: Column(
              children: [
                Container(
                    width: _width(55),
                    child: Text(
                      "${element["group_title"]}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Spacer(),
                Container(
                    width: _width(55),
                    child: Text(
                      "${element["group_slogan"]}",
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          ),
          Spacer(),
          Container(
            height: _height(5),
            child: Column(
              children: [
                Container(
                    height: _width(4.5),
                    width: _width(4.5),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Center(
                        child: Text(
                      "${Random().nextInt(50)}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    ))),
                Spacer(),
                Container(
                    child: Text("13:43",
                        style: TextStyle(fontSize: 12, color: Colors.grey))),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  populateGroups() {
    var children = <Widget>[];
    children.add(SizedBox(
      height: _height(3),
    ));
    groups.forEach((element) {
      children.add(
          groupItem(element)
      );
    });

    children.add(
      InkWell(
        onTap: () {
          Common().newActivity(
              context,
              chatView(
                  "bb79a16c-8f40-11e-8dbb-f45c89b7cf75",
                  "General channel"));
        },
        child: Container(
          height: _height(10),
          width: _width(100),
          margin: EdgeInsets.only(top: _height(5), bottom: _height(5), ),
          padding: EdgeInsets.only(
              left: _width(3), right: _width(2)),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius:
              BorderRadius.all(Radius.circular(15))),
          child: Row(children: [
            Container(
              height: _height(7),
              width: _height(7),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(50))),
            ),
            SizedBox(
              width: _width(3),
            ),
            Container(
              height: _height(5),
              width: _width(55),
              child: Column(
                children: [
                  Container(
                      width: _width(55),
                      child: Text(
                        "General Group",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                  Spacer(),
                  Container(
                      width: _width(55),
                      child: Text(
                          "That's an awesome idea, I like it very much muchachos",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white))),
                ],
              ),
            ),
            Spacer(),
            Container(
              height: _height(5),
              child: Column(
                children: [
                  Container(
                      height: _width(4.5),
                      width: _width(4.5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(50))),
                      child: Center(
                          child: Text(
                            "${Random().nextInt(50)}",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 8,
                            ),
                          ))),
                  Spacer(),
                  Container(
                      child: Text("13:43",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white))),
                ],
              ),
            ),
          ]),
        ),
      ),
    );

    return children;
  }

  createGroup() async {
    if(groupTitle == "" || description == ""){
      Fluttertoast.showToast(msg: "Please fill in all entries");
      return;
    }
    setState(() {
      creating = true;
    });

    var group = {
      "created_by": email,
      "user_id": email,
      "group_title":groupTitle,
      "creator_name":username,
      "group_slogan": description
    };
    bool posted = await ChatService().createGroup(group);
    if(posted){
      Fluttertoast.showToast(msg: "Group created");
      getAllGroup();
    }else{
      Fluttertoast.showToast(msg: "An error occurred when creating the group");
    }

    setState(() {
      creating = false;
      addGroup = false;
    });
  }
}
