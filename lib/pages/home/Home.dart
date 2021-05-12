import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/home/sessions.dart';
import 'package:south_fitness/pages/home/suggested_details.dart';
import 'package:south_fitness/pages/run/dailyRun.dart';
import 'package:south_fitness/services/net.dart';

import '../common.dart';
import 'SuggestedActivities.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeView> {
  var displayState = "home";

  var username = "";
  var email = "";
  var user_id = "";
  SharedPreferences prefs;
  var dayName = "";
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1619738022/South_Fitness/user.png";

  bool serviceEnabled;
  LocationPermission permission;

  double currentLong;
  double currentLat;
  bool loading = true;


  bool showFuture = false;
  bool showPast = false;

  var allVideos = [];
  var allPastActivities = [];
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
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      dayName = DateFormat('EEEE').format(DateTime.now());
    });

    setPrefs();
    checkUsage();
    permissions();
  }

  permissions() async {
    bool camera = await Permission.camera.isGranted;
    bool microphone = await Permission.microphone.isGranted;
    bool phone = await Permission.phone.isGranted;
    bool storage = await Permission.storage.isGranted;
    bool activityRecognition = await Permission.activityRecognition.isGranted;
    if (!camera) {
      await Permission.camera.request();
    }
    if (!microphone) {
      await Permission.microphone.request();
    }
    if (!phone) {
      await Permission.phone.request();
    }
    if (!storage) {
      await Permission.storage.request();
    }
    if (!activityRecognition) {
      await Permission.activityRecognition.request();
    }
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    var upcomingVideos = await HomeResources().getVideos();

    print("----------User Id is ----------------------------- $user_id");

    var pastActivities = await HomeResources().getTodayActivities(user_id);
    setState(() {
      username = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image");
      user_id = prefs.getString("user_id");
      prefs.setBool("isLoggedIn", true);
      allVideos = upcomingVideos;
      loading = false;
      allPastActivities = pastActivities;
    });
  }

  void checkUsage() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a network.
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please enable your location",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (serviceEnabled) {
        // is locations enabled
        Position currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          serviceEnabled = true;
          currentLat = currentLocation.latitude;
          currentLong = currentLocation.longitude;
        });

        SharedPreferences authPrefs = await SharedPreferences.getInstance();
        authPrefs.setDouble("startLatitude", currentLat);
        authPrefs.setDouble("startLongitude", currentLong);

      } else {
        //Enable location
        Fluttertoast.showToast(
            msg: "Please enable your location",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Timer(Duration(seconds: 3), () => checkUsage());
      }
    } else {
      // No connectivity
      Fluttertoast.showToast(
          msg: "Please check your internet connection",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Timer(Duration(seconds: 3), () => checkUsage());
    }
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
                        Container(
                          width: _width(100),
                          child: Text(
                            "Hello, $username",
                            style: TextStyle(
                                fontSize: 13
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: _height(2),),

                        Container(
                          width: _width(100),
                          child: Text(
                            "Today's routine",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: _height(3),),

                        Container(
                            width: _width(100),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: (){
                                    verifyDateRange("Monday");
                                  },
                                  child: Container(
                                    height: _height(7),
                                    width: _width(12),
                                    decoration: BoxDecoration(
                                      color: compareDate("Monday", displayDates("Monday")),
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
                                            "${displayDates("Monday")}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: compareText("Monday")
                                            ),
                                          ),
                                          Text(
                                            "Mon",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: compareText("Monday")
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: (){
                                    verifyDateRange("Tuesday");
                                  },
                                  child: Container(
                                    height: _height(7),
                                    width: _width(12),
                                    decoration: BoxDecoration(
                                      color: compareDate("Tuesday", displayDates("Tuesday")),
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
                                            "${displayDates("Tuesday")}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: compareText("Tuesday")
                                            ),
                                          ),
                                          Text(
                                            "Tue",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              color: compareText("Tuesday")
                                          ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: (){
                                    verifyDateRange("Wednesday");
                                  },
                                  child: Container(
                                    height: _height(7),
                                    width: _width(12),
                                    decoration: BoxDecoration(
                                      color: compareDate("Wednesday", displayDates("Wednesday")),
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
                                            "${displayDates("Wednesday")}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: compareText("Wednesday")
                                            ),
                                          ),
                                          Text("Wed", style: TextStyle(
                                              fontSize: 12,
                                              color: compareText("Wednesday"),
                                              fontWeight: FontWeight.bold),),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: (){
                                    verifyDateRange("Thursday");
                                  },
                                  child: Container(
                                    height: _height(7),
                                    width: _width(12),
                                    decoration: BoxDecoration(
                                      color: compareDate("Thursday", displayDates("Thursday")),
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
                                            "${displayDates("Thursday")}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: compareText("Thursday")
                                            ),
                                          ),
                                          Text("Thu", style: TextStyle(fontSize: 12,color: compareText("Thursday"), fontWeight: FontWeight.bold),),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: (){
                                    verifyDateRange("Friday");
                                  },
                                  child: Container(
                                    height: _height(7),
                                    width: _width(12),
                                    decoration: BoxDecoration(
                                      color: compareDate("Friday", displayDates("Friday")),
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
                                            "${displayDates("Friday")}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: compareText("Friday")
                                            ),
                                          ),
                                          Text("Fri", style: TextStyle(fontSize: 12,
                                              color: compareText("Friday"), fontWeight: FontWeight.bold),),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: (){
                                    verifyDateRange("Saturday");
                                  },
                                  child: Container(
                                    height: _height(7),
                                    width: _width(12),
                                    decoration: BoxDecoration(
                                      color: compareDate("Saturday", displayDates("Saturday")),
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
                                            "${displayDates("Saturday")}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: compareText("Saturday")
                                            ),),
                                          Text("Sat", style: TextStyle(fontSize: 12,
                                              color: compareText("Saturday"), fontWeight: FontWeight.bold),),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: (){
                                    verifyDateRange("Sunday");
                                  },
                                  child: Container(
                                    height: _height(7),
                                    width: _width(12),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
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
                                          Text("${findLastDateOfTheWeek(DateTime.now()).day}", style: TextStyle(
                                            fontSize: 12,
                                          )),
                                          Text("Sun", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            )
                        ),
                        SizedBox(height: _height(3),),
                        showPast || showFuture ? Container() : Container(
                            height: _height(7),
                            width: _width(100),
                            child: Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Common().newActivity(context, DailyRun("Running", currentLat, currentLong));
                                    },
                                    child: Center(
                                      child: Container(
                                        height: _height(5.5),
                                        width: _width(27),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                            border: Border.all(color: Colors.green, width: 1)
                                        ),
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            Icon(Icons.directions_run, size: 27,),
                                            SizedBox(width: _width(2),),
                                            Text("Running", style: TextStyle(fontSize: 16),),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: (){
                                      Common().newActivity(context, DailyRun("Walking", currentLat, currentLong));
                                    },
                                    child: Center(
                                      child: Container(
                                        height: _height(5.5),
                                        width: _width(27),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                            border: Border.all(color: Colors.green, width: 1)
                                        ),
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            Icon(Icons.directions_walk, size: 27,),
                                            SizedBox(width: _width(2),),
                                            Text("Walking", style: TextStyle(fontSize: 16),),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: (){
                                      Common().newActivity(context, DailyRun("Cycling", currentLat, currentLong));
                                    },
                                    child: Center(
                                      child: Container(
                                        height: _height(5.5),
                                        width: _width(27),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                            border: Border.all(color: Colors.green, width: 1)
                                        ),
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            Icon(Icons.directions_bike, size: 27,),
                                            SizedBox(width: _width(2),),
                                            Text("Cycling", style: TextStyle(fontSize: 16),),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            )
                        ),
                        SizedBox(height: _height(3),),

                        allPastActivities.isNotEmpty ? Column(
                            children: displayTodayActivities(),
                        ) : Container(),

                        Container(
                          width: _width(100),
                          child: Text(
                            showPast ? "Past Activities" : showFuture ? "Scheduled Activities" : "Upcoming Activities",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: _height(3),),

                        loading ? Center(
                          child: SpinKitThreeBounce(
                            color: Colors.lightGreen,
                            size: 30,
                          ),
                        ) : Column(
                          children: displayThemVideos(),
                        ),
                        SizedBox(height: _height(3),),

                        Container(
                          width: _width(100),
                          child: Row(
                            children : [
                              Text(
                                "Suggested Activities",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Spacer(),
                              InkWell(
                                onTap: (){
                                  print("Clicked");
                                  Common().newActivity(context, SuggestedActivities());
                                },
                                child: Text(
                                  "See All",
                                  style: TextStyle(
                                      fontSize: 12
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ]
                          ),
                        ),
                        SizedBox(height: _height(3),),

                        loading ? Center(
                          child: SpinKitThreeBounce(
                            color: Colors.lightGreen,
                            size: 30,
                          ),
                        ) : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: displaySuggestions(),
                          ),
                        ),

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

  compareDate(dateString, passedDate){
    if(passedDate > DateTime.now().day){
      return Colors.white;
    }else{
      return dateString == dayName ? Colors.lightGreen : Color.fromARGB(255,233,244,226);
    }
  }

  compareText(dateString){
    return dateString == dayName ? Colors.white : Colors.black;
  }

  int displayDates(dayOfWeek){
    var day;
    switch(dayOfWeek){
      case "Monday":
        day = findFirstDateOfTheWeek(DateTime.now(), 1).day;
        break;
      case "Tuesday":
        day = findFirstDateOfTheWeek(DateTime.now(), 2).day;
        break;
      case "Wednesday":
        day = findFirstDateOfTheWeek(DateTime.now(), 3).day;
        break;
      case "Thursday":
        day = findFirstDateOfTheWeek(DateTime.now(), 4).day;
        break;
      case "Friday":
        day = findFirstDateOfTheWeek(DateTime.now(), 5).day;
        break;
      case "Saturday":
        day = findFirstDateOfTheWeek(DateTime.now(), 6).day;
        break;
      case "Sunday":
        day = findLastDateOfTheWeek(DateTime.now()).day;
        break;
    }
    return day;
  }

  DateTime getDayValue(dayOfWeek){
    var day;
    switch(dayOfWeek){
      case "Monday":
        day = findFirstDateOfTheWeek(DateTime.now(), 1);
        break;
      case "Tuesday":
        day = findFirstDateOfTheWeek(DateTime.now(), 2);
        break;
      case "Wednesday":
        day = findFirstDateOfTheWeek(DateTime.now(), 3);
        break;
      case "Thursday":
        day = findFirstDateOfTheWeek(DateTime.now(), 4);
        break;
      case "Friday":
        day = findFirstDateOfTheWeek(DateTime.now(), 5);
        break;
      case "Saturday":
        day = findFirstDateOfTheWeek(DateTime.now(), 6);
        break;
      case "Sunday":
        day = findLastDateOfTheWeek(DateTime.now());
        break;
    }
    return day;
  }

  verifyDateRange(dayOfWeek){
    if(getDayValue(dayOfWeek).day == DateTime.now().day){
      // Current day
      setState(() {
        showPast = false;
        showFuture = false;
      });
      return;
    }

    if(getDayValue(dayOfWeek).isBefore(DateTime.now())){
      setState(() {
        showPast = true;
        showFuture = false;
      });
    }else {
      setState(() {
        showFuture = true;
        showPast = false;
      });
    }
  }

  /// Find the first date of the week which contains the provided date.
  DateTime findFirstDateOfTheWeek(DateTime dateTime, int dayCount) {
    return dateTime.subtract(Duration(days: dateTime.weekday - dayCount));
  }

  /// Find last date of the week which contains provided date.
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  displayTodayActivities() {
    var children = <Widget>[];
    if(allPastActivities.isNotEmpty){
      children.add(
          Container(
            width: _width(100),
            margin: EdgeInsets.only(bottom: _height(1)),
            child: Text(
              "Today's Challenges",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.left,),
          )
      );
    }
    allPastActivities.forEach((element) {
      var imageUrl;
      switch(element["challengeType"]){
        case "Cycling":
          imageUrl = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1620142203/South_Fitness/bike.jpg";
          break;
        case "Running":
          imageUrl = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1620141989/South_Fitness/runner.jpg";
          break;
        case "Walking":
          imageUrl = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1620142299/South_Fitness/walking.jpg";
          break;
      }
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
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              child: Image.network(
                                "$imageUrl",
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
                        width: _width(68.5),
                        child: Text(
                          "You've completed today's ${element["challengeType"]} challenge",
                          style: TextStyle(
                              fontSize: 13
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: _height(2),),
                      Container(
                          width: _width(68.5),
                          child: Row(
                            children: [
                              Text(
                                "Distance: ",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "${element["distance"]} KM",
                                style: TextStyle(
                                    fontSize: 13
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Spacer(),
                              Text(
                                "Calories: ",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "${element["caloriesBurnt"]}".split(".")[0],
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
    return children;
  }

  displayThemVideos() {
    var children = <Widget>[];
    if(allPastActivities.isNotEmpty){
      children.add(
          Container(
            width: _width(100),
            margin: EdgeInsets.only(bottom: _height(1)),
            child: Text(
              "Upcoming Events",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.left,),
          )
      );
    }
    allVideos.forEach((element) {
      if(element["scheduledTime"] != null){
        children.add(
            InkWell(
              onTap: (){
                Common().newActivity(
                    context,
                    Session(
                        element["type"],
                        element["video_url"],
                        element["video_id"],
                        element["participants"],
                        element["title"].toString().replaceAll(" ", "_"),
                        Common().getDateTimeDifference("${element["scheduledDate"]} ${element["scheduledTime"]}")
                    ));
              },
              child: Container(
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
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  child: Image.network(
                                    "${element["image_url"]}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                      SizedBox(width: _width(4),),
                      Column(
                        children: [
                          Spacer(),
                          Container(
                            width: _width(40),
                            child: Text(
                              element["title"],
                              style: TextStyle(
                                  fontSize: 14
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: _height(2),),
                          Container(
                              width: _width(40),
                              child: Row(
                                children: [
                                  Text(
                                    "Trainer: ",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    element["instructor"],
                                    style: TextStyle(
                                        fontSize: 13
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )
                          ),
                          Spacer(),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Spacer(),
                          Container(
                            child: Text(
                              "${dateTimeString("${element["scheduledDate"]} ${element["scheduledTime"]}")}",
                              style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontSize: 12
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Spacer(),
                          Container(
                              width: _width(10),
                              child: Text(
                                "${convertDateTime("${element["scheduledDate"]} ${element["scheduledTime"]}")}",
                                style: TextStyle(
                                    color: Colors.lightGreen,
                                    fontSize: 10
                                ),
                                textAlign: TextAlign.left,
                              )
                          ),
                          Spacer(),
                        ],
                      ),
                    ],
                  )
              ),
            )
        );
      }
    });
    return children;
  }

  displaySuggestions() {
    var children = <Widget>[];
    var anotherList = [];
    if(activityList.length > 2){
      anotherList.add(activityList[0]);
      anotherList.add(activityList[1]);

      anotherList.forEach((element) {
        children.add(
            InkWell(
              onTap: (){
                Common().newActivity(context, SuggestedDetails(element));
              },
              child: Container(
                  height: _height(15),
                  width: _height(25),
                  margin: EdgeInsets.only(right: _width(4)),
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Image.network(
                            "${element["image"]}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            )
        );
      });
    }else{
      activityList.forEach((element) {
        children.add(
            InkWell(
              onTap: (){
                Common().newActivity(context, SuggestedDetails(element));
              },
              child: Container(
                  height: _height(15),
                  width: _height(25),
                  margin: EdgeInsets.only(right: _width(4)),
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Image.network(
                            "${element["image"]}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            )
        );
      });
    }
    return children;
  }

  convertDateTime(date) {
    DateTime lel = DateTime.parse(date);
    return DateFormat.jm().format(lel);
  }

  dateTimeString(date) {
    DateTime lel = DateTime.parse(date);
    return DateFormat.MMMMd().format(lel);
  }
}
