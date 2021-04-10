import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/steps/interests.dart';

import '../common.dart';

class Goals extends StatefulWidget {
  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {

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
                            num = 5;
                          });
                          _goToInterests("Strength and Muscle building");
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
                                "Strength and Muscle building",
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
                            num = 1;
                          });
                          _goToInterests("Muscular endurance");
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
                                "Muscular endurance",
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
                          _goToInterests("Weight loss");
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
                                "Weight loss",
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
                          _goToInterests("Body toning");
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
                                "Body toning",
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
                          _goToInterests("Flexibility and body coordination");
                        },
                        child: Center(
                          child: Container(
                            height: _height(7),
                            width: _width(80),
                            margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: _selectColor(4),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey
                                )
                            ),
                            child: Center(
                              child: Text(
                                "Flexibility and body coordination",
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
                            "Step 2",
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
                      SizedBox(width: _width(3),),
                      Column(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.black, size: 35,),
                          Spacer()
                        ],
                      ),
                      SizedBox(width: _width(4),),
                      Container(
                        height: _height(5),
                        child: Column(
                          children: [
                            Container(
                              width: _width(60),
                              child: Text(
                                "Select your goal",
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
    prefs.setString("goal", value);
    Timer(Duration(seconds: 1), () => Common().newActivity(context, Interests()));
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
