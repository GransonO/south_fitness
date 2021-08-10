import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/steps/duration.dart';

import '../common.dart';

class Interests extends StatefulWidget {
  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {

  SharedPreferences prefs;
  List items = [];
  List selectedItems = [];
  List selectedNums = [];
  Color mainColor = Colors.white;

  setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var institutePrimaryColor = prefs.getString("institute_primary_color");
      List colors = institutePrimaryColor.split(",");
      mainColor = Color.fromARGB(255,int.parse(colors[0]),int.parse(colors[1]),int.parse(colors[2]));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
    items = ["Cross Fit","Dance Fusion","Yoga", "Running","Cycling", "Walking", "Mental Challenge"];
  }

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

                      _displayOptions(),
                      Center(
                        child: Container(
                            height: _height(7),
                            width: _width(80),
                            margin: EdgeInsets.only(top: _height(3)),
                            child: Row(
                              children: [
                                Text(
                                  "Step 3.",
                                  style: TextStyle(
                                      fontSize: 15
                                  ),
                                ),
                                Spacer(),

                                InkWell(
                                  onTap: () async {
                                    if(selectedNums.isEmpty){
                                      Fluttertoast.showToast(
                                          msg: "Please select your discipline",
                                          textColor: Colors.white,
                                          backgroundColor: mainColor
                                      );
                                    }else{

                                      prefs = await SharedPreferences.getInstance();
                                      _goToTrainDuration(selectedItems.toString(), prefs);
                                    }
                                  },
                                  child: Container(
                                    height: _height(7),
                                    width: _width(40),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: mainColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Next",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
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

  _goToTrainDuration(value, prefs){
    prefs.setString("interest", value);
    print("++++++++++++++++++++++++++++++++++ Interests");
    Common().newActivity(context, TrainDuration());
  }

  _displayOptions(){
    var theChildren = <Widget>[];

    items.forEach((element) {
      theChildren.add(
        InkWell(
          onTap: () {
            setState(() {
              if(selectedItems.contains(element)){
                selectedItems.remove(element);
                selectedNums.remove(items.indexOf(element));
              }else{
                selectedItems.add(element);
                selectedNums.add(items.indexOf(element));
              }
            });
          },
          child: Center(
            child: Container(
              height: _height(7),
              width: _width(80),
              margin: EdgeInsets.only(right: _width(2), top: _height(2)),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  color: _selectColor(items.indexOf(element)),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                      width: 0.5,
                      color: Colors.grey
                  )
              ),
              child: Center(
                child: Text(
                  element,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });

    return Column(
      children: theChildren,
    );
  }

  _selectColor(count){
    if(selectedNums.contains(count)){
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
