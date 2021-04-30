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
    print("------- activityRecognition ------------------------ $activityRecognition");
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
    var upcomingVideos = await HomeResources().getVideos();
    setState(() {
      username = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image");
      prefs.setBool("isLoggedIn", true);
      allVideos = upcomingVideos;
      loading = false;
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
                                      color: compareDate("Monday"),
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          Text(
                                            "${displayDates("Monday")}",
                                            style: TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          Text("Mon", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
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
                                      color: compareDate("Tuesday"),
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          Text(
                                            "${displayDates("Tuesday")}",
                                            style: TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          Text("Tue", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
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
                                      color: compareDate("Wednesday"),
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          Text(
                                            "${displayDates("Wednesday")}",
                                            style: TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          Text("Wed", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
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
                                      color: compareDate("Thursday"),
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          Text(
                                            "${displayDates("Thursday")}",
                                            style: TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          Text("Thu", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
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
                                      color: compareDate("Friday"),
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          Text(
                                            "${displayDates("Friday")}",
                                            style: TextStyle(
                                                fontSize: 12
                                            ),
                                          ),
                                          Text("Fri", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
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
                                      color: compareDate("Saturday"),
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          Text(
                                            "${displayDates("Saturday")}",
                                            style: TextStyle(
                                                fontSize: 12
                                            ),),
                                          Text("Sat", style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
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
                                          Text("${findLastDateOfTheWeek(DateTime.now()).day}", style: TextStyle(fontSize: 12,)),
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

  compareDate(dateString){
    return dateString == dayName ? Colors.lightGreen : Color.fromARGB(255,233,244,226);
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
    // print("============== ${getDayValue(dayOfWeek).isBefore(DateTime.now())}");
    // print("++++++++++++++ ${getDayValue(dayOfWeek).isAfter(DateTime.now())}");
    print("++++++++++++++ ${(getDayValue(dayOfWeek).day == DateTime.now().day)}");

    if(getDayValue(dayOfWeek).isBefore(DateTime.now())){
      setState(() {
        showPast = true;
        showFuture = false;
      });
    }else if(getDayValue(dayOfWeek).isAfter(DateTime.now())){
      setState(() {
        showFuture = true;
        showPast = false;
      });
    }else if(getDayValue(dayOfWeek).day == DateTime.now().day){
      setState(() {
        showFuture = false;
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

  displayThemVideos() {
    var children = <Widget>[];
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
                                  fontSize: 16
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
                                    "Trainer:",
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
