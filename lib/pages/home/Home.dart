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
import 'package:video_player/video_player.dart';

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
  var team = "";
  SharedPreferences prefs;
  var dayName = "";
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";

  bool serviceEnabled;
  LocationPermission permission;

  double currentLong;
  double currentLat;
  bool loading = true;


  bool showFuture = false;
  bool showPast = false;
  bool showVideo = false;
  var startTime = DateTime.now();

  var allVideos = [];
  var allPastActivities = [];
  var activityList = [];

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool play = false;
  bool joinLoader = false;
  var theElement = {};

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
    var suggestions = await HomeResources().getSuggestedActivities();
    var upcomingVideos = await HomeResources().getVideos(Common().displayDateOfWeek(DateFormat('EEEE').format(DateTime.now())));

    var pastActivities = await HomeResources().getTodayActivities(user_id);
    setState(() {
      username = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image");
      user_id = prefs.getString("user_id");
      team = prefs.getString("team");
      prefs.setBool("isLoggedIn", true);
      allVideos = upcomingVideos;
      activityList = suggestions;
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

  initializeVideo(link) {
    setState(() {
      _controller = VideoPlayerController.network(
        link,
      );
      _initializeVideoPlayerFuture = _controller.initialize();
    });
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
                                  onTap: () async {
                                    verifyDateRange("Monday", displayDates("Monday"));
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
                                  onTap: () async {
                                    verifyDateRange("Tuesday", displayDates("Tuesday"));
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
                                  onTap: () async {
                                    verifyDateRange("Wednesday", displayDates("Wednesday"));
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
                                  onTap: () async {
                                    verifyDateRange("Thursday", displayDates("Thursday"));
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
                                  onTap: () async {
                                    verifyDateRange("Friday", displayDates("Friday"));
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
                                  onTap: () async {
                                    verifyDateRange("Saturday", displayDates("Saturday"));
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
                                  onTap: () async {
                                    verifyDateRange("Sunday", displayDates("Sunday"));
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
                                    onTap: () async {
                                      bool locationIsGranted = await Permission.location.isGranted;
                                      if (!locationIsGranted) {
                                        await Permission.camera.request();
                                      }else{
                                        Common().newActivity(context, DailyRun("Running", currentLat, currentLong));
                                      }
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
                                    onTap: () async {
                                      bool locationIsGranted = await Permission.location.isGranted;
                                      if (!locationIsGranted) {
                                        await Permission.camera.request();
                                      }else{
                                        Common().newActivity(context, DailyRun("Walking", currentLat, currentLong));
                                      }
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
                                    onTap: () async {
                                      bool locationIsGranted = await Permission.location.isGranted;
                                      if (!locationIsGranted) {
                                        await Permission.camera.request();
                                      }else{
                                        Common().newActivity(context, DailyRun("Cycling", currentLat, currentLong));
                                      }
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
                            showPast ? "Past Live Classes" : showFuture ? "Scheduled Live Classes" : "Upcoming Live Classes",
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
                                "Suggested Classes",
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
                                  Common().newActivity(context, SuggestedActivities(activityList));
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
                showVideo ? Container(
                  height: _height(100),
                  width: _width(100),
                  color: Color.fromARGB(150, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: _height(67),
                      width: _width(100),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: _width(3), top: _width(2)),
                            child: Row(
                              children: [
                                Spacer(),
                                InkWell(
                                    onTap: (){
                                      setState(() {
                                        showVideo = !showVideo;
                                      });
                                    },
                                    child: Icon(
                                      Icons.close_outlined,
                                      color: Colors.lightGreen,
                                    )
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: _width(70),
                            width: _width(90),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  child: Container(
                                    height: _width(70),
                                    width: _width(90),
                                    margin: EdgeInsets.only(top: _height(2), bottom: _height(4)),
                                    child: FutureBuilder(
                                      future: _initializeVideoPlayerFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          // If the VideoPlayerController has finished initialization, use
                                          // the data it provides to limit the aspect ratio of the VideoPlayer.
                                          return AspectRatio(
                                            aspectRatio: _controller.value.aspectRatio,
                                            // Use the VideoPlayer widget to display the video.
                                            child: VideoPlayer(_controller),
                                          );
                                        } else {
                                          // If the VideoPlayerController is still initializing, show a
                                          // loading spinner.
                                          return Center(child: CircularProgressIndicator());
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        InkWell(
                                            onTap: (){
                                              setState(() {
                                                // If the video is playing, pause it.
                                                if (_controller.value.isPlaying) {
                                                  play = false;
                                                  _controller.pause();
                                                } else {
                                                  play = true;
                                                  // If the video is paused, play it.
                                                  _controller.play();
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: play ? Icon(Icons.pause_circle_filled, color: Colors.lightGreen, size: 40,) : Icon(Icons.play_circle_filled_sharp, color: Colors.lightGreen, size: 40,),
                                            )
                                        ),
                                        Spacer(),
                                      ],
                                    )
                                )
                              ],
                            ),
                          ),
                          SizedBox( height: _height(2)),

                          Container(
                              height: _height(15),
                              width: _width(100),
                              margin: EdgeInsets.only(left: 10, right: 10),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Column(
                                children: [
                                  Spacer(),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: _width(25),
                                            child: Text(
                                              "Coach Name",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          ),
                                          Container(
                                              width: _width(25),
                                              child: Text(theElement["instructor"],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),
                                              )
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        children: [
                                          Container(
                                            width: _width(25),
                                            child: Text(
                                              "Fitness level",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          ),
                                          Container(
                                              width: _width(25),
                                              child: Text(
                                                "5",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),)
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        children: [
                                          Container(
                                            width: _width(25),
                                            child: Text(
                                              "Duration",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          ),
                                          Container(
                                              width: _width(25),
                                              child: Text(
                                                theElement["duration"],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),)
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: _width(25),
                                            child: Text(
                                              "Category",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          ),
                                          Container(
                                              width: _width(25),
                                              child: Text(theElement["type"],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),
                                              )
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              )
                          ),
                          SizedBox( height: _height(2)),

                          Center(
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  joinLoader = true;
                                });
                                var result = await HomeResources().joinLiveClass(
                                    {
                                      "activity_id": theElement["video_id"],
                                      "user_id": user_id,
                                      "user_department": team,
                                      "username": username
                                    }
                                );
                                setState(() {
                                  joinLoader = false;
                                });
                                if(result){
                                  Common().newActivity(context,
                                      Session(
                                          theElement["type"],
                                          theElement["video_url"],
                                          theElement["video_id"],
                                          theElement["participants"],
                                          theElement["title"].toString().replaceAll(" ", "_"),
                                          Common().getDateTimeDifference("${theElement["scheduledDate"]} ${theElement["scheduledTime"]}"),
                                          theElement
                                      )
                                  );
                                }else{
                                  Fluttertoast.showToast(msg: "Could not join the class. Try again later");
                                }
                              },
                              child: Container(
                                height: _height(5),
                                width: _width(100),
                                margin: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255,110,180,63),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Center(
                                  child: joinLoader ? SpinKitThreeBounce(color: Colors.white, size: 25,) : Text(
                                    "Join class",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ) : Container(),
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

  verifyDateRange(dayOfWeek, passedDate) async {
    setState(() {
      loading= true;
    });
    var date = "${startTime.year}-${startTime.month}-$passedDate";
    if(getDayValue(dayOfWeek).day == DateTime.now().day){
      var queriedVids = await HomeResources().getDateActivities(date);
      // Current day
      setState(() {
        allVideos = queriedVids;
        showPast = false;
        showFuture = false;
        loading= false;
      });
      return;
    }

    if(getDayValue(dayOfWeek).isBefore(DateTime.now())){
      var queriedVids = await HomeResources().getDateActivities(date);
      setState(() {
        allVideos = queriedVids;
        showPast = true;
        showFuture = false;
        loading= false;
      });
    }else {
      var queriedVids = await HomeResources().getDateActivities(date);
      setState(() {
        allVideos = queriedVids;
        showFuture = true;
        showPast = false;
        loading= false;
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

    if(allVideos.isEmpty){
      children.add(
        Container(
            height: _height(15),
            width: _width(100),
            margin: EdgeInsets.all(_height(1)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                color: Colors.lightGreen,
                width: 2
              )
            ),
            child: Center(
                child: Text("No Activities Scheduled Today",
                    style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 15
                    )
                )
            )
        )
      );
    }else{
      allVideos.forEach((element) {
        if(element["scheduledTime"] != null){
          var timeString = '${element["scheduledDate"]}T${element["scheduledTime"]}';
          var dateTime = DateTime.parse(timeString);
          if(dateTime.isAfter(DateTime.now())){
            children.add(
                InkWell(
                  onTap: (){
                    setState(() {
                      theElement = element;
                      showVideo = true;
                    });
                    initializeVideo(element["video_url"]);
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
        }
      });

      if(children.isEmpty){
        children.add(
            Container(
                height: _height(15),
                width: _width(100),
                margin: EdgeInsets.all(_height(1)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                        color: Colors.lightGreen,
                        width: 2
                    )
                ),
                child: Center(
                    child: Text("No Activities Scheduled Today",
                        style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 15
                        )
                    )
                )
            )
        );
      }
    }

    return children;
  }

  displaySuggestions() {
    var children = <Widget>[];
    if(activityList.length > 0){
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
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                          child: Image.network(
                            "${element["image_url"]}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: _height(15),
                        width: _height(25),
                        child: Column(
                          children: [
                            Spacer(),
                            Container(
                              color: Colors.black54,
                              width: _height(25),
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  element["title"],
                                style: TextStyle(
                                  color: Colors.white
                                ),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )
                      ),
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
              width: _width(90),
              margin: EdgeInsets.all(_height(1)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                      color: Colors.lightGreen,
                      width: 2
                  )
              ),
              child: Center(
                  child: Text("No Suggested Activities",
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 15
                      )
                  )
              )
          )
      );
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
