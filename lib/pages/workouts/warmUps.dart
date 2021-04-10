import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

import '../common.dart';

class WarmUps extends StatefulWidget {
  @override
  _WarmUpsState createState() => _WarmUpsState();
}

class _WarmUpsState extends State<WarmUps> {
  bool personal = false;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://res.cloudinary.com/dolwj4vkq/video/upload/v1612826609/South_Fitness/yoga.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Container(
                          height: _width(70),
                          width: _width(90),
                          margin: EdgeInsets.only(top: _height(3), bottom: _height(4)),
                          child: personal ? FutureBuilder(
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
                          ) : Image.asset(
                              "assets/images/player.png",
                              fit: BoxFit.fill
                          ),
                        ),
                      ),

                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Warm-Up",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Spacer(),
                            SvgPicture.asset("assets/images/switch.svg")
                          ],
                        ),
                      ),
                      SizedBox( height: _height(3)),
                      InkWell(
                        onTap: (){
                          setState(() {
                            // displayVideo = true;
                          });
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Image.asset(
                                      "assets/images/cardio.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: _width(4),),
                                Column(
                                  children: [
                                    Spacer(),
                                    Container(
                                      width: _width(40),
                                      child: Text(
                                        "Jumping Jacks",
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(height: _height(2),),
                                    Container(
                                      width: _width(40),
                                      child: Text(
                                        "20 Reps",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Spacer(),
                                    personal ? Container(
                                      height: _height(4),
                                      width: _height(4),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          color: Colors.lightGreen
                                      ),
                                      child: Center(child: Icon(Icons.check, color: Colors.white, size: 20,)),
                                    ) : Container(
                                      child: Icon(Icons.refresh, color: Colors.grey,),
                                    ),
                                    SizedBox(height: _height(2),),
                                    Container(
                                        width: _width(10),
                                        child: Text(
                                            ""
                                        )
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ],
                            )
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            // displayVideo = true;
                          });
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Image.asset(
                                      "assets/images/train.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: _width(4),),
                                Column(
                                  children: [
                                    Spacer(),
                                    Container(
                                      width: _width(40),
                                      child: Text(
                                        "Warm up",
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(height: _height(2),),
                                    Container(
                                      width: _width(40),
                                      child: Text(
                                        "20 Reps",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Spacer(),
                                    Container(
                                      child: personal ? Text("00:50", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)) : Icon(Icons.refresh, color: Colors.grey,),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ],
                            )
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            // displayVideo = true;
                          });
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Image.asset(
                                      "assets/images/cardio.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: _width(4),),
                                Column(
                                  children: [
                                    Spacer(),
                                    Container(
                                      width: _width(40),
                                      child: Text(
                                        "Push Ups",
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(height: _height(2),),
                                    Container(
                                      width: _width(40),
                                      child: Text(
                                        "20 Reps",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Spacer(),
                                    Container(
                                      child: Icon(Icons.refresh, color: Colors.grey,),
                                    ),
                                    SizedBox(height: _height(2),),
                                    Container(
                                        width: _width(10),
                                        child: Text(
                                            ""
                                        )
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ],
                            )
                        ),
                      ),

                      Center(
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              personal = true;
                            });
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
                                personal ? "Finish" : "Start",
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
              Container(
                height: _height(7),
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(width: _width(3),),
                    Common().logoOnBar(context),
                    Spacer(),
                    Icon(Icons.notifications_none, size: 30,),
                    SizedBox(width: _width(4),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
