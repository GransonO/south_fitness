import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/home/sessions.dart';

import '../common.dart';

class AllActivities extends StatefulWidget {
  @override
  _AllActivitiesState createState() => _AllActivitiesState();
}

class _AllActivitiesState extends State<AllActivities> {

  var username = "";
  var email = "";
  SharedPreferences prefs;

  bool joined = false;
  String status = "Challenges";
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1619738022/South_Fitness/user.png";
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
      username = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image") != null ? prefs.getString("image") : image;
    });
  }

  var activitiesList = ["Challenges", "TBT", "Fit for 2020", "Karura Run"];

  var activities = [ {
      "image": "https://res.cloudinary.com/dolwj4vkq/image/upload/v1617256436/South_Fitness/video_images/IMG-20210131-WA0000.jpg",
      "title": "June Cold Challenge",
      "time": "45 mins",
      "videoUrl": "https://res.cloudinary.com/dolwj4vkq/video/upload/v1617255977/South_Fitness/VID-20210122-WA0012.mp4",
      "category": "TBT"
    }, {
      "image": "https://res.cloudinary.com/dolwj4vkq/image/upload/v1617201729/South_Fitness/suggested_activities/Rectangle_28.png",
      "title": "Step It Up",
      "time": "45 mins",
      "videoUrl": "https://res.cloudinary.com/dolwj4vkq/video/upload/v1612826611/South_Fitness/cross.mp4",
      "category": "TBT"
    }, {
      "image": "https://res.cloudinary.com/dolwj4vkq/image/upload/v1617201729/South_Fitness/suggested_activities/Rectangle_28.png",
      "title": "Cross World Fit",
      "time": "45 mins",
      "videoUrl": "https://res.cloudinary.com/dolwj4vkq/video/upload/v1617255977/South_Fitness/VID-20210122-WA0012.mp4",
      "category": "Fit for 2020"
    }, {
      "image": "https://res.cloudinary.com/dolwj4vkq/image/upload/v1617256436/South_Fitness/video_images/IMG-20210131-WA0000.jpg",
      "title": "10 Sunday Run Challenge",
      "time": "45 mins",
      "videoUrl": "https://res.cloudinary.com/dolwj4vkq/video/upload/v1612826611/South_Fitness/cross.mp4",
      "category": "Karura Run"
    }];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: _height(9)),
                child: Column(
                  children: [
                    SizedBox(height: _height(3),),
                    Container(
                      margin: EdgeInsets.only(left: _width(4), right: _width(4)),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: displayActivitiesTitles()
                        ),
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
                          children: displayActivities()
                        )
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
      drawer: Common().navDrawer(context, username, email, "activities", image),
    );
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }

  displayActivitiesTitles() {
    var children = <Widget>[];
    activitiesList.forEach((element) {
      children.add(InkWell(
          onTap: (){
            setState(() {
             status = element;
            });
          },
          child: Text(
            "$element",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: status == element ? Colors.green : Colors.black
            ),
            textAlign: TextAlign.left,
          ),
        ));
      children.add(SizedBox(width: 10,));
      children.add(Text("|",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.left,
        ),);
      children.add(SizedBox(width: 10,));
    });

    return children;
  }

  displayActivities() {
    var children = <Widget>[];
    if(status == "Challenges"){
      activities.forEach((element) {
        children.add(SizedBox(height: _height(3)));
        children.add(InkWell(
          onTap: (){
            Common().newActivity(context, Session(
                element["title"],
                element["videoUrl"],
                "27354",
                "",
                "TBT_CHANNEL",
                Common().getDateTimeDifference("${element["scheduledDate"]} ${element["scheduledTime"]}")
            )
            );
          },
          child: Container(
              height: _height(30),
              width: _height(100),
              margin: EdgeInsets.only(bottom: _height(3)),
              child: Stack(
                children: [
                  Center(
                    child: SpinKitThreeBounce(
                      color: Colors.lightGreen,
                      size: 20,
                    ),
                  ),
                  Container(
                    height: _height(30),
                    width: _height(100),
                    child: ClipRRect(
                      child: Image.network(
                        element["image"],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        margin: EdgeInsets.only(top: _height(10.5)),
                        color: Colors.white,
                        height: _height(6),
                        width: _height(100),
                        child: Column(
                            children: [
                              Spacer(),
                              Container(
                                margin: EdgeInsets.only(left: _width(2)),
                                width: _height(100),
                                child: Text(element["category"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Spacer(),
                              Container(
                                margin: EdgeInsets.only(left: _width(2)),
                                width: _height(100),
                                child: Text(element["title"], style: TextStyle(
                                    fontSize: 11
                                ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Spacer(),
                            ]
                        )
                    ),
                  )
                ],
              )
          ),
        ));
      });
    }else{
      activities.forEach((element) {
        if(element["category"] == status){
          children.add(SizedBox(height: _height(3)));
          children.add(InkWell(
            onTap: (){
              Common().newActivity(context, Session(
                  element["title"],
                  element["videoUrl"],
                  "27354",
                  "",
                  "TBT_CHANNEL",
                  Common().getDateTimeDifference("${element["scheduledDate"]} ${element["scheduledTime"]}")
              )
              );
            },
            child: Container(
                height: _height(30),
                width: _height(100),
                margin: EdgeInsets.only(bottom: _height(3)),
                child: Stack(
                  children: [
                    Center(
                      child: SpinKitThreeBounce(
                        color: Colors.lightGreen,
                        size: 20,
                      ),
                    ),
                    Container(
                      height: _height(30),
                      width: _height(100),
                      child: ClipRRect(
                        child: Image.network(
                          element["image"],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          margin: EdgeInsets.only(top: _height(10.5)),
                          color: Colors.white,
                          height: _height(6),
                          width: _height(100),
                          child: Column(
                              children: [
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.only(left: _width(2)),
                                  width: _height(100),
                                  child: Text(element["category"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.only(left: _width(2)),
                                  width: _height(100),
                                  child: Text(element["title"], style: TextStyle(
                                      fontSize: 11
                                  ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Spacer(),
                              ]
                          )
                      ),
                    )
                  ],
                )
            ),
          ));
        }
      });
    }

    return children;
  }

}