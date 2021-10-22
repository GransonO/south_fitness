import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/workouts/warmUps.dart';
import 'package:south_fitness/pages/workouts/workouts.dart';

import '../common.dart';
import 'suggested_details.dart';

class SuggestedActivities extends StatefulWidget {

  var dataList;
  SuggestedActivities(list){
    dataList = list;
  }

  @override
  _SuggestedActivitiesState createState() => _SuggestedActivitiesState(dataList);
}

class _SuggestedActivitiesState extends State<SuggestedActivities> {


  SharedPreferences prefs;
  var username = "";
  var email = "";
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";
  var theList = [];
  Color mainColor = Colors.white;
  bool loadingState = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _SuggestedActivitiesState(dataList){
    theList = dataList;
    print("------------------------------------------------- $theList");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
  }
  var img = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";

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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        ) : Container(
          height: _height(100),
          width: _width(100),
          child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: _height(9),),
                      Container(
                        margin: EdgeInsets.only(left: _width(4), right: _width(4)),
                        width: _width(100),
                        child: Text(
                          "Suggested Activities",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: _height(3),),
                      Container(
                        margin: EdgeInsets.only(left: _width(4), right: _width(4)),
                        child: theList.length > 0 ? displaySuggestions() : Center(
                            child: Container(
                              margin: EdgeInsets.only(top: _height(20)),
                              child: Text("No New Activities"),
                            )
                        ),
                      ),
                    ],
                  )
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

  displaySuggestions(){
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var theWidth = _screenWidth / 2;
    var cellHeight = _height(20);
    var _aspectRatio = theWidth /cellHeight;
    return Container(
        child: GridView.builder(
          padding: EdgeInsets.only(bottom: 10),
          shrinkWrap: true,
          itemCount: theList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _crossAxisCount,childAspectRatio: _aspectRatio),
          itemBuilder: (context, index) {
            final theItem = theList[index];

            return  InkWell(
              onTap: (){
                Common().newActivity(context, SuggestedDetails(theItem));
              },
              child: Container(
                  height: _height(15),
                  width: _height(25),
                  margin: EdgeInsets.only(right: _width(4), bottom: _height(3)),
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
                        width: _height(25),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Image.network(
                            "${theItem["image_url"]}",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: _height(10.5)),
                        color: Colors.white70,
                        height: _height(4),
                        width: _height(25),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: _width(2)),
                              width: _height(25),
                              child: Text("${theItem["title"]}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,

                              ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(left: _width(2)),
                              width: _height(25),
                              child: Text("${theItem["duration"]} ${theItem["duration_ext"]}", style: TextStyle(
                                fontSize: 11
                              ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ]
                        )
                      )
                    ],
                  )
              ),
            );

          },
        )
    );
  }
}
