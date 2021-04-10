import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common.dart';

class Competitors extends StatefulWidget {
  List team = [];
  Competitors(List team){
    this.team = team;
  }
  @override
  _CompetitorsState createState() => _CompetitorsState(team);
}

class _CompetitorsState extends State<Competitors> {
  List team = [];

  _CompetitorsState(List team){
    this.team = team;
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
                          child: Column(
                            children: _displayActors()
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
                    Common().logoOnBar(context),
                    Spacer(),
                    SizedBox(width: _width(4),),
                  ],
                ),
              ),
            ],
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

  _displayActors(){
    var children = <Widget>[];
    children.add( SizedBox(height: _height(4)));
    team.forEach((element) {
      children.add(
          Container(
            width: _width(100),
            height: _height(10),
            margin: EdgeInsets.only(right: _width(3), left: _width(3), bottom: _height(3)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color.fromARGB(
                    (team.indexOf(element) + 1) == 1 ? 255 : (team.indexOf(element) + 1) == 2 ? 220 : 150
                    ,110,180,63)
            ),
            child: Row(
              children: [
                SizedBox(width: _width(3),),
                Text(
                  "${team.indexOf(element) + 1}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                  ),
                ),
                Text(
                  "${(team.indexOf(element) + 1) == 1 ? "st" : (team.indexOf(element) + 1) == 2 ? "nd" : "th" }",
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
                      "${Common().capitalize(element["user_id"])}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                    Text(
                      "Score: ${element["user_points"]}%",
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
          )
      );
    });
    return children;
  }
}
