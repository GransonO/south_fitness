import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/services/net.dart';
import 'package:video_player/video_player.dart';

import '../common.dart';
import 'sessions.dart';

class ReadyVideo extends StatefulWidget {
  @override
  _ReadyVideoState createState() => _ReadyVideoState();
}

class _ReadyVideoState extends State<ReadyVideo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var username = "";
  var email = "";
  var user_id = "";
  SharedPreferences prefs;

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  var allVideos = [];
  var liveVideos = [];
  var scheduleVideos = [];
  var theElement = {};
  bool play = false;
  bool hasLive = false;
  bool showVideo = false;
  bool loading = true;
  bool joinLoader = false;
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1619738022/South_Fitness/user.png";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
    getVideos();
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image");
      user_id = prefs.getString("user_id");
    });
  }

  getVideos() async {
    var result = await HomeResources().getVideos();
    print("-----------------$result");
    setState(() {
      allVideos = result;
      liveVideos =  (allVideos.where((element) => element["isLive"] == true)).toList();
      scheduleVideos =  (allVideos.where((element) => element["isLive"] != true)).toList();
      loading = false;
      print("Live Videos----------------$liveVideos");
      print("Schedule Videos ---------------$scheduleVideos");
    });

    if(liveVideos.isNotEmpty){
      setState(() {
        hasLive = true;
      });
    }
  }

  initializeVideo(link) {
    _controller = VideoPlayerController.network(
      link,
    );
    _initializeVideoPlayerFuture = _controller.initialize();
  }


  convertDateTime(date) {
    var theTime = "2022-12-12 $date";
    var theDate =  DateTime.parse(theTime);
    return DateFormat('hh:mm aaa').format(theDate);
  }

  _displayScheduledClasses(){
    var children = <Widget>[];
    scheduleVideos.forEach((element){
      children.add(
        InkWell(
          onTap: () async {
            // check if joined class
            setState(() {
              joinLoader = true;
            });
            bool result = await HomeResources().joinConfirmChallenge(
              {
                "video_id": element["video_id"],
                "user_id": user_id
              }
            );
            print("video_id ------------------------------------ ${element["video_id"]}");
            setState(() {
              joinLoader = false;
            });
            if(result){
              print("result ------------------------------------ $result");
              // Has joined, take to session
              Common().newActivity(context,
                  Session(
                      element["type"],
                      element["video_url"],
                      element["video_id"],
                      element["participants"],
                      element["title"].toString().replaceAll(" ", "_"),
                      Common().getDateTimeDifference("${element["scheduledDate"]} ${element["scheduledTime"]}")
                  )
              );
            }else{
              setState(() {
                showVideo = true;
                theElement = element;
              });
              initializeVideo(theElement["video_url"]);
            }
          },
          child: Container(
            width: _width(45),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: _height(15),
                    width: _width(45),
                    child: Container(
                        height: _height(15),
                        width: _width(45),
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
                              width: _width(40),
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
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 8.0, top: 10.0),
                    child: Column(
                      children: [
                        Container(
                          width: _height(25),
                          child: Text(
                            "${element["title"]}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                            width: _height(25),
                            child: Row(
                              children: [
                                Text(
                                  "${element["duration"].toString().replaceAll("mins", "")} mins | ",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  element["isLive"] ? "In Progress" : "${convertDateTime(element["scheduledTime"])}",
                                  style: TextStyle(
                                      color: Colors.lightGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
    return children;
  }

  _displayLiveClasses(){
    var children = <Widget>[];
    liveVideos.forEach((element){
      print("ScheduledTime -----------------${element["scheduledTime"]}");
      children.add(
        InkWell(
          onTap: () async {
            // check if joined class
            setState(() {
              joinLoader = true;
            });
            bool result = await HomeResources().joinConfirmChallenge(
                {
                  "video_id": element["video_id"],
                  "user_id": user_id
                }
            );
            print("video_id ------------------------------------ ${element["video_id"]}");
            setState(() {
              joinLoader = false;
            });
            if(result){
              print("result ------------------------------------ $result");
              // Has joined, take to session
              Common().newActivity(context,
                  Session(
                      element["type"],
                      element["video_url"],
                      element["video_id"],
                      element["participants"],
                      element["title"].toString().replaceAll(" ", "_"),
                      Common().getDateTimeDifference("${element["scheduledDate"]} ${element["scheduledTime"]}")
                  )
              );
            }else{
              setState(() {
                showVideo = true;
                theElement = element;
              });
              initializeVideo(theElement["video_url"]);
            }
          },
          child: Container(
            margin: EdgeInsets.only(right: _width(2)),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: _height(15),
                    width: _width(40),
                    child: Container(
                        height: _height(15),
                        width: _width(40),
                        child: Stack(
                          children: [
                            Center(
                              child: SpinKitThreeBounce(
                                color: Colors.lightGreen,
                                size: 25,
                              ),
                            ),
                            Container(
                              height: _height(15),
                              width: _width(40),
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
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 8.0, top: 10.0),
                    child: Column(
                      children: [
                        Container(
                          width: _height(25),
                          child: Text(
                            "${element["title"]}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                            width: _height(25),
                            child: Row(
                              children: [
                                Text(
                                  "${element["duration"].toString().replaceAll("mins", "")} mins | ",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  element["isLive"] ? "In Progress" : "${convertDateTime(element["scheduledTime"])}",
                                  style: TextStyle(
                                      color: Colors.lightGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
    return children;
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
                margin: EdgeInsets.only(top: _height(9), left: _width(4), right: _width(1)),
                child: loading ? Center(
                  child: SpinKitThreeBounce(
                    color: Colors.lightGreen,
                    size: 30,
                  ),
                ) : Column(
                  children: [
                    Container(
                      width: _width(100),
                      child: Text(
                        "Fitness is the condition of being physically fit and healthy and involves attributes that include, mental acuity, cardio-respiratory endurance, muscular strength, muscular endurance, body composition, and flexibility",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: _height(3),),

                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Live Classes",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    hasLive ? Container(
                      width: _width(100),
                      margin: EdgeInsets.only(top: _height(2),),
                      child: GridView.builder(
                        padding: EdgeInsets.only( left: 5.0, right: 5.0,bottom: 10),
                        shrinkWrap: true,
                        itemCount: _displayLiveClasses().length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: getAspectRatio()),
                        itemBuilder: (context, index) {
                          final theItem = _displayLiveClasses()[index];

                          return theItem;

                        },
                      ),
                    ) : Container(
                      margin: EdgeInsets.only(right: _width(2), left: _width(2),top: _height(2),),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(15)
                        )
                      ),
                      child: Center(
                          child: Text(
                            "No Live Classes",
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14
                            ),
                          )
                      ),
                    ),

                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Scheduled Classes",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),

                    scheduleVideos.length > 0 ? Container(
                        width: _width(100),
                        margin: EdgeInsets.only(top: _height(2),),
                        child: GridView.builder(
                          padding: EdgeInsets.only( left: 5.0, right: 5.0,bottom: 10),
                          shrinkWrap: true,
                          itemCount: _displayScheduledClasses().length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: getAspectRatio()),
                          itemBuilder: (context, index) {
                            final theItem = _displayScheduledClasses()[index];
                            return theItem;
                          },
                        )
                    ) : Container(
                      margin: EdgeInsets.only(right: _width(2), left: _width(2),top: _height(2),),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(15)
                          )
                      ),
                      child: Center(
                          child: Text(
                            "No Scheduled Classes",
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14
                            ),
                          )
                      ),
                    ),

                    SizedBox( height: _height(8))
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
                  height: _height(65),
                  width: _width(100),
                  margin: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                  ),
                  child: Column(
                    children: [
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
                            var result = await HomeResources().joinChallenge(
                                {
                                  "video_id": theElement["video_id"],
                                  "user_id": user_id
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
                                      Common().getDateTimeDifference("${theElement["scheduledDate"]} ${theElement["scheduledTime"]}")
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
                              child: Text(
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
            joinLoader ? Center(
              child: SpinKitThreeBounce(
                color: Colors.lightGreen,
                size: 35,
              ),
            ) : Container()
          ],
        ),
      ),
      drawer: Common().navDrawer(context, username, email, "video", image),
    );
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }

  getAspectRatio(){
    var _screenWidth = MediaQuery.of(context).size.width;
    var theWidth = _screenWidth / 2;
    var cellHeight = _height(25);
    return theWidth /cellHeight;
  }

}
