import 'package:flutter/material.dart';
import 'package:south_fitness/pages/workouts/warmUps.dart';

import '../common.dart';

class WorkOuts extends StatefulWidget {
  @override
  _WorkOutsState createState() => _WorkOutsState();
}

class _WorkOutsState extends State<WorkOuts> {
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
                      SizedBox(height: _height(3),),

                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Workouts",
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
                        width: _width(100),
                        margin: EdgeInsets.only(top: _height(2),),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                Common().newActivity(context, WarmUps());
                              },
                              child: Container(
                                  height: _width(35),
                                  width: _width(45),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: _width(35),
                                        width: _width(45),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                          child: Image.asset(
                                            "assets/images/arms.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            Container(
                                              width: _height(25),
                                              child: Text(
                                                "Cardio",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                              width: _height(25),
                                              child: Text(
                                                "20 min",
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: (){
                                Common().newActivity(context, WarmUps());
                              },
                              child: Container(
                                  height: _width(35),
                                  width: _width(45),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: _width(35),
                                        width: _width(45),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                          child: Image.asset(
                                            "assets/images/abs.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            Container(
                                              width: _height(25),
                                              child: Text(
                                                "Abs and Arms",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                              width: _height(25),
                                              child: Text(
                                                "20 min | 2 exercises for each",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox( height: _height(8))
                    ],
                  ),
                )
              ),
              Container(
                height: _height(7),
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(width: _width(3),),
                    // Common().logoOnBar(context),
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
    );
  }


  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }
}





