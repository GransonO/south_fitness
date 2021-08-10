import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/challenges/challenge_details.dart';
import 'package:south_fitness/pages/home/sessions.dart';
import 'package:south_fitness/services/net.dart';

import '../common.dart';

class AllActivities extends StatefulWidget {
  @override
  _AllActivitiesState createState() => _AllActivitiesState();
}

class _AllActivitiesState extends State<AllActivities> {

  var username = "";
  var email = "";
  var user_id = "";
  var img = "";
  SharedPreferences prefs;

  bool joined = false;
  bool isLoading = false;
  String status = "Challenges";
  Color mainColor = Colors.white;
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
  }

  setPrefs() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image") != null ? prefs.getString("image") : image;
      user_id = prefs.getString("user_id");

      img = prefs.getString("institute_logo");
      var institutePrimaryColor = prefs.getString("institute_primary_color");
      List colors = institutePrimaryColor.split(",");
      mainColor = Color.fromARGB(255,int.parse(colors[0]),int.parse(colors[1]),int.parse(colors[2]));
    });
    getActivities(user_id);
  }

  List activitiesList = [];
  List activities = [];
  List joinedActivities = [];

  getActivities(userId) async {
    print("userId --------------------------- $userId");
    var results = await HomeResources().getAllListedActivities();
    print("results --------------------------- $results");

    List joinedChallenges = await PerformanceResource().getUserPerformance(userId);
    print("joinedChallenges --------------------------- $joinedChallenges");

    List joinedResults = joinedChallenges.map((e) => e["challenge_id"]).toList();
    print("joinedResults --------------------------- $joinedResults");
    setState(() {
      isLoading = false;
      activities = results;
      activitiesList = (activities.map((e) => e["type"])).toList();
      joinedActivities = (activities.where((e) => joinedResults.contains(e["challenge_id"]))).toList();
      print("joinedActivities --------------------------- $joinedActivities");
    });
  }

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
                      width: _width(100),
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
                      height: _height(85),
                      width: _width(100),
                      padding: EdgeInsets.only(left: _width(4), right: _width(4)),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: isLoading ? [Container()] : displayActivities()
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
                  Common().logoOnBar(context, img),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Icon(Icons.menu, size: 30, color: mainColor,),
                  ),
                  SizedBox(width: _width(4),),
                ],
              ),
            ),
            isLoading ? Center(
              child: SpinKitThreeBounce(
                color: mainColor,
                size: 50,
              ),
            ) : Container()
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

    children.add(InkWell(
      onTap: (){
        setState(() {
          status = "Challenges";
        });
      },
      child: Text(
        "Challenges",
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: status == "Challenges" ? mainColor : Colors.black
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

    children.add(InkWell(
      onTap: (){
        setState(() {
          status = "Joined";
        });
      },
      child: Text(
        "Joined",
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: status == "Joined" ? mainColor : Colors.black
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
                color: status == element ? mainColor : Colors.black
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
      if(activities.isNotEmpty){
        activities.forEach((element) {
          children.add(SizedBox(height: _height(3)));
          children.add(
              InkWell(
                onTap: (){
                  Common().newActivity(context, ChallengeDetails(element, false));
                },
                child: Container(
                    height: _height(30),
                    width: _height(100),
                    margin: EdgeInsets.only(bottom: _height(3)),
                    child: Stack(
                      children: [
                        Center(
                          child: SpinKitThreeBounce(
                            color: mainColor,
                            size: 20,
                          ),
                        ),
                        Container(
                          height: _height(30),
                          width: _height(100),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight:  Radius.circular(15.0)),
                            child: Image.network(
                              element["image_url"],
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
                                      child: Text(
                                        element["type"],
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
              )
          );
        });
      }else{
        children.add(
            Container(
              height: _height(15),
              margin: EdgeInsets.only(right: _width(2), left: _width(2),top: _height(10),bottom: _height(2),),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(15)
                  ),
                  border: Border.all(
                      color: mainColor,
                      width: 2
                  )
              ),
              child: Center(
                  child: Text(
                    "No Joined Challenge",
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
              )
         );
      }
    }else if(status == "Joined"){
      if(joinedActivities.isNotEmpty){
        joinedActivities.forEach((element) {
          children.add(SizedBox(height: _height(3)));
          children.add(
              InkWell(
                onTap: (){
                  Common().newActivity(context, ChallengeDetails(element, true));
                },
                child: Container(
                    height: _height(30),
                    width: _height(100),
                    margin: EdgeInsets.only(bottom: _height(3)),
                    child: Stack(
                      children: [
                        Center(
                          child: SpinKitThreeBounce(
                            color: mainColor,
                            size: 20,
                          ),
                        ),
                        Container(
                          height: _height(30),
                          width: _height(100),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight:  Radius.circular(15.0)),
                            child: Image.network(
                              element["image_url"],
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
                                      child: Text(
                                        element["type"],
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
              )
          );
        });
      }else{
        children.add(
            Container(
              height: _height(15),
              margin: EdgeInsets.only(right: _width(2), left: _width(2),top: _height(10),bottom: _height(2),),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(15)
                  ),
                  border: Border.all(
                      color: mainColor,
                      width: 2
                  )
              ),
              child: Center(
                  child: Text(
                    "No Joined Challenge",
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            )
        );
      }
    }else{
      if(activities.isNotEmpty){
        activities.forEach((element) {
          if(element["type"] == status){
            children.add(SizedBox(height: _height(3)));
            children.add(InkWell(
              onTap: (){
                Common().newActivity(context, ChallengeDetails(element, false));
              },
              child: Container(
                  height: _height(30),
                  width: _height(100),
                  margin: EdgeInsets.only(bottom: _height(3)),
                  child: Stack(
                    children: [
                      Center(
                        child: SpinKitThreeBounce(
                          color: mainColor,
                          size: 20,
                        ),
                      ),
                      Container(
                        height: _height(30),
                        width: _height(100),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight:  Radius.circular(15.0)),
                          child: Image.network(
                            element["image_url"],
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
                                    child: Text(element["type"],
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
      }else{
        children.add(
            Container(
              height: _height(15),
              margin: EdgeInsets.only(right: _width(2), left: _width(2),top: _height(10),bottom: _height(2),),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(15)
                  ),
                  border: Border.all(
                      color: mainColor,
                      width: 2
                  )
              ),
              child: Center(
                  child: Text(
                    "No Joined Challenge",
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            )
        );
      }
    }

    return children;
  }

}