/*
*  Created by Granson O.
*  Copyright © 2018 South fitness. All rights reserved.
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/auth/login.dart';
import 'package:south_fitness/pages/challenges/gym.dart';
import 'package:south_fitness/pages/challenges/all_activities.dart';
import 'package:south_fitness/pages/chats/chats.dart';
import 'package:south_fitness/pages/history/history.dart';
import 'package:south_fitness/pages/profile/Dashboard.dart';
import 'package:south_fitness/pages/home/Home.dart';
import 'package:south_fitness/pages/blogs/Notes.dart';
import 'package:south_fitness/pages/home/video.dart';

import 'home/performance.dart';

class Common{

  /// Find the first date of the week which contains the provided date.
  DateTime findFirstDateOfTheWeek(DateTime dateTime, int dayCount) {
    return dateTime.subtract(Duration(days: dateTime.weekday - dayCount));
  }

  /// Find last date of the week which contains provided date.
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  int displayDateOfWeek(dayOfWeek){
    var day;
    switch(dayOfWeek){
      case "Monday":
        day = findFirstDateOfTheWeek(DateTime.now(), 0).day;
        break;
      case "Tuesday":
        day = findFirstDateOfTheWeek(DateTime.now(), 1).day;
        break;
      case "Wednesday":
        day = findFirstDateOfTheWeek(DateTime.now(), 2).day;
        break;
      case "Thursday":
        day = findFirstDateOfTheWeek(DateTime.now(), 3).day;
        break;
      case "Friday":
        day = findFirstDateOfTheWeek(DateTime.now(), 4).day;
        break;
      case "Saturday":
        day = findFirstDateOfTheWeek(DateTime.now(), 5).day;
        break;
      case "Sunday":
        day = findFirstDateOfTheWeek(DateTime.now(), 5).day;
        break;
    }
    return day;
  }

  newActivity(context, page){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (myContext) => page
      ),
    );
  }

  dateStringFormatter(dateTimeString) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(dateTimeString);
    var formattedDate = DateFormat('EEE d MMM, yy hh:mm aaa').format(dateTime);
    return formattedDate;
  }

  dateStringHistory(DateTime dateTimeString) {
    var formattedDate = DateFormat('yyyy-MM-dd').format(dateTimeString).toString();
    return formattedDate;
  }


  timeStringFormatter(dateTimeString) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(dateTimeString);
    var formattedDate = DateFormat('hh:mm aaa').format(dateTime);
    return formattedDate;
  }

  getDateTimeDifference(date){
    var theDate =  DateTime.parse(date);
    var diff = theDate.difference(DateTime.now()).inMinutes;
    return diff;
  }

  logoOnBar(BuildContext context, img){
    return Container(
      height: componentHeight(context, 10),
      width: componentWidth(context, 30),
      margin: EdgeInsets.only(top: componentHeight(context, 2)),
      child: Image.network(
        img,
        fit: BoxFit.contain,
      ),
    );
  }

  componentWidth(BuildContext context, size) {
    return MediaQuery
        .of(context)
        .size
        .width * (size / 100);
  }

  componentHeight(BuildContext context, size) {
    return MediaQuery
        .of(context)
        .size
        .height * (size / 100);
  }

  roundedContainer(radius, coloring){
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        color: coloring
    );
  }

  navDrawer(BuildContext context, username, email, state, image){
    return Drawer(
      elevation: 20,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: componentHeight(context, 15),
            width: componentWidth(context, 100),
            margin: EdgeInsets.only(left: 10, top: componentHeight(context, 2)),
            padding: EdgeInsets.only(left: 10, top: 15),
            child: Row(
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      height: componentHeight(context, 7),
                      width: componentHeight(context, 7),
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: Theme
                              .of(context)
                              .platform == TargetPlatform.iOS
                              ? Colors.white : Colors.lightGreenAccent,
                          size: 20,
                        ),
                      ),
                    ),
                    Container(
                        height: componentHeight(context, 7),
                        width: componentHeight(context, 7),
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.cover, image: new NetworkImage("$image")
                            )
                        )
                    ),
                  ],
                ),
                SizedBox(width: 10,),
                Container(
                  height: componentHeight(context, 4.5),
                  child: Column(
                    children: [
                      Container(
                        width: componentWidth(context, 50),
                          child: Text("$username")
                      ),
                      Spacer(),
                      Container(
                          width: componentWidth(context, 50),
                          child: Text(
                              "$email",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12
                            ),
                          )
                      )
                    ]
                  )
                )
              ],
            ),
          ),
          ListTile(
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/home.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "home"),
                ),
              ),
              title: Text('Home',
                style: TextStyle(
                    color: _colorScheme(state == "home")
                ),),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, HomeView());
              }),
          ListTile(
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/video.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "video"),
                ),
              ),
              title: Text('Live Classes',
                style: TextStyle(
                    color: _colorScheme(state == "video")
                ),),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, ReadyVideo());
              }),
          ListTile(
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/health.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "notes"),
                ),
              ),
              title: Text('Health Tips',
                style: TextStyle(
                    color: _colorScheme(state == "notes")
                ),),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, Notes());
              }),
          ListTile(
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/history.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "history"),
                ),
              ),
              title: Text(
                'History',
                style: TextStyle(
                    color: _colorScheme(state == "history")
                ),
              ),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, History());
              }),
          ListTile(
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/listx.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "list"),
                ),
              ),
              title: Text('Leadersboard',
                style: TextStyle(
                    color: _colorScheme(state == "list")
                ),),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, Performance());
              }),
          ListTile(
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/profile.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "profile"),
                ),
              ),
              title: Text('Profile',
                style: TextStyle(
                    color: _colorScheme(state == "profile")
                ),),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, Dashboard());
              }),
          ListTile(
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/chats.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "clubs"),
                ),
              ),
              title: Text('Chats',
                style: TextStyle(
                    color: _colorScheme(state == "clubs")
                ),),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, Chats());
              }),
          // ListTile(
          //     tileColor: Colors.white,
          //     leading: Container(
          //       height: componentHeight(context, 2.5),
          //       width: componentHeight(context, 2.5),
          //       child: SvgPicture.asset(
          //         'assets/images/nav/dumbbell.svg',
          //         fit: BoxFit.fill,
          //         color: _colorScheme(state == "gym"),
          //       ),
          //     ),
          //     title: Text('Gym',
          //       style: TextStyle(
          //           color: _colorScheme(state == "gym")
          //       ),),
          //     onTap: (){
          //       Navigator.pop(context);
          //       newActivity(context, Gym());
          //     }),
          // ListTile(
          //     tileColor: Colors.white,
          //     leading: Container(
          //       height: componentHeight(context, 2.5),
          //       width: componentHeight(context, 2.5),
          //       child: SvgPicture.asset(
          //         'assets/images/nav/goal.svg',
          //         fit: BoxFit.fill,
          //         color: _colorScheme(state == "activities"),
          //       ),
          //     ),
          //     title: Text('Activities',
          //       style: TextStyle(
          //           color: _colorScheme(state == "activities")
          //       ),),
          //     onTap: (){
          //       Navigator.pop(context);
          //       newActivity(context, AllActivities());
          //     }),
          // ListTile(
          //     tileColor: Colors.white,
          //     leading: Container(
          //       height: componentHeight(context, 2.5),
          //       width: componentHeight(context, 2.5),
          //       child: SvgPicture.asset(
          //         'assets/images/nav/medical.svg',
          //         fit: BoxFit.fill,
          //         color: _colorScheme(state == "history"),
          //       ),
          //     ),
          //     title: Text('Google Health'),
          //     onTap: (){
          //       Navigator.pop(context);
          //       newActivity(context, GoogleHealth());
          //     }),
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
              height: componentHeight(context, 10),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    SizedBox(width: componentWidth(context, 5)),
                    Icon(Icons.power_settings_new,
                        color: Colors.black),
                    SizedBox(width: componentWidth(context, 7)),
                    Text('Logout'),
                  ]
                ),
              ),
                ),
          ),
        ],
      ),
    );

  }

  handleSignOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false);
  }
  
  _colorScheme(value){
    return value ? Colors.lightGreen : Colors.black45;
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }
    return string[0].toUpperCase() + string.substring(1);
  }

}