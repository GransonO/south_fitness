import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/services/net.dart';

import '../common.dart';

class ChallengeHistory extends StatefulWidget {
  @override
  _ChallengeHistoryState createState() => _ChallengeHistoryState();
}

class _ChallengeHistoryState extends State<ChallengeHistory> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var img = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";

  var username = "";
  var email = "";
  bool loading = true;
  bool loadingState = true;
  SharedPreferences prefs;
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";
  List history = [];

  Color mainColor = Colors.white;

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
      img = prefs.getString("institute_logo");
      var institutePrimaryColor = prefs.getString("institute_primary_color");
      List colors = institutePrimaryColor.split(",");
      mainColor = Color.fromARGB(255,int.parse(colors[0]),int.parse(colors[1]),int.parse(colors[2]));
      loadingState = false;
    });
    getUserHistory();
  }

  getUserHistory() async {
    var getHistory = await PerformanceResource().getUserHistory(email);
    setState(() {
      history = getHistory;
      loading = false;
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
                margin: EdgeInsets.only(top: _height(9), left: _width(4), right: _width(1)),
                child: loading ? Center(
                  child: SpinKitThreeBounce(
                    color: mainColor,
                    size: 30,
                  ),
                ) : Column(
                  children: _displayHistoryCards(),
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
          ],
        ),
      ),
      drawer: Common().navDrawer(context, username, email, "history", image),
    );
  }

  _displayHistoryCards(){
    var children = <Widget>[];
    children.add(Container(
      width: _width(100),
      child: Text(
        "Fitness is the condition of being physically fit and healthy and involves attributes that include, mental acuity, cardio-respiratory endurance, muscular strength, muscular endurance, body composition, and flexibility",
        style: TextStyle(
            fontSize: 13,
            color: Colors.grey
        ),
        textAlign: TextAlign.left,
      ),
    ));
    children.add(SizedBox(height: _height(3)));
    history.forEach((element) {
      var dateString = (element["createdAt"].replaceAll("T", " ")).toString().replaceAll("Z", "");
      print("==dateString=============${Common().dateStringFormatter(dateString)}");
      children.add(
          Container(
            height: _height(20),
            width: _width(100),
            margin: EdgeInsets.only(top: _width(3)),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      element["challengeType"] == "Walking" ? mainColor : element["challengeType"] == "Running" ? Colors.orange[100] : Colors.tealAccent[100],
                      Color.fromARGB(105,229,227,228)]),
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    element["challengeType"] == "Walking" ? Icons.directions_walk_rounded : element["challengeType"] == "Running" ? Icons.directions_run_rounded : Icons.directions_bike_rounded,
                    color: Colors.white,
                    size: 100,),
                ),
                Container(
                  margin: EdgeInsets.only(left: _width(3), top: _width(3)),
                  child: Column(
                    children: [
                      Spacer(),
                      Row(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Container(
                                    width: _width(40),
                                    child: Text(
                                        "Distance",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18
                                        )
                                    )
                                ),
                                Container(
                                    width: _width(40),
                                    child: Text(
                                        "${element["distance"]} km",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15
                                        )
                                    )
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                    width: _width(40),
                                    child: Text(
                                        "Steps Count",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18
                                        )
                                    )
                                ),
                                Container(
                                    width: _width(40),
                                    child: Text(
                                        "${element["steps_count"]}",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15
                                        )
                                    )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                          width: _width(100),
                          child: Text(
                              "Calories Burnt",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                              )
                          )
                      ),
                      Container(
                          width: _width(100),
                          child: Text(
                              "${element["caloriesBurnt"]} KJ",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15
                              )
                          )
                      ),
                      Spacer(),
                      Container(
                          width: _width(100),
                          child: Text(
                              "${Common().dateStringFormatter(dateString)}",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 11
                              )
                          )
                      ),
                      Spacer(),
                    ],
                  ),
                )
              ],
            ),
      )
      );
    });
    children.add(SizedBox( height: _height(5)));

    return children;
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }
}
