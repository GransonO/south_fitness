import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/services/net.dart';

import '../common.dart';
import 'TimeWidget.dart';
import 'chat_view.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  var username = "";
  var user_id = "";
  var email = "";
  var alias = "";
  var institution = "";
  var institution_id = "";
  SharedPreferences prefs;
  bool chats = true;
  bool loadingState = true;
  bool clubs = false;
  bool loading = true;
  bool posting = false;
  bool addGroup = false;
  bool creating = false;
  bool requestToJoin = false;
  bool joining = false;
  bool checking = false;
  var groupTitle = "";
  var description = "";
  Color mainColor = Colors.white;
  var groups = [];
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";
  var groupImage =
      "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618138330/South_Fitness/ic_launcher.png";
  var generalImage =
      "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618138330/South_Fitness/ic_launcher.png";

  File groupImageFile;
  bool isUploading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var img = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";

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
      user_id = prefs.getString("user_id");
      institution = prefs.getString("institution");
      institution_id = prefs.getString("institution_id");
      img = prefs.getString("institute_logo");
      var institutePrimaryColor = prefs.getString("institute_primary_color");
      List colors = institutePrimaryColor.split(",");
      mainColor = Color.fromARGB(255,int.parse(colors[0]),int.parse(colors[1]),int.parse(colors[2]));
      loadingState = false;
    });
    print("================username=============================$username");
    print("================user_id=============================$user_id");
    print("================institution_id=============================$institution_id");
    getAllGroup();
  }

  getAllGroup() async {
    var results = await ChatService().allGroups(institution_id);
    setState(() {
      groups = results;
      loading = false;
      posting = false;
    });
  }

  getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var path = image.path;
    setState(() {
      groupImageFile = image;
      isUploading = true;
    });
    cloudReviewUpload(path, "group_image");
  }

  cloudReviewUpload(var path, var name) async {
    FormData formData = new FormData.fromMap({
      "upload_preset": "South_Fitness_Groups",
      "cloud_name": "dolwj4vkq",
      "file": await MultipartFile.fromFile(path, filename: name),
    });
    var imageUrl = await Authentication().uploadImage(formData);
    setState(() {
      groupImage = imageUrl;
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: loadingState ? Container(
          height: _height(100),
          width: _width(100),
          child: Center(
            child: SpinKitThreeBounce(
              color: Colors.grey,
              size: 30,
            ),
          ),
        ) : Stack(
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
                                color: Colors.black87
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // Text(
                        //   "|",
                        //   style: TextStyle(
                        //       fontSize: 25, fontWeight: FontWeight.bold),
                        //   textAlign: TextAlign.left,
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // InkWell(
                        //   onTap: () {
                        //     setState(() {
                        //       clubs = true;
                        //       chats = false;
                        //     });
                        //   },
                        //   child: Text(
                        //     "Clubs",
                        //     style: TextStyle(
                        //         fontSize: 25,
                        //         fontWeight: FontWeight.bold,
                        //         color: clubs ? mainColor : Colors.black),
                        //     textAlign: TextAlign.left,
                        //   ),
                        // ),
                        Spacer(),
                        // InkWell(
                        //   onTap: (){
                        //     setState(() {
                        //       addGroup = true;
                        //     });
                        //   },
                        //   child: Container(
                        //       height: _height(6),
                        //       width: _height(6),
                        //       decoration: BoxDecoration(
                        //           color: mainColor,
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(50))),
                        //       child: Center(
                        //         child: Icon(
                        //           Icons.add,
                        //           color: Colors.white,
                        //           size: 30,
                        //         ),
                        //       )),
                        // )
                      ]),
                    ),
                    SizedBox(height: _height(2)),
                    Container(
                      height: _height(80),
                      padding:
                          EdgeInsets.only(left: _width(4), right: _width(4)),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: SingleChildScrollView(
                          child: Column(
                        children: loading
                            ? [
                                SizedBox(
                                  height: _height(3),
                                ),
                                Center(
                                    child: SpinKitThreeBounce(
                                        color: mainColor, size: 30))
                              ]
                            : populateGroups(),
                      )),
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
                  Common().logoOnBar(context, img),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      size: 30,
                      color: mainColor,
                    ),
                  ),
                  SizedBox(
                    width: _width(4),
                  ),
                ],
              ),
            ),
            addGroup
                ? Container(
                    height: _height(100),
                    width: _width(100),
                    color: Colors.black54,
                    child: Center(
                      child: Container(
                        height: _height(70),
                        width: _width(100),
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                  width: _width(80),
                                  margin: EdgeInsets.only(
                                      right: _width(1), top: _width(3)),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              addGroup = false;
                                            });
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.grey,
                                          )),
                                    ],
                                  )),
                              InkWell(
                                onTap: () {
                                  getImage();
                                },
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: _height(15),
                                        width: _height(15),
                                        child: SpinKitCircle(
                                          color: mainColor,
                                        ),
                                      ),
                                      groupImageFile != null
                                          ? Container(
                                              height: _height(15),
                                              width: _height(15),
                                              child: Image.file(
                                                groupImageFile,
                                                height: _height(17),
                                                width: _height(17),
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Container(
                                              height: _height(17),
                                              width: _height(17),
                                              child: Image.network(
                                                groupImage,
                                                height: _height(17),
                                                width: _height(17),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                      Container(
                                          height: _height(15),
                                          width: _height(15),
                                          child: Center(
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.black54,
                                              size: 35,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: _width(80),
                                margin: EdgeInsets.only(
                                    right: _width(2),
                                    top: _height(3),
                                    bottom: _height(1)),
                                child: Text(
                                  "Group Title: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                height: _height(5),
                                width: _width(80),
                                margin: EdgeInsets.only(
                                  right: _width(2),
                                ),
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey)),
                                child: Container(
                                  height: _height(5),
                                  width: _width(80),
                                  child: Center(
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          groupTitle = value;
                                        });
                                      },
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                200, 169, 169, 169)),
                                      ),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: _height(25),
                                width: _width(80),
                                margin: EdgeInsets.only(
                                    right: _width(2), top: _height(3)),
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey)),
                                child: TextField(
                                  maxLines: 5,
                                  onChanged: (value) {
                                    setState(() {
                                      description = value;
                                    });
                                  },
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                              200, 169, 169, 169)),
                                      hintText: "Group description"),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ),
                              SizedBox(height: _height(2)),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    createGroup();
                                  },
                                  child: Container(
                                    height: _height(5),
                                    width: _width(80),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 110, 180, 63),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Center(
                                      child: creating
                                          ? SpinKitThreeBounce(
                                              color: Colors.white,
                                              size: 20,
                                            )
                                          : Text(
                                              "Create",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            requestToJoin ? Container(
                    height: _height(100),
                    width: _width(100),
                    color: Colors.black54,
                    child: Center(
                      child: Container(
                        height: _height(27),
                        width: _width(100),
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                  width: _width(80),
                                  margin: EdgeInsets.only(
                                      right: _width(1), top: _width(3)),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              requestToJoin = false;
                                            });
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: mainColor,
                                          )),
                                    ],
                                  )),
                              Container(
                                  width: _width(80),
                                  margin: EdgeInsets.only(
                                      right: _width(2),
                                      top: _height(3),
                                      bottom: _height(1)),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Your Alias: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "This shall be used in place of your name",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      )
                                    ],
                                  )),
                              Container(
                                height: _height(5),
                                width: _width(80),
                                margin: EdgeInsets.only(
                                  right: _width(2),
                                ),
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey)),
                                child: Container(
                                  height: _height(5),
                                  width: _width(80),
                                  child: Center(
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          alias = value;
                                        });
                                      },
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                200, 169, 169, 169)),
                                      ),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: _height(2)),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    joinGeneral();
                                  },
                                  child: Container(
                                    height: _height(5),
                                    width: _width(80),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 110, 180, 63),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Center(
                                      child: joining
                                          ? SpinKitThreeBounce(
                                              color: Colors.white,
                                              size: 20,
                                            )
                                          : Text(
                                              "Join Group",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            checking
                ? Center(
                    child:
                        SpinKitThreeBounce(color: mainColor, size: 30))
                : Container()
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
        margin: EdgeInsets.only(
          bottom: _height(3),
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            child: Container(
              height: _height(7),
              width: _height(7),
              child: Image.network(
                element["group_image"],
                height: _height(7),
                width: _height(7),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: _width(3),
          ),
          Container(
            width: _width(55),
            child: Column(
              children: [
                Spacer(),
                Container(
                    width: _width(55),
                    child: Text(
                      "${element["group_title"]}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 3,
                ),
                Container(
                    width: _width(55),
                    child: Text(
                      "${element["group_slogan"]}",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    )),
                Spacer(),
              ],
            ),
          ),
          Spacer(),
          Container(
            height: _height(5),
            child: Column(
              children: [
                // Container(
                //     height: _width(4.5),
                //     width: _width(4.5),
                //     decoration: BoxDecoration(
                //         color: mainColor,
                //         borderRadius: BorderRadius.all(Radius.circular(50))),
                //     child: Center(
                //         child: Text(
                //       "${Random().nextInt(7)}",
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 8,
                //       ),
                //     )
                //     )
                // ),
                Spacer(),
                TimeWidget(element["group_id"], false),
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
      children.add(groupItem(element));
    });

    children.add(
      InkWell(
        onTap: () async {
          // Check if member in general
          setState(() {
            checking = true;
          });
          var result =
              await ChatService().isGeneralMember({"user_id": user_id});
          setState(() {
            checking = false;
          });
          if (result["success"]) {
            // user exists
            prefs.setString("alias", result["alias"]);
            Common().newActivity(
                context,
                chatView(
                    "bb79a16c-8f40-11e-8dbb-f45c89b7cf75", "General channel"));
          } else {
            // Request user to join
            setState(() {
              requestToJoin = true;
            });
          }
        },
        child: Container(
          height: _height(10),
          width: _width(100),
          margin: EdgeInsets.only(
            top: _height(3),
            bottom: _height(3),
          ),
          padding: EdgeInsets.only(left: _width(3), right: _width(2)),
          decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Container(
                height: _height(7),
                width: _height(7),
                child: Image.network(
                  generalImage,
                  height: _height(7),
                  width: _height(7),
                  fit: BoxFit.cover,
                ),
              ),
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
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                  Spacer(),
                  Container(
                      width: _width(55),
                      child: Text(
                          "That's an awesome idea, I like it very much muchachos",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
            Spacer(),
            Container(
              height: _height(5),
              child: Column(
                children: [
                  // Container(
                  //     height: _width(4.5),
                  //     width: _width(4.5),
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.all(Radius.circular(50))),
                  //     child: Center(
                  //         child: Text(
                  //       "${Random().nextInt(50)}",
                  //       style: TextStyle(
                  //         color: mainColor,
                  //         fontSize: 8,
                  //       ),
                  //     ))),
                  Spacer(),
                  TimeWidget("bb79a16c-8f40-11e-8dbb-f45c89b7cf75", true)
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
    if (groupTitle == "" || description == "") {
      Fluttertoast.showToast(msg: "Please fill in all entries");
      return;
    }
    setState(() {
      creating = true;
    });

    var group = {
      "created_by": email,
      "user_id": prefs.getString("user_id"),
      "group_title": groupTitle,
      "creator_name": username,
      "group_slogan": description,
      "group_image": groupImage,
      "institution": prefs.getString("institution")
    };

    bool posted = await ChatService().createGroup(group);
    if (posted) {
      Fluttertoast.showToast(msg: "Group created");
      getAllGroup();
    } else {
      Fluttertoast.showToast(msg: "An error occurred when creating the group");
    }

    setState(() {
      creating = false;
      addGroup = false;
    });
  }

  joinGeneral() async {
    if (alias == "") {
      Fluttertoast.showToast(msg: "Please fill in all entries");
      return;
    }
    setState(() {
      joining = true;
    });

    var posted = await ChatService()
        .addGeneralMember({"alias": alias, "user_id": user_id, "email": email});
    if (posted["success"]) {
      prefs.setString("alias", alias);
      Fluttertoast.showToast(msg: "Joined success");
      Common().newActivity(context,
          chatView("bb79a16c-8f40-11e-8dbb-f45c89b7cf75", "General channel"));
    } else {
      Fluttertoast.showToast(msg: "An error occurred when joining the group");
    }

    setState(() {
      joining = false;
      requestToJoin = false;
    });
  }

  checkLastMessage(groupId) async {
    CollectionReference chats =
        FirebaseFirestore.instance.collection('$groupId');
    return await chats.orderBy("epoch_time", descending: true).limit(1).get();
  }
}
