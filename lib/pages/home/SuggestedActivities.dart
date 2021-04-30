import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/workouts/warmUps.dart';
import 'package:south_fitness/pages/workouts/workouts.dart';

import '../common.dart';
import 'suggested_details.dart';

class SuggestedActivities extends StatefulWidget {
  @override
  _SuggestedActivitiesState createState() => _SuggestedActivitiesState();
}

class _SuggestedActivitiesState extends State<SuggestedActivities> {


  SharedPreferences prefs;
  var username = "";
  var email = "";
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
      image = prefs.getString("image");
    });
  }

  var activityList = [
    {
      "image": "https://res.cloudinary.com/dolwj4vkq/image/upload/v1617201729/South_Fitness/suggested_activities/Rectangle_28.png",
      "title": "Cardio",
      "time": "45 mins",
      "videoUrl": "https://res.cloudinary.com/dolwj4vkq/video/upload/v1612826611/South_Fitness/cross.mp4"
    },
    {
      "image": "https://res.cloudinary.com/dolwj4vkq/image/upload/v1617201725/South_Fitness/suggested_activities/Rectangle_29.png",
      "title": "Feel Good",
      "time": "45 mins",
      "videoUrl": "https://res.cloudinary.com/dolwj4vkq/video/upload/v1612826609/South_Fitness/dance.mp4"
    },
    {
      "image": "https://res.cloudinary.com/dolwj4vkq/image/upload/v1617201729/South_Fitness/suggested_activities/Rectangle_40.png",
      "title": "Yoga Time",
      "time": "45 mins",
      "videoUrl": "https://res.cloudinary.com/dolwj4vkq/video/upload/v1612826609/South_Fitness/yoga.mp4"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          height: _height(100),
          width: _width(100),
          child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: _height(9),),
                      Container(
                        margin: EdgeInsets.only(left: _width(4), right: _width(4)),
                        width: _width(100),
                        child: Text(
                          "Suggested Activities",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: _height(3),),
                      Container(
                        margin: EdgeInsets.only(left: _width(4), right: _width(4)),
                        child: activityList.length > 0 ? displaySuggestions() : Center(
                            child: Container(
                              margin: EdgeInsets.only(top: _height(20)),
                              child: Text("No New Activities"),
                            )
                        ),
                      ),
                    ],
                  )
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
              ]
          ),
        ),
      ),
      drawer: Common().navDrawer(context, username, email, "list", image),
    );
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }

  displaySuggestions(){
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var theWidth = _screenWidth / 2;
    var cellHeight = _height(20);
    var _aspectRatio = theWidth /cellHeight;
    return Container(
        child: GridView.builder(
          padding: EdgeInsets.only(bottom: 10),
          shrinkWrap: true,
          itemCount: activityList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _crossAxisCount,childAspectRatio: _aspectRatio),
          itemBuilder: (context, index) {
            final theItem = activityList[index];

            return  InkWell(
              onTap: (){
                Common().newActivity(context, SuggestedDetails(theItem));
              },
              child: Container(
                  height: _height(15),
                  width: _height(25),
                  margin: EdgeInsets.only(right: _width(4), bottom: _height(3)),
                  child: Stack(
                    children: [
                      Center(
                        child: SpinKitThreeBounce(
                          color: Colors.lightGreen,
                          size: 20,
                        ),
                      ),
                      Container(
                        height: _height(15),
                        width: _height(25),
                        child: ClipRRect(
                          child: Image.network(
                            "${theItem["image"]}",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: _height(10.5)),
                        color: Colors.white70,
                        height: _height(4),
                        width: _height(25),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: _width(2)),
                              width: _height(25),
                              child: Text("${theItem["title"]}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                              ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(left: _width(2)),
                              width: _height(25),
                              child: Text("${theItem["time"]}", style: TextStyle(
                                fontSize: 11
                              ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ]
                        )
                      )
                    ],
                  )
              ),
            );

          },
        )
    );
  }
}
