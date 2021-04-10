import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/services/net.dart';

import '../common.dart';
import 'competitors.dart';

class Performance extends StatefulWidget {
  @override
  _PerformanceState createState() => _PerformanceState();
}


class _PerformanceState extends State<Performance> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var teamClicked = false;

  SharedPreferences prefs;
  var username = "";
  var email = "";
  var team = "";
  List teamsData = [];
  bool loading = true;
  var speed = [], agility = [], endurance = [];
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1565367393/jade/profiles/user.jpg";

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
      team = prefs.getString("team");
      image = prefs.getString("image");
    });
    getTeamsPerformance();
  }

  getTeamsPerformance() async {
    var value = await PerformanceResource().getPerformance();
    print("ordered teams list value ---------> $value");
    setState(() {
      loading = false;
      teamsData = value["team_list"];
      speed = value["speed"].toList();
      agility = value["agility"].toList();
      endurance = value["endurance"].toList();
    });
  }

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
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: _height(10),  bottom: _height(4), left: _width(4), right: _width(4)),
                          height: _width(40),
                          width: _width(50),
                          child: SvgPicture.asset(
                              "assets/images/win.svg",
                              fit: BoxFit.fill
                          ),
                        ),
                        SizedBox( height: _height(1)),
                        Container(
                          width: _width(100),
                          margin: EdgeInsets.only(top: _height(1), bottom: _height(4)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), ),
                              color: Color.fromARGB(255,246,246,246)
                          ),
                          child: teamClicked ? Column(
                            children: [
                              SizedBox(height: _height(4),),
                              InkWell(
                                onTap: (){
                                  setState(() {

                                  });
                                },
                                child: Container(
                                  width: _width(100),
                                  height: _height(10),
                                  margin: EdgeInsets.only(right: _width(3), left: _width(3), bottom: _height(3)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: Color.fromARGB(255,110,180,63)
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: _width(3),),
                                      Text(
                                        "1",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20
                                        ),
                                      ),
                                      Text(
                                        "st",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12
                                        ),
                                      ),
                                      Spacer(),
                                      Column(
                                        children: [
                                          Spacer(),
                                          Text(
                                            "Granson O",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16
                                            ),
                                          ),
                                          Text(
                                            "Score: 73.49",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      Spacer(),
                                      Icon(Icons.arrow_forward_ios_sharp, color: Colors.white,),
                                      SizedBox(width: _width(3),),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    // teamClicked = true;
                                  });
                                },
                                child: Container(
                                  width: _width(100),
                                  height: _height(10),
                                  margin: EdgeInsets.only(right: _width(3), left: _width(3), bottom: _height(3)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: Color.fromARGB(155,110,180,63)
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: _width(3),),
                                      Text(
                                        "2",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20
                                        ),
                                      ),
                                      Text(
                                        "nd",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12
                                        ),
                                      ),
                                      Spacer(),
                                      Column(
                                        children: [
                                          Spacer(),
                                          Text(
                                            "Mercy Myra",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16
                                            ),
                                          ),
                                          Text(
                                            "Score: 53.49",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      Spacer(),
                                      Icon(Icons.arrow_forward_ios_sharp, color: Colors.white,),
                                      SizedBox(width: _width(3),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ) : loading ? Center(
                            child: SpinKitThreeBounce(
                              color: Colors.lightGreen,
                              size: 30,
                            ),
                          ) : Column(
                            children: _displayTeams(),
                          ),
                        ),
                        SizedBox( height: _height(8))
                      ],
                    )
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: _height(40),
                  width: _width(100),
                  child: SvgPicture.asset(
                    "assets/images/stars.svg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              // Place holder for the
              Container(
                margin: EdgeInsets.only(top: _height(8)),
                color: Colors.green,
                height: _height(95),
                child: Image.network(
                  "https://res.cloudinary.com/dolwj4vkq/image/upload/v1617267717/South_Fitness/video_images/WhatsApp_Image_2021-04-01_at_08.39.10.jpg",
                  fit: BoxFit.fill,
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

  _displayTeams(){
    var children = <Widget>[];
    children.add( SizedBox(height: _height(4)));
    teamsData.forEach((element) {
      children.add(
        InkWell(
          onTap: (){
            setState(() {
              Common().newActivity(context, Competitors(_teamToPass(element["name"])));
            });
          },
          child: Container(
            width: _width(100),
            height: _height(10),
            margin: EdgeInsets.only(right: _width(3), left: _width(3), bottom: _height(3)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color.fromARGB(
                    (teamsData.indexOf(element) + 1) == 1 ? 255 : (teamsData.indexOf(element) + 1) == 2 ? 220 : 150
                ,110,180,63)
            ),
            child: Row(
              children: [
                SizedBox(width: _width(3),),
                Text(
                  "${teamsData.indexOf(element) + 1}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                  ),
                ),
                Text(
                  "${(teamsData.indexOf(element) + 1) == 1 ? "st" : (teamsData.indexOf(element) + 1) == 2 ? "nd" : "th" }",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    Spacer(),
                    Text(
                      "Team ${Common().capitalize(element["name"])}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                    Text(
                      "Score: ${element["points"]}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_sharp, color: Colors.white,),
                SizedBox(width: _width(3),),
              ],
            ),
          ),
        ),
      );
    });
    return children;
  }

  _teamToPass(var name){
    List team = [];
    switch(name){
      case "speed":
        team = speed;
        break;
      case "agility":
        team = agility;
        break;
      case "endurance":
        team = endurance;
        break;
      case "vitality":
        team = speed;
        break;
    }
    return team;
  }
}
