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
  var team = "";
  SharedPreferences prefs;

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  var allVideos = [];
  var liveVideos = [];
  var scheduleVideos = [];
  var theElement = {};
  bool play = false;
  bool showVideo = false;
  bool loading = true;
  bool loadingState = true;
  bool joinLoader = false;
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";

  Color mainColor = Colors.white;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
    getVideos();
  }
  var img = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image");
      user_id = prefs.getString("user_id");
      team = prefs.getString("team");
      img = prefs.getString("institute_logo");
      var institutePrimaryColor = prefs.getString("institute_primary_color");
      List colors = institutePrimaryColor.split(",");
      mainColor = Color.fromARGB(255,int.parse(colors[0]),int.parse(colors[1]),int.parse(colors[2]));
      loadingState = false;
    });
  }

  getVideos() async {
    List result = await HomeResources().getVideos(Common().displayDateOfWeek(DateFormat('EEEE').format(DateTime.now())));
    print("-----------------$result");
    setState(() {
      scheduleVideos = result.where((element) => element["isLive"] == false).toList();
      loading = false;
      liveVideos = result.where((element) => element["isLive"] == true).toList();
      print("Schedule Videos ---------------$scheduleVideos");
    });

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
              showVideo = true;
              theElement = element;
            });
            initializeVideo(theElement["video_url"]);
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
                                color: mainColor,
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
                                      color: mainColor,
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
      children.add(
        InkWell(
          onTap: () async {
            // check if joined class
            setState(() {
              showVideo = true;
              theElement = element;
            });
            initializeVideo(theElement["video_url"]);
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
                                color: mainColor,
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
                                      color: mainColor,
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
        child: loadingState ? Container(
          height: _height(100),
          width: _width(100),
          child: Center(
            child: SpinKitThreeBounce(
              color: Colors.grey,
              size: 30,
            ),
          ),
        ) : Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: _height(9), left: _width(4), right: _width(1)),
                child: loading ? Center(
                  child: SpinKitThreeBounce(
                    color: mainColor,
                    size: 30,
                  ),
                ) : Column(
                  children: [
                    SizedBox(height: _height(3)),

                    liveVideos.isNotEmpty ? Container(
                      child: Row(
                        children: [
                          Text(
                            "In progress",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Spacer(),
                        ],
                      ),
                    ) : Container(),
                    liveVideos.isNotEmpty ? Container(
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
                        )
                    ) : Container(),

                    Container(
                      width: _width(100),
                      margin: EdgeInsets.only(bottom: _height(2)),
                      child: Text(
                        "Upcoming Classes",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    scheduleVideos.isNotEmpty ? Container(
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
                      height: _height(15),
                      margin: EdgeInsets.only(right: _width(2), left: _width(2),top: _height(2),bottom: _height(2),),
                      child: Center(
                          child: Text(
                            "No Classes",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                                fontWeight: FontWeight.bold
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
                                color: mainColor,
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
                                          child: play ? Icon(Icons.pause_circle_filled, color: mainColor, size: 40,) : Icon(Icons.play_circle_filled_sharp, color: mainColor, size: 40,),
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
                                        "Schedule Time",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: _width(25),
                                        child: Text(
                                          "${theElement["scheduledTime"]}",
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
                                          "${theElement["duration"].toString().replaceAll("mins", "")} mins",
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
                                color: mainColor,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Center(
                              child: Text(
                                "View class",
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
                color: mainColor,
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
