import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  _SuggestedDetailsState(value){
    videoUrl = value["videoUrl"];
    title = value["title"];
    _controller = VideoPlayerController.network(
      videoUrl,
    );
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                                child: Text("4 Week(s)", style: TextStyle(
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
                                                child: Text("Build Muscles", style: TextStyle(
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
                                                child: Text("3 workouts", style: TextStyle(
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
                                                child: Text("Minimum Equipment", style: TextStyle(
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
                                                child: Text("Advance", style: TextStyle(
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
                                  Center(
                                    child: InkWell(
                                      onTap: (){
                                        Fluttertoast.showToast(msg: "Joined $title Challenge. You shall now receive notifications from this challenge");
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
                                            "Join",
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
                      Spacer()
                    ],
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }
}
