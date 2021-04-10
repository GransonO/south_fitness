import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/home/Home.dart';
import 'package:south_fitness/services/net.dart';

import '../common.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool teamClicked = false;

  var birthDate;
  var team = "FINANCE DIVISION";
  var code;
  bool login = false;

  SharedPreferences prefs;
  final format = DateFormat("yyyy-MM-dd");
  var date = new DateTime.now();

  var fullname = "";
  var email = "";
  var posting = false;

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
      fullname = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
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
                                  'Select Team',
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

                              var profileData = {
                                "fullname": fullname,
                                "email": email,
                                "birthDate": birthDate.toString(),
                                "team": team
                              };
                              var result = await Authentication().updateProfile(profileData);
                              if(result["success"]){
                                prefs.setString("email", email);
                                prefs.setString("username", fullname);
                                Fluttertoast.showToast(msg: "Profile updated successfully", backgroundColor: Colors.green);
                                Common().newActivity(context, HomeView());
                              }else{
                                Fluttertoast.showToast(msg: "Profile update failed", backgroundColor: Colors.deepOrangeAccent);
                              }
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

                    ],
                  ),
                ),
                Container(
                  height: _height(7),
                  child: Row(
                    children: [
                      SizedBox(width: _width(3),),
                      Text(
                        "Complete profile",
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
      drawer: Common().navDrawer(context, fullname, email, "profile", image),
    );
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }
}
