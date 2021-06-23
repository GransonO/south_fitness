import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/services/net.dart';
import 'package:video_player/video_player.dart';

import '../common.dart';

class SuggestedDetails extends StatefulWidget {

  var data = {};
  SuggestedDetails(value){
    this.data = value;
  }

  @override
  _SuggestedDetailsState createState() => _SuggestedDetailsState(this.data);
}

class _SuggestedDetailsState extends State<SuggestedDetails> {


  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool play = false;
  var videoUrl = "https://res.cloudinary.com/dolwj4vkq/video/upload/v1612826611/South_Fitness/yoga.mp4";
  var title = "";
  var vidObj = {};
  bool joinLoader = false;
  var team = "";

  var username = "";
  var email = "";
  var user_id = "";
  SharedPreferences prefs;
  var dayName = "";
  bool joined = false;
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";

  _SuggestedDetailsState(value){
    videoUrl = value["videoUrl"];
    title = value["title"];
    vidObj = value;
    print("The Vids Object ----------------------------------------------------> $vidObj");
    _controller = VideoPlayerController.network(videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

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
      team = prefs.getString("team");
      user_id = prefs.getString("user_id");
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                      "${vidObj["details"]}",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(height: _height(5),),

                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          "$title",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Spacer(),
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
                                          alignment: Alignment.bottomLeft,
                                          child: InkWell(
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
                                                child: play ? Icon(Icons.pause_circle_filled, color: Colors.lightGreen, size: 50,) : Icon(Icons.play_circle_filled_sharp, color: Colors.lightGreen, size: 50,),
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width: _width(100),
                                    height: _height(17),
                                    margin: EdgeInsets.only(bottom: _height(1)),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[350],
                                        borderRadius: BorderRadius.all(Radius.circular(15))
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: _width(2)),
                                        Container(
                                          height: _height(20),
                                          width: _width(25),
                                          child: Column(
                                            children: [
                                              SizedBox(height: _height(2)),
                                              Container(
                                                width: _width(30),
                                                child: Text("Duration", style: TextStyle(
                                                    fontSize: 11
                                                )),
                                              ),
                                              Container(
                                                width: _width(30),
                                                child: Text("${vidObj["duration"]} ${vidObj["duration_ext"]}", style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                )),
                                              ),
                                              Spacer(),
                                              Container(
                                                width: _width(30),
                                                child: Text("Category", style: TextStyle(
                                                    fontSize: 11
                                                )),
                                              ),
                                              Container(
                                                width: _width(30),
                                                child: Text("${vidObj["type"]}", style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                )),
                                              ),
                                              SizedBox(height: _height(2)),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          height: _height(20),
                                          width: _width(30),
                                          child: Column(
                                            children: [
                                              SizedBox(height: _height(2)),
                                              Container(
                                                width: _width(30),
                                                child: Text("Workouts per week", style: TextStyle(
                                                    fontSize: 11
                                                )),
                                              ),
                                              Container(
                                                width: _width(30),
                                                child: Text("${vidObj["sets"]} workouts", style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                )),
                                              ),
                                              Spacer(),
                                              Container(
                                                width: _width(30),
                                                child: Text("Equipment needed", style: TextStyle(
                                                    fontSize: 11
                                                )),
                                              ),
                                              Container(
                                                width: _width(30),
                                                child: Text("${vidObj["equip"]} Equipment", style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12
                                                )
                                                ),
                                              ),
                                              SizedBox(height: _height(2)),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          height: _height(20),
                                          width: _width(25),
                                          child: Column(
                                            children: [
                                              SizedBox(height: _height(2)),
                                              Container(
                                                width: _width(30),
                                                child: Text("Fitness level", style: TextStyle(
                                                    fontSize: 11
                                                )),
                                              ),
                                              Container(
                                                width: _width(30),
                                                child: Text("${vidObj["level"]}", style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                )),
                                              ),
                                              Spacer(),
                                              SizedBox(height: _height(2)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: _width(2)),
                                      ],
                                    ),
                                  ),

                                  SizedBox( height: _height(5)),
                                  joined ? Container() : Center(
                                    child: InkWell(
                                      onTap: () async {
                                        setState(() {
                                          joinLoader = true;
                                        });
                                        var result = await HomeResources().joinLiveClass(
                                            {
                                              "activity_id": vidObj["activity_id"],
                                              "user_id": user_id,
                                              "user_department": team,
                                              "username": username
                                            }
                                        );
                                        setState(() {
                                          joinLoader = false;
                                        });
                                        if(result){
                                          joined = true;
                                          Fluttertoast.showToast(
                                              msg: "Joining success. You shall receive notifications from this challenge",
                                            backgroundColor: Colors.lightGreen,
                                            textColor: Colors.white
                                          );
                                        }else{
                                          joined = false;
                                          Fluttertoast.showToast(
                                              msg: "Joining failed. "
                                                  "Contact Admin for assistance",
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: _height(5),
                                        width: _width(80),
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(255,110,180,63),
                                            borderRadius: BorderRadius.all(Radius.circular(15))
                                        ),
                                        child: Center(
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
                                  SizedBox( height: _height(8))
                                ],
                              ),
                            ),
                          ),
                        ]
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
              ]
          ),
        ),
      ),
      drawer: Common().navDrawer(context, username, email, "home", image),
    );
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }
}
