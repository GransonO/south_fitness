import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/auth/login.dart';
import 'package:south_fitness/pages/common.dart';
import 'package:south_fitness/services/net.dart';

class ResetPage extends StatefulWidget {
  @override
  _ResetPageState createState() => _ResetPageState();
}


class _ResetPageState extends State<ResetPage> {

  var email = "", resetCode = "", newPass = "", confPass = "";
  bool login = false;
  bool reset = false;
  SharedPreferences prefs;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUsage();
  }

  checkUsage() async {
    prefs = await SharedPreferences.getInstance();
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
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: prefs != null ? prefs.getString("email") : "",
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
                      reset ? Column(
                        children: [
                          Container(
                            height: _height(7),
                            width: _width(80),
                            margin: EdgeInsets.only(right: _width(2), bottom: _height(1)),
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
                                  "Enter Reset Code: ",
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
                                        resetCode = value;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    obscureText: false,
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
                            margin: EdgeInsets.only(right: _width(2), bottom: _height(1)),
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
                                  "New Password: ",
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
                                        newPass = value;
                                      });
                                    },
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
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
                            margin: EdgeInsets.only(right: _width(2), bottom: _height(1)),
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
                                  "Confirm Password: ",
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
                                        confPass = value;
                                      });
                                    },
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
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
                        ],
                      ): Container(),
                      SizedBox(height: _height(2)),
                      Center(
                        child: InkWell(
                          onTap: () async {
                            if(reset){
                              // reset Code sent
                              _resetPassword();
                            }else{
                              _requestResetCode();
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
                                reset ? "Update password": "Reset",
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

  _requestResetCode() async {
    if(email == ""){
      Fluttertoast.showToast(msg: "Please enter your email address", backgroundColor: Colors.red);
    }else{
      setState(() {
        login = true;
      });
      var result = await Authentication().forgotPassword({"email": email.trim()});
      if(result["success"]){
        setState(() {
          login = false;
          reset = true;
        });

        Fluttertoast.showToast(msg: "Check your email for your reset code", backgroundColor: Colors.green);
      }else{
        setState(() {
          login = false;
        });
        Fluttertoast.showToast(msg: "Could not complete transaction. Please try again later", backgroundColor: Colors.red);
      }
    }
  }

  _resetPassword() async {
    if(email == "" || confPass == "" || newPass == "" || resetCode == ""){
      Fluttertoast.showToast(msg: "Please fill in all the entries", backgroundColor: Colors.red);
    }else{
      if(newPass.length < 6){
        Fluttertoast.showToast(msg: "Password should have at least six characters", backgroundColor: Colors.red);
        return;
      }
      if(newPass.contains(new RegExp(r'[0-9]'))){
        Fluttertoast.showToast(msg: "Password should have at least one number", backgroundColor: Colors.red);
        return;
      }
      if(confPass != newPass){
        Fluttertoast.showToast(msg: "Passwords don't match error", backgroundColor: Colors.red);
      }else{
        setState(() {
          login = true;
        });
        var result = await Authentication().resetPassword({
          "email": email.trim(),
          "password": newPass.trim(),
          "code": resetCode.trim()
        });
        if(result){
          Fluttertoast.showToast(msg: "Reset successful", backgroundColor: Colors.green,  textColor: Colors.white);
          setState(() {
            login = false;
            reset = false;
          });
          Common().newActivity(context, Login());
        }else{
          Fluttertoast.showToast(msg: "Reset failed. Check your details and the reset code ", backgroundColor: Colors.red, textColor: Colors.white);
          setState(() {
            login = false;
          });
        }
      }
    }
  }
}
