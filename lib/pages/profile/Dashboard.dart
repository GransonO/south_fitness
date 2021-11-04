import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/auth/login.dart';
import 'package:south_fitness/pages/profile/PasswordUpdate.dart';
import 'package:south_fitness/services/net.dart';

import '../common.dart';
import 'Profile.dart';

class Dashboard extends StatefulWidget {

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  bool showChat = false;
  bool showChats = false;
  bool teamChat = false;
  bool isUploading = false;
  bool loadingState = true;

  late SharedPreferences prefs;
  var username = "";
  var email = "";
  var team = "";
  var user_id = "";
  var personalData = {};

  String id = '';
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";

  var caloriesCount = 0.0;
  var pointsCount = 0.0;
  var distanceCount = 0.0;

  Color mainColor = Colors.white;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
  }
  var img = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      email = prefs.getString("email")!;
      team = prefs.getString("team")!;
      image = prefs.getString("image")!;
      user_id = prefs.getString("user_id")!;
      img = prefs.getString("institute_logo")!;

      var institutePrimaryColor = prefs.getString("institute_primary_color");
      List colors = institutePrimaryColor!.split(",");
      mainColor = Color.fromARGB(255,int.parse(colors[0]),int.parse(colors[1]),int.parse(colors[2]));
      loadingState = false;
    });
    getUserPerformance(user_id);
  }

  getUserPerformance(userId) async {
    var personal = await PerformanceResource().getDashboardPerformance(userId);
    setState(() {
      personalData = personal;
      print("-------------------personalData------------------------ $personalData");
      caloriesCount = personalData["calories"] + 0.0;
      pointsCount = personalData["steps"] + 0.0;
      distanceCount = personalData["distance"] + 0.0;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
        ) : Container(
          height: _height(100),
          width: _width(100),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  child: showChat ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: _height(9), left: _width(4), right: _width(4), bottom: _height(1)),
                        height: _height(10),
                        width: _width(100),
                        child: Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  setState((){
                                    showChats = true;
                                    teamChat = false;
                                  });
                                },
                                child: Text(
                                    "Chats",
                                    style: TextStyle(
                                        color: showChats ? mainColor : Colors.black,
                                        fontSize: 20
                                    )
                                ),
                              ),
                              SizedBox(width: _width(5),),
                              Text(
                                  " | ",
                                  style: TextStyle(
                                      fontSize: 20
                                  )
                              ),
                              SizedBox(width: _width(5),),
                              InkWell(
                                onTap: (){
                                  setState((){
                                    showChats = false;
                                    teamChat = true;
                                  });
                                },
                                child: Text(
                                    "Teams",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: teamChat ? mainColor : Colors.black,
                                    )
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: _height(7),
                                width: _height(7),
                                decoration: Common().roundedContainer(50.0, mainColor),
                                child: Center(child: Icon(Icons.add, color: Colors.white, size:30)),
                              )
                            ]
                        ),
                      ),
                      Container(
                          height: _height(70),
                          width: _width(100),
                          padding: EdgeInsets.only(top: _height(2), left: _width(4), right: _width(4), bottom: _height(1)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25),),
                              color: Color.fromARGB(255, 245,246,250)
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: _height(10),
                                width: _width(100),
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(top: _height(2)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                    color: Color.fromARGB(255,255,255,255)
                                ),
                                child: Row(
                                    children: [
                                      Container(
                                        height: _height(7),
                                        width: _height(7),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          child: SvgPicture.asset(
                                              "assets/images/male.svg",
                                              fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: _width(5)),
                                      Container(
                                        height: _height(9),
                                        width: _width(45),
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            Container(
                                              width: _width(45),
                                              child: Text(
                                                  teamChat ? "Team Endurance": "John Pan",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 1,),
                                            Container(
                                              width: _width(45),
                                              child: Text("This is a cool plan I really...",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  )),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: _height(9),
                                        width: _width(10),
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            Container(
                                              width: _width(5),
                                              height: _width(5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                                  color: mainColor
                                              ),
                                              child: Center(
                                                child: Text(
                                                    "1",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: _width(15),
                                              child: Text(
                                                  "13:43",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  )),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                              Container(
                                height: _height(10),
                                width: _width(100),
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(top: _height(2)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                    color: Color.fromARGB(255,255,255,255)
                                ),
                                child: Row(
                                    children: [
                                      Container(
                                        height: _height(7),
                                        width: _height(7),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          child: SvgPicture.asset(
                                              "assets/images/male.svg",
                                              fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: _width(5)),
                                      Container(
                                        height: _height(9),
                                        width: _width(45),
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            Container(
                                              width: _width(45),
                                              child: Text(
                                                  teamChat ? "Team Speed": "John Jack",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 1,),
                                            Container(
                                              width: _width(45),
                                              child: Text("This is a cool plan I really...",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  )),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: _height(9),
                                        width: _width(10),
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            Container(
                                              width: _width(5),
                                              height: _width(5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                                  color: mainColor
                                              ),
                                              child: Center(
                                                child: Text(
                                                    "1",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: _width(15),
                                              child: Text(
                                                  "13:43",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  )),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                              Container(
                                height: _height(10),
                                width: _width(100),
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(top: _height(2)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                    color: Color.fromARGB(255,255,255,255)
                                ),
                                child: Row(
                                    children: [
                                      Container(
                                        height: _height(7),
                                        width: _height(7),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          child: SvgPicture.asset(
                                              "assets/images/male.svg",
                                              fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: _width(5)),
                                      Container(
                                        height: _height(9),
                                        width: _width(45),
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            Container(
                                              width: _width(45),
                                              child: Text(
                                                  teamChat ? "Team Agility": "Joyce A",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 1,),
                                            Container(
                                              width: _width(45),
                                              child: Text("This is a cool plan I really...",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  )),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: _height(9),
                                        width: _width(10),
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            Container(
                                              width: _width(5),
                                              height: _width(5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                                  color: mainColor
                                              ),
                                              child: Center(
                                                child: Text(
                                                    "1",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: _width(15),
                                              child: Text(
                                                  "13:43",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  )),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                              teamChat ? Spacer() : Container(),
                              teamChat ? Container(
                                height: _height(10),
                                width: _width(100),
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(top: _height(2)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                    color: mainColor
                                ),
                                child: Row(
                                    children: [
                                      Container(
                                        height: _height(7),
                                        width: _height(7),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          child: SvgPicture.asset(
                                            "assets/images/male.svg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: _width(5)),
                                      Container(
                                        height: _height(9),
                                        width: _width(45),
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            Container(
                                              width: _width(45),
                                              child: Text(
                                                  "General Group",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 1,),
                                            Container(
                                              width: _width(45),
                                              child: Text("This is a cool plan I really...",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: _height(9),
                                        width: _width(10),
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            Container(
                                              width: _width(15),
                                              child: Text(
                                                  "13:43",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                              ) : Container(),
                            ],
                          )

                      )
                    ],
                  ) : Column(
                    children: [
                      Container(
                        width: _width(100),
                        child: Text(
                          "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in as some form, by injected humour",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: _height(5),),

                      Container(
                        width: _width(90),
                        child: Row(
                          children: [
                            Container(
                              height: _height(17),
                              width: _height(17),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      height: _height(17),
                                      width: _height(17),
                                      margin: EdgeInsets.all(_width(2)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: _height(17),
                                              width: _height(17),
                                              child: Image.network(
                                                image,
                                                height: _height(17),
                                                width: _height(17),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ),
                                ),
                            ),

                            SizedBox(width: _width(1),),
                            Column(
                                children: [
                                  Container(
                                    width: _width(50),
                                    child: Text(
                                      "$username",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(width: _height(2),),
                                  Container(
                                    width: _width(50),
                                    child: Text(
                                      "TEAM ${team.toUpperCase()}",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  )
                                ]
                            ),
                            Spacer(),
                          ],
                        ),
                      ),

                      Container(
                          width: _width(90),
                          height: _height(35),
                          margin: EdgeInsets.only(top: _height(1), bottom: _height(3)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: _height(15),
                                    width: _width(42.5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        color: mainColor
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                              children: [
                                                Icon(Icons.directions_run_rounded, size: 25, color: Colors.white),
                                                Spacer(),
                                                Container(
                                                  height: _height(3),
                                                  width: _height(3),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                                      color: Color.fromARGB(50,255,255,255)
                                                  ),
                                                  child: Center(
                                                      child: Icon(Icons.more_horiz_outlined, size: 15, color: Colors.white)
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                              children: [
                                                Container(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            width: _width(20),
                                                            child: Text(
                                                                "Distance",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 14
                                                                )
                                                            )
                                                        ),
                                                        Container(
                                                            width: _width(20),
                                                            child: Text(
                                                                "$distanceCount km",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12
                                                                )
                                                            )
                                                        ),
                                                      ],
                                                    )
                                                )
                                              ]
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: _height(15),
                                    width: _width(42.5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        color: mainColor
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                              children: [
                                                Icon(Icons.directions_bike_rounded, size: 25, color: Colors.white),
                                                Spacer(),
                                                Container(
                                                  height: _height(3),
                                                  width: _height(3),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                                      color: Color.fromARGB(50,255,255,255)
                                                  ),
                                                  child: Center(
                                                      child: Icon(Icons.more_horiz_outlined, size: 15, color: Colors.white)
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                              children: [
                                                Container(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            width: _width(20),
                                                            child: Text(
                                                                "Points",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 14
                                                                )
                                                            )
                                                        ),
                                                        Container(
                                                            width: _width(20),
                                                            child: Text(
                                                                "$pointsCount",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12
                                                                )
                                                            )
                                                        ),
                                                      ],
                                                    )
                                                )
                                              ]
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: _height(2),),
                              Row(
                                children: [
                                  Container(
                                    height: _height(15),
                                    width: _width(42.5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        color: Color.fromARGB(205, 232,196,40)
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                              children: [
                                                Icon(Icons.favorite_outline_outlined, size: 25, color: Colors.white),
                                                Spacer(),
                                                Container(
                                                  height: _height(3),
                                                  width: _height(3),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                                      color: Color.fromARGB(50,255,255,255)
                                                  ),
                                                  child: Center(
                                                      child: Icon(Icons.more_horiz_outlined, size: 15, color: Colors.white)
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                              children: [
                                                Container(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            width: _width(20),
                                                            child: Text(
                                                                "Calories",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 14
                                                                )
                                                            )
                                                        ),
                                                        Container(
                                                            width: _width(20),
                                                            child: Text(
                                                                "$caloriesCount cl",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12
                                                                )
                                                            )
                                                        ),
                                                      ],
                                                    )
                                                )
                                              ]
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  // Container(
                                  //   height: _height(15),
                                  //   width: _width(42.5),
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.all(Radius.circular(15)),
                                  //       color: mainColor
                                  //   ),
                                  //   child: Column(
                                  //     children: [
                                  //       Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Row(
                                  //             children: [
                                  //               Icon(Icons.arrow_upward_outlined, size: 25, color: Colors.white),
                                  //               Spacer(),
                                  //             ]
                                  //         ),
                                  //       ),
                                  //       Spacer(),
                                  //       Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Container(
                                  //             child: Text(
                                  //                 "You’ve improved 10% more compared to last week’s progress.",
                                  //                 style: TextStyle(
                                  //                     color: Colors.white,
                                  //                     fontSize: 14
                                  //                 )
                                  //             )
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              )
                            ],
                          )
                      ),

                      // InkWell(
                      //   onTap: (){
                      //     setState(() {
                      //       showChat = true;
                      //     });
                      //   },
                      //   child: Container(
                      //       width: _width(90),
                      //       height: _height(6),
                      //       child: Center(
                      //         child: Row(
                      //           children: [
                      //             Container(
                      //               height: _height(3),
                      //               width: _width(5),
                      //               child: SvgPicture.asset("assets/images/chats.svg"),
                      //             ),
                      //             SizedBox(width: _width(5),),
                      //             Text(
                      //                 "Chats",
                      //                 style: TextStyle(
                      //                     fontSize: 16
                      //                 )
                      //             ),
                      //             Spacer(),
                      //             Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16)
                      //           ],
                      //         ),
                      //       )
                      //   ),
                      // ),
                      InkWell(
                        onTap: (){
                          Common().newActivity(context, Profile());
                        },
                        child: Container(
                            width: _width(90),
                            height: _height(6),
                            child: Center(
                              child: Row(
                                children: [
                                  Container(
                                    height: _height(3),
                                    width: _width(5),
                                    child: SvgPicture.asset("assets/images/edit.svg"),
                                  ),
                                  SizedBox(width: _width(5),),
                                  Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                          fontSize: 16
                                      )
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16)
                                ],
                              ),
                            )
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Common().newActivity(context, PasswordUpdate());
                        },
                        child: Container(
                            width: _width(90),
                            height: _height(6),
                            child: Center(
                              child: Row(
                                children: [
                                  Container(
                                    height: _height(3),
                                    width: _width(5),
                                    child: Icon(Icons.visibility_off),
                                  ),
                                  SizedBox(width: _width(5),),
                                  Text(
                                      "Edit Password",
                                      style: TextStyle(
                                          fontSize: 16
                                      )
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16)
                                ],
                              ),
                            )
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Fluttertoast.showToast(
                              msg: "Logging you out",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Timer(Duration(seconds: 3), () => handleSignOut(context));
                        },
                        child: Container(
                            width: _width(90),
                            height: _height(6),
                            child: Center(
                              child: Row(
                                children: [
                                  Container(
                                    height: _height(3),
                                    width: _width(5),
                                    child: SvgPicture.asset("assets/images/logout.svg"),
                                  ),
                                  SizedBox(width: _width(5),),
                                  Text(
                                      "Logout",
                                      style: TextStyle(
                                          fontSize: 16
                                      )
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16)
                                ],
                              ),
                            )
                        ),
                      ),

                      SizedBox( height: _height(8))
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
                      onTap: (){
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: Icon(Icons.menu, size: 30, color: mainColor,),
                    ),
                    SizedBox(width: _width(4),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Common().navDrawer(context, username, email, "profile", image),
    );

  }


  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }

  handleSignOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false);
  }
}
