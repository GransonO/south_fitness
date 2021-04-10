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
import 'package:south_fitness/pages/challenges/challenges.dart';
import 'package:south_fitness/pages/challenges/gym.dart';
import 'package:south_fitness/pages/challenges/tbt_challenges.dart';
import 'package:south_fitness/pages/chats/chats.dart';
import 'package:south_fitness/pages/history/history.dart';
import 'package:south_fitness/pages/profile/Dashboard.dart';
import 'package:south_fitness/pages/home/Home.dart';
import 'package:south_fitness/pages/blogs/Notes.dart';
import 'package:south_fitness/pages/home/video.dart';
import 'package:south_fitness/pages/run/history.dart';

import 'home/performance.dart';

class Common{

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
    var formattedDate = DateFormat.yMEd().add_jms().format(dateTime);
    return formattedDate;
  }

  logoOnBar(BuildContext context){
    return Container(
      height: componentHeight(context, 7),
      width: componentWidth(context, 40),
      child: Image.asset(
        "assets/images/logo.png",
        fit: BoxFit.cover,
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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: componentHeight(context, 15),
            width: componentWidth(context, 100),
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
            tileColor: Colors.white,
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/home.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "home"),
                ),
              ),
              title: Text('Home'),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, HomeView());
              }),
          ListTile(
              tileColor: Colors.white,
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/video.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "video"),
                ),
              ),
              title: Text('Videos'),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, ReadyVideo());
              }),
          ListTile(
              tileColor: Colors.white,
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/notes.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "notes"),
                ),
              ),
              title: Text('Health Tips'),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, Notes());
              }),
          ListTile(
              tileColor: Colors.white,
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/list.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "list"),
                ),
              ),
              title: Text('Leaders board'),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, Performance());
              }),
          ListTile(
              tileColor: Colors.white,
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/user.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "profile"),
                ),
              ),
              title: Text('Profile'),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, Dashboard());
              }),
          ListTile(
              tileColor: Colors.white,
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/clubs.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "clubs"),
                ),
              ),
              title: Text('Safaricom Sports Clubs'),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, Chats());
              }),
          ListTile(
              tileColor: Colors.white,
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/dumbbell.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "gym"),
                ),
              ),
              title: Text('Gym'),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, Gym());
              }),
          ListTile(
              tileColor: Colors.white,
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/goal.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "tbt"),
                ),
              ),
              title: Text('TBT'),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, TBT());
              }),
          ListTile(
              tileColor: Colors.white,
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/goal.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "challenges"),
                ),
              ),
              title: Text('Fit for 2020'),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, Challenges());
              }),
          ListTile(
              tileColor: Colors.white,
              leading: Container(
                height: componentHeight(context, 2.5),
                width: componentHeight(context, 2.5),
                child: SvgPicture.asset(
                  'assets/images/nav/medical.svg',
                  fit: BoxFit.fill,
                  color: _colorScheme(state == "history"),
                ),
              ),
              title: Text('Medical History'),
              onTap: (){
                Navigator.pop(context);
                newActivity(context, History());
              }),
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
    return value ? Colors.lightGreen : Colors.grey;
    
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }
    return string[0].toUpperCase() + string.substring(1);
  }

}