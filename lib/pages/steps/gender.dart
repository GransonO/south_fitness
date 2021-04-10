import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/common.dart';
import 'package:south_fitness/pages/steps/goal.dart';

class Gender extends StatefulWidget {

  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  bool male = true;
  bool female = true;
  SharedPreferences prefs;

  var weight = 55;
  var lheight = 110;

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
                  child: Column(
                    children: [
                      SizedBox(height: _height(9)),
                      Center(
                        child: Container(
                          width: _width(80),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    female = false;
                                    male = true;
                                  });

                                  prefs = await SharedPreferences.getInstance();
                                  prefs.setString("gender", "Male");
                                },
                                child: Container(
                                  height: _width(25),
                                  width: _width(25),
                                  child: SvgPicture.asset(
                                    "assets/images/male.svg",
                                    fit: BoxFit.cover,
                                    color: female ? Colors.grey : null,
                                  ),
                                ),
                              ),
                              SizedBox(width: _width(2),),
                              Center(
                                child: Text("Male"),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    female = true;
                                    male = false;
                                  });

                                  prefs = await SharedPreferences.getInstance();
                                  prefs.setString("gender", "Female");
                                },
                                child: Container(
                                  height: _width(25),
                                  width: _width(25),
                                  child: SvgPicture.asset(
                                    "assets/images/male.svg",
                                    fit: BoxFit.cover,
                                    color: male ? Colors.grey : null
                                  ),
                                ),
                              ),
                              SizedBox(width: _width(2),),
                              Center(
                                child: Text("Female"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: _height(5)),
                      Center(
                        child: Container(
                            height: _height(5),
                            width: _width(80),
                            child: Row(
                              children: [
                                Text(
                                  "Weight ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17
                                  ),
                                ),
                                Text(
                                  "in KG",
                                )
                              ],
                            )
                        ),
                      ),
                      Center(
                        child: Container(
                            height: _height(8),
                            width: _width(85),
                            child: Row(
                              children: [
                                Container(
                                  height: _height(7),
                                  width: _width(60),
                                  child: Slider(
                                    value: weight + 0.0,
                                    divisions: 20,
                                    activeColor: Colors.green,
                                    onChanged: (val) async {
                                      setState(() {
                                        weight = val.toInt();
                                      });
                                      prefs = await SharedPreferences.getInstance();
                                      prefs.setInt("weight", weight);
                                    },
                                    min: 40.0,
                                    max: 150.0,
                                    label: "${weight.round()}",
                                  )
                                ),
                                Spacer(),
                                Container(
                                  height: _height(7),
                                  width: _height(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 1
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Container(
                                          width: _height(5),
                                          child: TextField(
                                            onChanged: (value){
                                              weight = int.parse(value);
                                            },
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: weight.toString()
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "KGs",
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: _height(3)),
                      Center(
                        child: Container(
                            height: _height(5),
                            width: _width(80),
                            child: Row(
                              children: [
                                Text(
                                  "Height ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17
                                  ),
                                ),
                                Text(
                                  "in Centimetres",
                                )
                              ],
                            )
                        ),
                      ),
                      Center(
                        child: Container(
                            height: _height(8),
                            width: _width(85),
                            child: Row(
                              children: [
                                Container(
                                  height: _height(7),
                                  width: _width(60),
                                  child: Slider(
                                    value: lheight + 0.0,
                                    divisions: 20,
                                    activeColor: Colors.green,
                                    onChanged: (val) async {
                                      setState(() {
                                        lheight = val.toInt();
                                      });
                                      prefs = await SharedPreferences.getInstance();
                                      prefs.setInt("height", lheight);
                                    },
                                    min: 100,
                                    max: 200,
                                    label: "${lheight.round()}",
                                  )
                                ),
                                Spacer(),
                                Container(
                                  height: _height(7),
                                  width: _height(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 1
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Container(
                                          width: _height(5),
                                          child: TextField(
                                            onChanged: (value){
                                              lheight = int.parse(value);
                                            },
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: lheight.toString()
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "cm",
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: _height(5)),
                      Center(
                        child: Container(
                            height: _height(7),
                            width: _width(80),
                            child: Row(
                              children: [
                                Text(
                                  "Step 1 ",
                                  style: TextStyle(
                                      fontSize: 15
                                  ),
                                ),
                                Spacer(),

                                InkWell(
                                  onTap: (){
                                    Common().newActivity(context, Goals());
                                  },
                                  child: Container(
                                    height: _height(7),
                                    width: _width(40),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: Color.fromARGB(255,110,180,63),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Next",
                                        style: TextStyle(
                                            fontSize: 17,
                                          color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: _height(7),
                  child: Row(
                    children: [
                      SizedBox(width: _width(3),),
                      Icon(Icons.arrow_back, color: Colors.black, size: 35,),
                      SizedBox(width: _width(4),),
                      Text(
                        "Select Gender",
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ],
            )
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
