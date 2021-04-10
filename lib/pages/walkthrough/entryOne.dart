import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/steps/gender.dart';

import '../common.dart';

class EntryOne extends StatefulWidget {
  @override
  _EntryOneState createState() => _EntryOneState();
}

class _EntryOneState extends State<EntryOne> with SingleTickerProviderStateMixin {

  var fullname;
  var email;
  var birthDate;
  var team = "FINANCE DIVISION";
  var code;
  bool login = false;

  SharedPreferences prefs;
  final format = DateFormat("yyyy-MM-dd");
  var date = new DateTime.now();

  TabController _controller;
  var tab = 0;
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(vsync: this, length: 4);
    _controller.addListener(_handleTabSelection);
    setPrefs();
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      fullname = prefs.getString("username");
      email = prefs.getString("email");
    });
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
              DefaultTabController(
                length: 4,
                child: TabBarView(
                  controller: _controller,
                  children: [
                    Container(
                      height: _height(100),
                      width: _width(100),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: _height(5)),
                            Center(
                              child: Container(
                                height: _height(15),
                                width: _width(50),
                                child: Image.asset(
                                  'assets/images/fit.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: _height(3)),
                            Center(
                              child: Container(
                                height: _height(50),
                                width: _width(100),
                                child: Image.asset(
                                  'assets/images/yoga.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: _height(1)),
                            Center(
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text("Powered by "),
                                  Container(
                                    height: _height(3),
                                    width: _width(15),
                                    child: Image.asset(
                                      'assets/images/power.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                            SizedBox(height: _height(3)),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "“Strength does not come from the physical capacity. It comes from an indomitable will.”",
                                  style: TextStyle(
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: _height(100),
                      width: _width(100),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: _height(5)),
                            Center(
                              child: Container(
                                height: _height(15),
                                width: _width(50),
                                child: Image.asset(
                                  'assets/images/tukiuke.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: _height(3)),
                            Center(
                              child: Container(
                                height: _height(50),
                                width: _width(100),
                                child: Image.asset(
                                  'assets/images/runner.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: _height(1)),
                            Center(
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text("Powered by "),
                                  Container(
                                    height: _height(3),
                                    width: _width(15),
                                    child: Image.asset(
                                      'assets/images/power.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                            SizedBox(height: _height(3)),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "“Your body can stand almost anything. It’s your mind that you have to convince.”",
                                  style: TextStyle(
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: _height(100),
                      width: _width(100),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: _height(5)),
                            Center(
                              child: Container(
                                height: _height(15),
                                width: _width(50),
                                child: Image.asset(
                                  'assets/images/tukiuke.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: _height(3)),
                            Center(
                              child: Container(
                                height: _height(50),
                                width: _width(100),
                                child: Image.network(
                                  'https://res.cloudinary.com/dolwj4vkq/image/upload/v1617256436/South_Fitness/video_images/IMG-20210131-WA0000.jpg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: _height(1)),
                            Center(
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text("Powered by "),
                                  Container(
                                    height: _height(3),
                                    width: _width(15),
                                    child: Image.asset(
                                      'assets/images/power.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                            SizedBox(height: _height(3)),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "“Your body bends to your rules, make it your vision to be your best”",
                                  style: TextStyle(
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: _height(100),
                        width: _width(100),
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: _height(9)),
                                  Container(
                                    width: _width(80),
                                    child: Text("Complete your member profile and get first access to the very best of Products, Inspiration and community."),
                                  ),

                                  Container(
                                    height: _height(7),
                                    width: _width(80),
                                    margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                                    padding: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        border: Border.all(
                                            width: 0.5,
                                            color: Colors.grey
                                        )
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Full Name: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          ),
                                        ),
                                        Container(
                                          width: _width(40),
                                          child: TextField(
                                            onChanged: (value){
                                              setState(() {
                                                fullname = value;
                                              });
                                            },
                                            keyboardType: TextInputType.name,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(fontSize: 13, color: Color.fromARGB(200, 169, 169, 169)),
                                              hintText: fullname
                                            ),
                                            style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 0, 0, 0)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: _height(7),
                                    width: _width(80),
                                    margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                                    padding: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        border: Border.all(
                                            width: 0.5,
                                            color: Colors.grey
                                        )
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Email Address: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          ),
                                        ),
                                        Container(
                                          width: _width(40),
                                          child: TextField(
                                            onChanged: (value){
                                              setState(() {
                                                email = value;
                                              });
                                            },
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(fontSize: 13, color: Color.fromARGB(200, 169, 169, 169)),
                                              hintText: email
                                            ),
                                            style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 0, 0, 0)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: _height(7),
                                    width: _width(80),
                                    margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                                    padding: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        border: Border.all(
                                            width: 0.5,
                                            color: Colors.grey
                                        )
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Date of birth: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: _width(40),
                                          child: DateTimeField(
                                            format: format,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '',
                                              hintStyle: TextStyle(fontSize: 13, color: Color.fromARGB(175, 169, 169, 169)),
                                            ),
                                            style: TextStyle(fontSize: 13, color: Color.fromARGB(175, 0, 0, 0)),
                                            onShowPicker: (context, currentValue) {
                                              return showDatePicker(
                                                context: context,
                                                firstDate: DateTime(date.year - 120),
                                                initialDate: currentValue ?? DateTime.now(),
                                                lastDate: DateTime(date.year + 1),
                                              );
                                            },
                                            onChanged: ((value){
                                              birthDate = value.toString();
                                            }),
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: _height(7),
                                    width: _width(80),
                                    margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                                    padding: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        border: Border.all(
                                            width: 0.5,
                                            color: Colors.grey
                                        )
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Activation Code: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          ),
                                        ),
                                        Container(
                                          width: _width(40),
                                          child: TextField(
                                            onChanged: (value){
                                              setState(() {
                                                code = value;
                                              });
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(fontSize: 13, color: Color.fromARGB(200, 169, 169, 169)),
                                            ),
                                            style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 0, 0, 0)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: _height(7),
                                    width: _width(80),
                                    margin: EdgeInsets.only(right: _width(2), top: _height(2)),
                                    padding: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        border: Border.all(
                                            width: 0.5,
                                            color: Colors.grey
                                        )
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Team: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: _width(60),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 137, 138, 143),
                                              fontSize: 12,
                                              fontFamily: ".SF NS Text",
                                            ),
                                            items: [
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'FINANCE DIVISION',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'FINANCE DIVISION',
                                              ),
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'BUSINESS DEVELOPMENT',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'BUSINESS DEVELOPMENT',
                                              ),
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'CORPORATE SECURITY DIVISION',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'CORPORATE SECURITY DIVISION',
                                              ),
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'COPs - COMMERCIAL',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'COPs - COMMERCIAL',
                                              ),
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'GREATER WESTERN & RIFT - COMMERCIAL',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'GREATER WESTERN & RIFT - COMMERCIAL',
                                              ),
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'FINANCIAL SERVICES DIVISION',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'FINANCIAL SERVICES DIVISION',
                                              ),
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'RESOURCES DIVISION',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'RESOURCES DIVISION',
                                              ),
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'TECHNOLOGY DIVISION',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'TECHNOLOGY DIVISION',
                                              ),
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'NAIROBI EAST COAST REGION - COMMERCIAL',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'NAIROBI EAST COAST REGION - COMMERCIAL',
                                              ),
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'CEOs OFFICE',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'CEOs OFFICE',
                                              ),
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'NAIROBI WEST & MOUNTAIN - COMMERCIAL',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'NAIROBI WEST & MOUNTAIN - COMMERCIAL',
                                              ),
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'CORPORATE AFFAIRS DIVISION',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'CORPORATE AFFAIRS DIVISION',
                                              ),
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'ENTERPRISE BUSINESS UNIT',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 137, 138, 143),
                                                      fontSize: 14,
                                                      fontFamily: ".SF NS Text",
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.left,
                                                ),
                                                value: 'ENTERPRISE BUSINESS UNIT',
                                              ),
                                            ],
                                            onChanged: (String value) {
                                              team = value;
                                            },
                                            hint: Text(
                                              'Select Division',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                  fontFamily: ".SF NS Text",
                                                  fontWeight: FontWeight.w400),
                                              textAlign: TextAlign.left,
                                            ),
                                            value: team,
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: _height(10)),
                                  Center(
                                    child: InkWell(
                                      onTap: () async {
                                        if(email == null || fullname == null || birthDate == null || team == null){
                                          Fluttertoast.showToast(msg: "Please fill all entries", backgroundColor: Colors.red);
                                        }else{
                                          setState(() {
                                            login = true;
                                          });
                                          prefs = await SharedPreferences.getInstance();

                                          prefs.setString("fullname", fullname);
                                          prefs.setString("email", email);
                                          prefs.setString("birthDate", birthDate.toString());
                                          prefs.setString("team", team);
                                          prefs.setString("code", code.toString());
                                          Common().newActivity(context, Gender());
                                        }
                                      },
                                      child: Container(
                                        height: _height(5),
                                        width: _width(80),
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(255,110,180,63),
                                            borderRadius: BorderRadius.all(Radius.circular(15))
                                        ),
                                        child: Center(
                                          child: login ? SpinKitThreeBounce(
                                            color: Colors.white,
                                            size: 15,
                                          ) : Text(
                                            "Update Profile",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: _height(3)),

                                  Center(
                                    child: Container(
                                        width: _width(80),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: _width(80),
                                              child: Text(
                                                "By continuing, you agree to accept our ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                                width: _width(80),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Privacy Policy ",
                                                      style: TextStyle(
                                                        color: Colors.lightGreenAccent,
                                                        fontSize: 15,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      "& ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Terms of Service",
                                                      style: TextStyle(
                                                        color: Colors.lightGreenAccent,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                  SizedBox(height: _height(3)),
                                ],
                              ),
                            ),
                            Container(
                              height: _height(7),
                              child: Row(
                                children: [
                                  SizedBox(width: _width(7),),
                                  Text(
                                    "Update your profile",
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
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _controller.index == 3 ? Container() :
                  Row(
                    children: [
                      Spacer(),
                      AnimatedContainer(
                        height: _width(2),
                        width: _width(_page(0)),
                        decoration: Common().roundedContainer(15.0, Color.fromARGB(255, 232,196,40)),
                        duration: Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                      ),
                      SizedBox(width: _width(2),),
                      AnimatedContainer(
                        height: _width(2),
                        width: _width(_page(1)),
                        decoration: Common().roundedContainer(15.0, Color.fromARGB(255, 232,196,40)),
                        duration: Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                      ),
                      SizedBox(width: _width(2),),
                      AnimatedContainer(
                        height: _width(2),
                        width: _width(_page(2)),
                        decoration: Common().roundedContainer(15.0, Color.fromARGB(255, 232,196,40)),
                        duration: Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                      ),
                      SizedBox(width: _width(2),),
                      AnimatedContainer(
                        height: _width(2),
                        width: _width(_page(3)),
                        decoration: Common().roundedContainer(15.0, Color.fromARGB(255, 232,196,40)),
                        duration: Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  _handleTabSelection(){
    setState(() {
      tab = _controller.index;
    });
  }

  _page(x){
    if(_controller.index == x){
      return 7;
    }else{
      return 2;
    }
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }
}