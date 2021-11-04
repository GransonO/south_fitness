import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/home/Home.dart';
import 'package:south_fitness/services/net.dart';

import '../common.dart';

class TrainDuration extends StatefulWidget {
  @override
  _DurationState createState() => _DurationState();
}

class _DurationState extends State<TrainDuration> {

  int num = 0;
  bool loading = false;
  bool loadingState = true;
  Color mainColor = Colors.white;

  setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var institutePrimaryColor = prefs.getString("institute_primary_color");
      List colors = institutePrimaryColor!.split(",");
      mainColor = Color.fromARGB(255,int.parse(colors[0]),int.parse(colors[1]),int.parse(colors[2]));
      loadingState = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Column(
                    children: [
                      SizedBox(height: _height(9)),
                      InkWell(
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState(() {
                            num = 1;
                          });
                          _goToDuration(1, prefs);
                        },
                        child: Center(
                          child: Container(
                            height: _height(10),
                            width: _width(80),
                            margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: _selectColor(1),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey
                                )
                            ),
                            child: Center(
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Text(
                                      "0-1 workouts",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "I'm a little rusty",
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState(() {
                            num = 2;
                          });
                          _goToDuration(4, prefs);
                        },
                        child: Center(
                          child: Container(
                            height: _height(10),
                            width: _width(80),
                            margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: _selectColor(2),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey
                                )
                            ),
                            child: Center(
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Text(
                                      "2-4 workouts",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "I'm regular",
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState(() {
                            num = 3;
                          });
                          _goToDuration(5, prefs);
                        },
                        child: Center(
                          child: Container(
                            height: _height(10),
                            width: _width(80),
                            margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: _selectColor(3),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey
                                )
                            ),
                            child: Center(
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Text(
                                      "5+ workouts",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "I'm ready for anything",
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                      loading ? Center(
                        child: Container(
                          height: _height(10),
                          width: _width(80),
                          margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                          padding: EdgeInsets.only(left: 10),
                          child: Center(
                              child: Column(
                                children: [
                                  Spacer(),
                                  SpinKitThreeBounce(color: mainColor, size: 30,),
                                  Spacer(),
                                ],
                              )
                          ),
                        ),
                      ) : Container(),
                    ],
                  ),
                ),
                Container(
                  height: _height(7),
                  margin: EdgeInsets.only(top: _height(1)),
                  child: Row(
                    children: [
                      SizedBox(width: _width(5),),
                      Container(
                        height: _height(5),
                        child: Column(
                          children: [
                            Container(
                              width: _width(80),
                              child: Text(
                                "How often do you do your workouts",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: _width(80),
                              child: Text(
                                "We will use this to recommend workouts",
                                style: TextStyle(
                                    fontSize: 13
                                ),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }


  _goToDuration(value, prefs) async {
    prefs.setInt("duration", value);

    setState(() {
      loading = true;
    });
    var result = await Authentication().addProfileInfo();
    setState(() {
      loading = false;
    });
    if(result["success"]){
      prefs.setString("user_id", result["user_id"]);
      Common().newActivity(context, HomeView());
    }else{
      Fluttertoast.showToast(msg: "Profile Update failed");
    }
  }


  _selectColor(count){
    if(count == num){
      return Color.fromARGB(255,233,244,226);
    }else{
      return Colors.white;
    }
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }
}

