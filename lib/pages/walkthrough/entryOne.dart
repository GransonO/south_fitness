import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/steps/gender.dart';
import 'package:south_fitness/services/net.dart';

import '../common.dart';

class EntryOne extends StatefulWidget {
  @override
  _EntryOneState createState() => _EntryOneState();
}

class _EntryOneState extends State<EntryOne> with SingleTickerProviderStateMixin {

  var firstname;
  var lastname;
  var username;
  var email;
  var birthDate;
  var team = "FINANCE DIVISION";
  var code;
  bool login = false;
  bool loadingState = true;

  var institute_logo;
  var institute_img1 = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1627461186/South_Fitness/insitutions/legUp.png";
  var institute_img2 = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1627461186/South_Fitness/insitutions/legUp.png";
  var institute_img3 = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1627461186/South_Fitness/insitutions/legUp.png";
  var institute_message1 = "";
  var institute_message2 = "";
  var institute_message3 = "";
  Color mainColor = Colors.grey;

  late SharedPreferences prefs;
  final format = DateFormat("yyyy-MM-dd");
  var date = new DateTime.now();

  late TabController _controller;
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
      username = prefs.getString("username");
      lastname = prefs.getString("last_name");
      firstname = prefs.getString("first_name");
      email = prefs.getString("email");

      institute_logo = prefs.getString("institute_logo") != null ? prefs.getString("institute_logo") : institute_logo;
      institute_img1 = prefs.getString("institute_img1")!;
      institute_img2 = prefs.getString("institute_img2")!;
      institute_img3 = prefs.getString("institute_img3")!;
      institute_message1 = prefs.getString("institute_message1")!;
      institute_message2 = prefs.getString("institute_message2")!;
      institute_message3 = prefs.getString("institute_message3")!;
      var institutePrimaryColor = prefs.getString("institute_primary_color");
      List colors = institutePrimaryColor!.split(",");
      mainColor = Color.fromARGB(255,int.parse(colors[0]),int.parse(colors[1]),int.parse(colors[2]));
      loadingState = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                padding: EdgeInsets.all(15),
                                height: _height(50),
                                width: _width(100),
                                child: Image.network(
                                  institute_img1,
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
                                  "“$institute_message1”",
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
                                padding: EdgeInsets.all(15),
                                height: _height(50),
                                width: _width(100),
                                child: Image.network(
                                  institute_img2,
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
                                  "“$institute_message2”",
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
                                padding: EdgeInsets.all(15),
                                height: _height(50),
                                width: _width(100),
                                child: Image.network(
                                  institute_img3,
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
                                  "“$institute_message3”",
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
                                          "First Name: ",
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
                                                firstname = value;
                                              });
                                            },
                                            keyboardType: TextInputType.name,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(fontSize: 13, color: Color.fromARGB(200, 169, 169, 169)),
                                                hintText: firstname
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
                                          "Last Name: ",
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
                                                lastname = value;
                                              });
                                            },
                                            keyboardType: TextInputType.name,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(fontSize: 13, color: Color.fromARGB(200, 169, 169, 169)),
                                                hintText: lastname
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
                                          "Username: ",
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
                                                username = value;
                                              });
                                            },
                                            keyboardType: TextInputType.name,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(fontSize: 13, color: Color.fromARGB(200, 169, 169, 169)),
                                                hintText: username
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
                                            readOnly: true,
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
                                            onChanged: (value){
                                              setState(() {
                                                team = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: _height(7)),
                                  Center(
                                    child: InkWell(
                                      onTap: () async {
                                        if(email == null || username == null || firstname == null || birthDate == null || team == null){
                                          Fluttertoast.showToast(msg: "Please fill all entries", backgroundColor: Colors.red);
                                        }else{
                                          setState(() {
                                            login = true;
                                          });
                                          bool isCorrect = await Authentication().verifyActivationCode(
                                            {
                                              "email": email,
                                              "activation_code": code
                                            }
                                          );
                                          if(isCorrect){
                                            prefs = await SharedPreferences.getInstance();
                                            prefs.setString("username", username);
                                            prefs.setString("lastname", lastname);
                                            prefs.setString("firstname", firstname);
                                            prefs.setString("email", email);
                                            prefs.setString("birthDate", birthDate.toString());
                                            prefs.setString("team", team);
                                            prefs.setString("code", code.toString());
                                            Common().newActivity(context, Gender());
                                          }else{
                                            Fluttertoast.showToast(
                                                msg: "The activation code entered is incorrect",
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: _height(7),
                                        width: _width(80),
                                        decoration: BoxDecoration(
                                            color: mainColor,
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
                                                        color: Colors.green,
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
                                                        color: Colors.green,
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
                              width: _width(80),
                              color: Colors.white,
                              margin: EdgeInsets.only(top: _height(2)),
                              child: Row(
                                children: [
                                  SizedBox(width: _width(10),),
                                  Text(
                                    "Update your profile",
                                    style: TextStyle(
                                        fontSize: 16
                                    ),
                                  ),
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
                        decoration: Common().roundedContainer(15.0, mainColor),
                        duration: Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                      ),
                      SizedBox(width: _width(2),),
                      AnimatedContainer(
                        height: _width(2),
                        width: _width(_page(1)),
                        decoration: Common().roundedContainer(15.0, mainColor),
                        duration: Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                      ),
                      SizedBox(width: _width(2),),
                      AnimatedContainer(
                        height: _width(2),
                        width: _width(_page(2)),
                        decoration: Common().roundedContainer(15.0, mainColor),
                        duration: Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                      ),
                      SizedBox(width: _width(2),),
                      AnimatedContainer(
                        height: _width(2),
                        width: _width(_page(3)),
                        decoration: Common().roundedContainer(15.0, mainColor),
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
