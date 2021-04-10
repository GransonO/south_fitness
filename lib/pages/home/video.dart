import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/services/net.dart';

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
  SharedPreferences prefs;
  var allVideos = [];
  var liveVideos = [];
  var scheduleVideos = [];
  bool hasLive = false;
  bool loading = true;
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1565367393/jade/profiles/user.jpg";

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


  _displayLiveClasses(){
    var children = <Widget>[];
    liveVideos.forEach((element){
      print("ScheduledTime -----------------${element["scheduledTime"]}");
      children.add(
        InkWell(
          onTap: (){
            Common().newActivity(context, Session(element["type"], element["video_url"], element["video_id"], element["participants"]));
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
                                  "${element["duration"]} | ",
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

  convertDateTime(date) {
    var theDate =  DateTime.parse(date);
    return DateFormat.jm().format(theDate);
  }

  _displayScheduledClasses(){
    var children = <Widget>[];
    scheduleVideos.forEach((element){
      children.add(
        InkWell(
          onTap: (){
            print("Element ============== $element");
            Common().newActivity(context, Session(element["type"], element["video_url"], element["video_id"], element["participants"]));
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
                                "${element["duration"]} | ",
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

                    hasLive ? Container(
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
                    ) : Container(),
                    hasLive ? Container(
                      height: _height(21),
                      width: _width(100),
                      margin: EdgeInsets.only(top: _height(2),),
                      child: GridView.builder(
                        padding: EdgeInsets.only( left: 5.0, right: 5.0,bottom: 10),
                        shrinkWrap: true,
                        itemCount: _displayLiveClasses().length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: _height(1) / 20),
                        itemBuilder: (context, index) {
                          final theItem = _displayLiveClasses()[index];

                          return theItem;

                        },
                      ),
                    ) : Container(),

                    SizedBox(height: _height(3),),

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

                    Container(
                        height: _height(21),
                        width: _width(100),
                        margin: EdgeInsets.only(top: _height(2),),
                        child: GridView.builder(
                          padding: EdgeInsets.only( left: 5.0, right: 5.0,bottom: 10),
                          shrinkWrap: true,
                          itemCount: _displayScheduledClasses().length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: _height(1) / 20),
                          itemBuilder: (context, index) {
                            final theItem = _displayScheduledClasses()[index];

                            return theItem;

                          },
                        )
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

}
