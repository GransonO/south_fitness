import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/services/net.dart';

import '../common.dart';

class Competitors extends StatefulWidget {
  String name;
  Competitors(name){
    this.name = name;
  }
  @override
  _CompetitorsState createState() => _CompetitorsState(this.name);
}

class _CompetitorsState extends State<Competitors> {
  String team;
  List teamsData = [];


  _CompetitorsState(name){
    this.team = name;
  }

  SharedPreferences prefs;
  var username = "";
  var email = "";
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";
  bool loading = true;
  bool loadingState = true;
  Color mainColor = Colors.white;
  var img = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";


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
    getParticipatingUsers();
  }

  getParticipatingUsers() async {
    var value = await PerformanceResource().getIndividualPerformance(team);
    print("ordered teams list value ---------> $value");
    setState(() {
      loading = false;
      teamsData = value;
    });
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
        ) : Container(
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
                          child: loading ? Center(
                            child: SpinKitThreeBounce(
                              color: mainColor,
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
        Container(
          margin: EdgeInsets.only(right: _width(3), left: _width(3), bottom: _height(3)),
          child: Card(
            color: Colors.white,
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            shadowColor: Colors.grey[100],
            child: Container(
              width: _width(100),
              height: _height(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: _selectColor(teamsData.indexOf(element))
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
                        "${Common().capitalize(element["name"])}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                      Text(
                        "Score: ${element["count"] * 5}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Spacer(),
                  SizedBox(width: _width(3),),
                ],
              ),
            ),
          ),
        ),
      );
    });
    return children;
  }

  _selectColor(index){
    if(index < 3){
      return Color.fromARGB((255 - (index * 30)) ,110,180,63);
    }else{
      return Color.fromARGB(20,110,180,63);
    }
  }
}
