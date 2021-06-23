import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/services/net.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

import '../common.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  SharedPreferences prefs;
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";

  var allPastActivities = [];

  var username = "";
  var email = "";
  var user_id = "";
  var team = "";
  bool loading = false;
  var firstDate;
  var lastDate;
  var displayDate = "Enter date range";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    setState(() {
      username = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image");
      user_id = prefs.getString("user_id");
      team = prefs.getString("team");
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            height: _height(100),
            width: _width(100),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: _height(9), left: _width(4), right: _width(4)),
                    child: Column(
                      children: [
                        SizedBox(height: _height(1),),

                        Container(
                          width: _width(100),
                          child: Text(
                            "History",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: _height(1),),
                        InkWell(
                          onTap: () async {
                            final List<DateTime> picked = await DateRangePicker.showDatePicker(
                                context: context,
                                initialFirstDate: new DateTime.now(),
                                initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
                                firstDate: new DateTime(2020),
                                lastDate: new DateTime(DateTime.now().year + 2)
                            );
                            if (picked != null && picked.length == 2) {
                              print(picked);
                              setState(() {
                                firstDate = Common().dateStringHistory(picked[0]);
                                lastDate = Common().dateStringHistory(picked[1]);
                                displayDate = "$firstDate - $lastDate";
                                loading = true;
                              });

                              var result = await HomeResources().getHistory({
                                "date_from":firstDate,
                                "date_to":lastDate,
                                "user_id":user_id
                              });

                              setState(() {
                                loading = false;
                                allPastActivities = result;
                              });
                            }
                          },
                          child: Container(
                              height: _height(7),
                              width: _width(100),
                              margin: EdgeInsets.only(top: _height(1), bottom: _height(1), ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Colors.lightGreen,
                              ),
                              child: Center(
                                  child: Text("$displayDate",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15
                                      )
                                  )
                              )
                          ),
                        ),
                        SizedBox(height: _height(3),),

                        loading ? Center(
                          child: SpinKitThreeBounce(
                            color: Colors.lightGreen,
                            size: 30,
                          ),
                        ) : Column(
                          children: displayHistory(),
                        ),

                        SizedBox(height: _height(3),),

                        SizedBox( height: _height(3))
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
        ),
        drawer: Common().navDrawer(context, username, email, "home", image),
      ),
    );
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }

  displayHistory() {
    var children = <Widget>[];
    if (allPastActivities.isNotEmpty) {
      allPastActivities.forEach((element) {
        children.add(
            Container(
                height: _height(10),
                width: _width(100),
                margin: EdgeInsets.only(bottom: _height(2)),
                child: Row(
                  children: [
                    Container(
                        height: _height(10),
                        width: _height(10),
                        child: Stack(
                          children: [
                            Center(
                              child: SpinKitThreeBounce(
                                color: Colors.lightGreen,
                                size: 20,
                              ),
                            ),
                            Container(
                              height: _height(10),
                              width: _height(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    15)),
                                child: Image.network(
                                  "${element["image_url"]}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    SizedBox(
                      width: _width(4),
                    ),
                    Column(
                      children: [
                        Spacer(),
                        Container(
                          width: _width(60),
                          child: Text(
                            "${element["title"]}",
                            style: TextStyle(
                                fontSize: 13
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: _height(2),),
                        Container(
                            width: _width(60),
                            child: Row(
                              children: [
                                Text(
                                  "Challenge: ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "${element["type"]}",
                                  style: TextStyle(
                                      fontSize: 13
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Spacer(),
                                Text(
                                  "Points: ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "${element["points"]}",
                                  style: TextStyle(
                                      fontSize: 13
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(width: _width(3))
                              ],
                            )
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                )
            )
        );
      });
    }else{
      children.add(
          Container(
              height: _height(15),
              width: _width(100),
              margin: EdgeInsets.only(bottom: _height(2), left: _height(1), right:_height(1)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                      color: Colors.lightGreen,
                      width: 2
                  )
              ),
              child: Center(
                  child: Text("No History",
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 15
                      )
                  )
              )
          )
      );
    }
    return children;
  }
}