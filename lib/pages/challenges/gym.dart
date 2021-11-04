import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common.dart';

class Gym extends StatefulWidget {
  @override
  _GymState createState() => _GymState();
}

class _GymState extends State<Gym> {

  var username = "";
  var email = "";
  late SharedPreferences prefs;
  bool loadingState = true;

  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";
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
      username = prefs.getString("username")!;
      email = prefs.getString("email")!;
      image = prefs.getString("image")!;
      loadingState = false;
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
                    SizedBox(height: _height(3),),
                    Container(
                      margin: EdgeInsets.only(left: _width(4), right: _width(4)),
                      child: Row(
                          children: [
                            Text(
                              "Gym",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(width: 10,),
                            Text("|",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.left,
                            ),

                          ]
                      ),
                    ),
                    SizedBox( height: _height(2)),
                    Container(
                      height: _height(80),
                      padding: EdgeInsets.only(left: _width(4), right: _width(4)),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: _height(3),),
                            Container(
                              height: _height(10),
                              width: _width(100),
                              padding: EdgeInsets.only(left: _width(3), right: _width(2)),
                              margin: EdgeInsets.only(bottom: _height(3)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Row(
                                  children: [
                                    Container(
                                      height: _height(7),
                                      width: _height(7),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(Radius.circular(50))
                                      ),
                                    ),
                                    SizedBox(width: _width(3),),
                                    Container(
                                      height: _height(7),
                                      width: _width(55),
                                      child: Column(
                                        children: [
                                          Container(
                                              width: _width(55),
                                              child: Text("South Fitness gym", style: TextStyle(fontWeight: FontWeight.bold),)),
                                          Spacer(),
                                          Container(
                                              width: _width(55),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.phone, color: Colors.green, size: 13 ),
                                                  SizedBox(width: _width(3),),
                                                  Text("0712 288 371", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12),),
                                                ],
                                              )
                                          ),
                                          Spacer(),
                                          Container(
                                              width: _width(55),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.location_pin, color: Colors.green, size: 13 ),
                                                  SizedBox(width: _width(3),),
                                                  Text("Garden City, Thika Road ", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12),),
                                                ],
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: _height(5),
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          // Container(
                                          //     child: Text("13:43", style: TextStyle(fontSize: 11, color: Colors.grey))
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            Container(
                              height: _height(10),
                              width: _width(100),
                              padding: EdgeInsets.only(left: _width(3), right: _width(2)),
                              margin: EdgeInsets.only(bottom: _height(3)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Row(
                                  children: [
                                    Container(
                                      height: _height(7),
                                      width: _height(7),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(Radius.circular(50))
                                      ),
                                    ),
                                    SizedBox(width: _width(3),),
                                    Container(
                                      height: _height(7),
                                      width: _width(55),
                                      child: Column(
                                        children: [
                                          Container(
                                              width: _width(55),
                                              child: Text("Kyle Gym", style: TextStyle(fontWeight: FontWeight.bold),)),
                                          Spacer(),
                                          Container(
                                              width: _width(55),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.phone, color: Colors.green, size: 13 ),
                                                  SizedBox(width: _width(3),),
                                                  Text("0712 208 372", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12),),
                                                ],
                                              )
                                          ),
                                          Spacer(),
                                          Container(
                                              width: _width(55),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.location_pin, color: Colors.green, size: 13 ),
                                                  SizedBox(width: _width(3),),
                                                  Text("Prestige Mall, Ngong Road ", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12),),
                                                ],
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: _height(5),
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          // Container(
                                          //     child: Text("13:43", style: TextStyle(fontSize: 11, color: Colors.grey))
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ],
                        ),
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
                  // Common().logoOnBar(context),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      _scaffoldKey.currentState!.openDrawer();
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
      drawer: Common().navDrawer(context, username, email, "gym", image),
    );
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }
}