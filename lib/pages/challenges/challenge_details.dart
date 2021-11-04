import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/services/net.dart';
import 'package:video_player/video_player.dart';

import '../common.dart';

class ChallengeDetails extends StatefulWidget {

  var element = {};
  bool isJoined = false;
  ChallengeDetails(theElement, joined){
    element = theElement;
    isJoined = joined;
  }

  @override
  _ChallengeDetailsState createState() => _ChallengeDetailsState(element, isJoined);
}

class _ChallengeDetailsState extends State<ChallengeDetails> {

  var username = "";
  var email = "";
  var user_id = "";
  var team = "";
  bool isJoined = false;

  bool joinLoader = false;
  late SharedPreferences prefs;
  Color mainColor = Colors.white;
  var img = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";

  bool all = true;
  bool joined = false;
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool play = false;
  bool loadingState = true;
  var theElement = {};

  _ChallengeDetailsState(element, joined){
    theElement = element;
    isJoined = joined;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
    initializeVideo(theElement["video_url"]);
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      email = prefs.getString("email")!;
      image = prefs.getString("image")!;
      user_id = prefs.getString("user_id")!;
      team = prefs.getString("team")!;
      img = prefs.getString("institute_logo")!;
      var institutePrimaryColor = prefs.getString("institute_primary_color");
      List colors = institutePrimaryColor!.split(",");
      mainColor = Color.fromARGB(255,int.parse(colors[0]),int.parse(colors[1]),int.parse(colors[2]));
      loadingState = false;
    });
  }

  initializeVideo(link) {
    setState(() {
      _controller = VideoPlayerController.network(
        link,
      );
      _initializeVideoPlayerFuture = _controller.initialize();
    });
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
                margin: EdgeInsets.only(top: _height(9)),
                child: Column(
                  children: [
                    SizedBox(height: _height(3),),
                    Container(
                      width: _width(100),
                      margin: EdgeInsets.only(
                          left: _width(4), right: _width(4)),
                      child: Text(
                        "Challenge Details",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.green
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: _height(2)),
                    Container(
                      height: _height(100),
                      padding: EdgeInsets.only(
                          left: _width(4), right: _width(4)),
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
                              width: _width(100),
                              margin: EdgeInsets.only(left: 10, right: 10),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: _height(1),),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: _width(25),
                                            child: Text(
                                              "Title",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          ),
                                          Container(
                                              width: _width(25),
                                              child: Text("${theElement["title"]}",
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
                                                "${theElement["level"]}",
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
                                                "${theElement["duration"]} ${theElement["duration_ext"]}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),)
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: _height(2),),
                                  Column(
                                    children: [
                                      Container(
                                        width: _width(100),

                                        child: Text(
                                          "Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: _width(100),
                                          child: Text("${theElement["details"]}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                  SizedBox(height: _height(2),),
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
                                if(!isJoined){
                                  var result = await HomeResources().joinListedActivity(
                                      {
                                        "challenge_id": theElement["challenge_id"],
                                        "user_id": user_id,
                                        "user_department": team,
                                        "username": username,
                                        "points": 10
                                      }
                                  );
                                  setState(() {
                                    joinLoader = false;
                                  });
                                  if(result){
                                    Fluttertoast.showToast(msg: "Joined Challenge, You shall receive notifications from this challenge");
                                    setState(() {
                                      isJoined = true;
                                    });
                                  }else{
                                    Fluttertoast.showToast(msg: "Could not join the Challenge. Try again later");
                                  }
                                }else{
                                  // Exit challenge
                                  var result = await HomeResources().exitListedActivity(
                                      {
                                        "challenge_id": theElement["challenge_id"],
                                        "user_id": user_id
                                      }
                                  );
                                  setState(() {
                                    joinLoader = false;
                                  });
                                  if(result){
                                    Fluttertoast.showToast(msg: "Exited Challenge, You shall NOT receive notifications from this challenge");
                                    setState(() {
                                      isJoined = false;
                                    });
                                  }else{
                                    Fluttertoast.showToast(msg: "Could not exit the Challenge. Try again later");
                                  }
                                }
                              },
                              child: Container(
                                height: _height(5),
                                width: _width(100),
                                margin: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    color: isJoined ? Colors.red : Color.fromARGB(255,110,180,63),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: isJoined ? Center(
                                  child: joinLoader ? SpinKitThreeBounce(color: Colors.white, size: 25,) : Text(
                                    "Exit challenge",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ) : Center(
                                  child: joinLoader ? SpinKitThreeBounce(color: Colors.white, size: 25,) : Text(
                                    "Join challenge",
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
                    onTap: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    child: Icon(
                      Icons.menu, size: 30, color: mainColor,),
                  ),
                  SizedBox(width: _width(4),),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Common().navDrawer(context, username, email, "challenges", image),
    );
  }

  _height(size) {
    return Common().componentHeight(context, size);
  }

  _width(size) {
    return Common().componentWidth(context, size);
  }

}