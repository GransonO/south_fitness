import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/steps/duration.dart' as DurationPage;
import 'package:south_fitness/pages/steps/duration.dart';

import '../common.dart';

class Interests extends StatefulWidget {
  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {

  SharedPreferences prefs;
  int num = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
            height: _height(100),
            width: _width(100),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: _height(9)),
                      InkWell(
                        onTap: () {
                          setState(() {
                            num = 1;
                          });
                          _goToInterests("Cross Fit");
                        },
                        child: Center(
                          child: Container(
                            height: _height(7),
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
                              child: Text(
                                "Cross-fit",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            num = 2;
                          });
                          _goToInterests("Dance Fusion");
                        },
                        child: Center(
                          child: Container(
                            height: _height(7),
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
                              child: Text(
                                "Dance Fusion",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            num = 3;
                          });
                          _goToInterests("Yoga");
                        },
                        child: Center(
                          child: Container(
                            height: _height(7),
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
                              child: Text(
                                "Yoga",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            num = 4;
                          });
                          _goToInterests("Running");
                        },
                        child: Center(
                          child: Container(
                            height: _height(7),
                            width: _width(80),
                            margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color:_selectColor(4),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey
                                )
                            ),
                            child: Center(
                              child: Text(
                                "Running",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            num = 5;
                          });
                          _goToInterests("Cycling");
                        },
                        child: Center(
                          child: Container(
                            height: _height(7),
                            width: _width(80),
                            margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: _selectColor(5),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey
                                )
                            ),
                            child: Center(
                              child: Text(
                                "Cycling",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            num = 6;
                          });
                          _goToInterests("Walking");
                        },
                        child: Center(
                          child: Container(
                            height: _height(7),
                            width: _width(80),
                            margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: _selectColor(6),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey
                                )
                            ),
                            child: Center(
                              child: Text(
                                "Walking",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            num = 7;
                          });
                          _goToInterests("Mental Challenge");
                        },
                        child: Center(
                          child: Container(
                            height: _height(7),
                            width: _width(80),
                            margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: _selectColor(7),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey
                                )
                            ),
                            child: Center(
                              child: Text(
                                "Mental Challenge",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Center(
                          child: Container(
                            height: _height(7),
                            width: _width(80),
                            margin: EdgeInsets.only(right: _width(2), top: _height(5)),
                            child: Text(
                              "Step 3",
                              textAlign: TextAlign.left,
                            ),
                          )
                      ),
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
                              width: _width(60),
                              child: Text(
                                "Select your Discipline",
                                style: TextStyle(
                                    fontSize: 16
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: _width(60),
                              child: Text(
                                "Help us tailor the experience to you",
                                style: TextStyle(
                                    fontSize: 13
                                ),
                                textAlign: TextAlign.left,
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

  _goToInterests(value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("interest", value);
    Timer(Duration(seconds: 1), () => Common().newActivity(context, TrainDuration()));
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
