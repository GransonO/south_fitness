import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common.dart';

class Reader extends StatefulWidget {
  var blog;
  Reader(var details){
    blog = details;
  }

  @override
  _ReaderState createState() => _ReaderState(blog);
}

class _ReaderState extends State<Reader> {

  var details;
  _ReaderState(blog){
    details = blog;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool notesClicked = false;

  var username = "";
  var email = "";
  SharedPreferences prefs;
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
      image = prefs.getString("image");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: _height(9), left: _width(4), right: _width(4)),
                  child: Column(
                    children: [
                      Container(
                        height: _width(60),
                        width: _width(90),
                        margin: EdgeInsets.only(top: _height(1), bottom: _height(4)),
                        child: Image.network(
                            details["image_url"],
                            fit: BoxFit.fill
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              details["title"],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      SizedBox( height: _height(1)),
                      Container(
                          width: _width(90),
                          margin: EdgeInsets.only(top: _height(1), bottom: _height(4)),
                          child: Html(
                            data: details["body"],
                          )
                      ),
                      SizedBox( height: _height(8))
                    ],
                  )
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
          )
      ),
      drawer: Common().navDrawer(context, username, email, "notes", image),
    );
  }


  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }
}
