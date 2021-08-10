import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/common.dart';
import 'package:south_fitness/pages/home/Home.dart';
import 'package:south_fitness/pages/walkthrough/entryOne.dart';
import 'package:south_fitness/services/net.dart';

import 'ResetPage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String password = "";
  String email = "";
  bool login = false;
  SharedPreferences prefs;
  bool _obscurePass = true;
  bool fetchingSettings = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUsage();
  }

  permissions() async {
    bool camera = await Permission.camera.isGranted;
    bool microphone = await Permission.microphone.isGranted;
    bool phone = await Permission.phone.isGranted;
    bool storage = await Permission.storage.isGranted;
    bool location = await Permission.location.isGranted;
    bool activityRecognition = await Permission.activityRecognition.isGranted;
    if (!location) {
      await Permission.location.request();
    }
    if (!camera) {
      await Permission.camera.request();
    }
    if (!microphone) {
      await Permission.microphone.request();
    }
    if (!phone) {
      await Permission.phone.request();
    }
    if (!storage) {
      await Permission.storage.request();
    }
    if (!activityRecognition) {
      await Permission.activityRecognition.request();
    }
  }

  void checkUsage() async {
    prefs = await SharedPreferences.getInstance();
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool location = await Permission.location.isGranted;
    if (connectivityResult == ConnectivityResult.none) {
      // No connectivity
      Fluttertoast.showToast(
          msg: "Please check your internet connection",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Timer(Duration(seconds: 3), () => checkUsage());
    }else if(!location) {
      // No location
      await Permission.location.request();
      Timer(Duration(seconds: 3), () => checkUsage());
    }else{
      var isLoggedIn = prefs.getBool("isLoggedIn") != null ? prefs.getBool("isLoggedIn") : false;
      print("------------------------------------------------------------$email");
      if(isLoggedIn){
        Common().newActivity(context, HomeView());
      }
    }
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
                child: Column(
                  children: [
                    SizedBox(height: _height(7)),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            height: _height(10),
                            width: _width(60),
                            margin: EdgeInsets.only(left: _width(20)),
                            child: Image.asset(
                              'assets/images/power.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            height: _height(50),
                            width: _width(100),
                            child: Image.asset(
                              'assets/images/legUp.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      )
                    ),
                    SizedBox(height: _height(1)),
                    Container(
                      height: _height(7),
                      width: _width(80),
                      margin: EdgeInsets.only(right: _width(2)),
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
                                color: Colors.black,
                                fontSize: 12
                            ),
                          ),
                          Container(
                            width: _width(50),
                            child: TextField(
                              onChanged: (value){
                                setState(() {
                                  email = value;
                                });
                                prefs.setString("email", value);
                              },
                              keyboardType: TextInputType.emailAddress,
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
                    SizedBox(height: _height(1)),
                    Container(
                      height: _height(7),
                      width: _width(80),
                      margin: EdgeInsets.only(right: _width(2)),
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
                            "Enter password: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 12
                            ),
                          ),
                          Container(
                            width: _width(45),
                            child: TextField(
                              onChanged: (value){
                                setState(() {
                                  password = value;
                                });
                              },
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _obscurePass,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 13, color: Color.fromARGB(200, 169, 169, 169)),
                              ),
                              style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                          InkWell(
                              onTap: (){
                                setState(() {
                                  _obscurePass = !_obscurePass;
                                });
                              },
                              child: Container(
                                  width: _width(5),
                                  child:Icon( _obscurePass ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined)
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: _height(2)),
                    Center(
                      child: InkWell(
                        onTap: () async {
                          if(email == "" || password == ""){
                            Fluttertoast.showToast(msg: "Please fill all entries first", backgroundColor: Colors.red);
                          }else{
                            setState(() {
                              login = true;
                            });
                            var result = await Authentication().loginUser({"email": email.trim(),"password": password.trim()});
                            setState(() {
                              login = false;
                            });
                            if(result["success"] ){
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                // Account not set up
                                setState(() {
                                  fetchingSettings = true;
                                });
                                var homeSetup = await HomeResources()
                                    .getSettings(
                                    result["payload"]["institution_id"]
                                );
                                prefs.setString("institution_id",homeSetup["institution_id"]);
                                prefs.setString("institute_primary_color",homeSetup["institute_primary_color"]);
                                prefs.setString("institute_secondary_color",homeSetup["institute_secondary_color"]);
                                prefs.setString("institute_logo",homeSetup["institute_logo"]);
                                prefs.setString("institute_img1",homeSetup["institute_img1"]);
                                prefs.setString("institute_img2",homeSetup["institute_img2"]);
                                prefs.setString("institute_img3",homeSetup["institute_img3"]);
                                prefs.setString("institute_message1",homeSetup["institute_message1"]);
                                prefs.setString("institute_message2",homeSetup["institute_message2"]);
                                prefs.setString("institute_message3",homeSetup["institute_message3"]);

                                if(result["payload"]["isRegistered"]){
                                   Common().newActivity(context, HomeView());
                                 }else{
                                  // Registration process
                                  Common().newActivity(context, EntryOne());
                                 }
                            }else{
                              Fluttertoast.showToast(msg: "Login error. Please check your credentials", backgroundColor: Colors.red);
                            }
                          }
                        },
                        child: Container(
                          height: _height(5),
                          width: _width(80),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255,232,196,40),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          child: Center(
                            child: login ? SpinKitThreeBounce(
                              color: Colors.white,
                              size: 15,
                            ) : Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: _height(2)),
                    InkWell(
                      onTap: (){
                        Common().newActivity(context, ResetPage());
                      },
                      child: Center(
                        child: Container(
                            width: _width(80),
                            child: Text(
                              "Forgot password ?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.left,
                            ),
                        ),
                      ),
                    ),
                    SizedBox(height: _height(3)),
                    fetchingSettings ? Center(
                      child: Container(
                          width: _width(80),
                          child: Column(
                            children: [
                              Container(
                                width: _width(100),
                                child: Center(
                                  child: Text(
                                    "Fetching Settings",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                )
                              ),
                              Container(
                                width: _width(100),
                                child: Center(
                                  child: SpinKitThreeBounce(color: Colors.yellow, size: 25,)
                                )
                              ),
                            ],
                          )
                      ),
                    ) : Center(
                      child: Container(
                          width: _width(80),
                          child: Column(
                            children: [
                              Container(
                                width: _width(80),
                                child: Row(
                                  children: [
                                    Text(
                                      "By continuing, you agree to accept our ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      "Privacy Policy ",
                                      style: TextStyle(
                                        color: Color.fromARGB(255,232,196,40),
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  width: _width(80),
                                  child: Row(
                                    children: [

                                      Text(
                                        "& ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        "Terms of Service",
                                        style: TextStyle(
                                          color: Color.fromARGB(255,232,196,40),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          )
                      ),
                    ),
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

