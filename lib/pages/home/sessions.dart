import 'package:agora_rtc_engine/rtc_engine.dart' as rtc_engine_x;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/video_call/videoPlayer.dart' as videoStuff;
import 'package:south_fitness/services/net.dart';
import 'package:video_player/video_player.dart';

import '../common.dart';

class Session extends StatefulWidget {
  var type = "";
  var link = "";
  var id = "";
  var participants = "";
  Session(value, url, uid, all){
    type = value;
    link = url;
    id = uid;
    participants = all;
  }
  @override
  _SessionState createState() => _SessionState(type, link, id, participants);
}

class _SessionState extends State<Session> {

  bool rateVideo = false;
  bool endurance = false;
  bool speed = false;
  bool agility = false;
  bool play = false;
  var team = "";
  var type = "";
  bool personal = false;

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  SharedPreferences prefs;
  var username = "";
  var email = "";
  var link = "";
  var uid = "";
  var participants = [];
  var videoCall = {};
  bool showCall = false;

  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1565367393/jade/profiles/user.jpg";

  _SessionState(value, url, id, all){
    type = value;
    link = url;
    uid = id;
    participants = all.split(",");
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      link,
    );

    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
    getTeam();
    getVideoCallDetails();
  }

  getTeam() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      team = prefs.getString("team").trim().toLowerCase();
      username = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image");
    });
  }

  getVideoCallDetails() async {
    // Fetch the passed video detail
    var videoData = await HomeResources().getVideoCallDetails(uid);
    setState(() {
      videoCall = videoData;
      if(videoCall["video_call_token"] != null){
        // call exists
        showCall = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                child: Container(
                  margin: EdgeInsets.only(top: _height(9), left: _width(4), right: _width(4)),
                  child: Column(
                    children: [
                      Container(
                        width: _width(100),
                        child: Text(
                          "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in as some form, by injected humour",
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
                              "${type.toUpperCase()}",
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
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                children: [
                                  Spacer(),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          // If the video is playing, pause it.
                                          if (_controller.value.isPlaying) {
                                            // If the video is paused, play it.
                                            _controller.seekTo(Duration(seconds: -3));
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.skip_previous_sharp, color: Colors.lightGreen, size: 30,),
                                      )
                                  ),
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
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          // If the video is playing, pause it.
                                          if (_controller.value.isPlaying) {
                                            // If the video is paused, play it.
                                            _controller.seekTo(Duration(seconds: 3));
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.skip_next, color: Colors.lightGreen, size: 30,),
                                      )
                                  ),
                                  Spacer(),
                                ],
                              )
                            )
                          ],
                        ),
                      ),
                      // startVideo ?
                      Container(
                          width: _width(100),
                          child: Column(
                            children: [
                              Container(
                                width: _width(100),
                                height: _height(15),
                                child: Container(
                                  width: _width(100),
                                  height: _height(15),
                                  margin: EdgeInsets.only(right: _width(3), left: _width(3), bottom: _height(3)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: _selectColor(team == "endurance")
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: _width(3),),
                                      Container(
                                        width: _height(10),
                                        height: _height(10),
                                        child: SvgPicture.asset("assets/images/male.svg"),
                                      ),
                                      SizedBox(width: _width(5),),
                                      Column(
                                        children: [
                                          Spacer(),
                                          Text(
                                            "TECHNOLOGY DIVISION",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16
                                            ),
                                          ),
                                          SizedBox(height: _height(1),),
                                          Text(
                                            "${_getPeopleCount("ENDURANCE")} people participating",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                        height: _height(4),
                                        width: _height(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          color: Color.fromARGB(255,110,180,63),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "1",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: _width(3),),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: _width(100),
                                height: _height(15),
                                child: Container(
                                  width: _width(100),
                                  height: _height(15),
                                  margin: EdgeInsets.only(right: _width(3), left: _width(3), bottom: _height(3)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: _selectColor(team == "speed")
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: _width(3),),
                                      Container(
                                        width: _height(10),
                                        height: _height(10),
                                        child: SvgPicture.asset("assets/images/male.svg"),
                                      ),
                                      SizedBox(width: _width(5),),
                                      Column(
                                        children: [
                                          Spacer(),
                                          Text(
                                            "FINANCE DIVISION",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16
                                            ),
                                          ),
                                          SizedBox(height: _height(1),),
                                          Text(
                                            "${_getPeopleCount("SPEED")} people participating",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                        height: _height(4),
                                        width: _height(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          color: Color.fromARGB(255,110,180,63),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "2",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: _width(3),),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: _width(100),
                                height: _height(15),
                                child: Container(
                                  width: _width(100),
                                  height: _height(15),
                                  margin: EdgeInsets.only(right: _width(3), left: _width(3), bottom: _height(3)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: _selectColor(team == "agility")
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: _width(3),),
                                      Container(
                                        width: _height(10),
                                        height: _height(10),
                                        child: SvgPicture.asset("assets/images/male.svg"),
                                      ),
                                      SizedBox(width: _width(5),),
                                      Column(
                                        children: [
                                          Spacer(),
                                          Text(
                                            "CORPORATE SECURITY",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16
                                            ),
                                          ),
                                          SizedBox(height: _height(1),),
                                          Text(
                                            "${_getPeopleCount("AGILITY")} people participating",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                        height: _height(4),
                                        width: _height(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          color: Color.fromARGB(255,110,180,63),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "3",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: _width(3),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),


                      SizedBox( height: _height(5)),
                      showCall ? Center(
                        child: InkWell(
                          onTap: (){
                            HomeResources().updateVideoViews({"video_id": uid, "team": team});
                            Common().newActivity(context, videoStuff.VideoPlayer(
                                videoCall["video_call_token"],
                                videoCall["video_call_id"],
                                videoCall["video_channel_name"]
                              )
                            );
                          },
                          child: Container(
                            height: _height(5),
                            width: _width(80),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255,110,180,63),
                                borderRadius: BorderRadius.all(Radius.circular(15))
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
                      ) : Container(),
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

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  _selectColor(status){
    return status ?  Color.fromARGB(105,110,180,63) : Color.fromARGB(255,248,248,248);
  }

  _getPeopleCount(value){
    return participants.where((element) => element == value).length;
  }


}
