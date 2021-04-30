import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/services/net.dart';

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
  var user_id = "";
  var comments = [];
  var comment = "Tell us what's on your mind";
  bool addComment = false;
  bool isPosting = false;
  SharedPreferences prefs;
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1619738022/South_Fitness/user.png";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
    getComments();
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
      email = prefs.getString("email");
      image = prefs.getString("image");
      user_id = prefs.getString("user_id");
    });
  }
  
  getComments() async {
    var commentX = await HomeResources().getBlogComments(details["blog_id"]);
    setState(() {
      comments = commentX;
      print("Comments ------------------------- $comments");
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
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Container(
                          height: _width(60),
                          width: _width(90),
                          margin: EdgeInsets.only(top: _height(1), bottom: _height(3)),
                          child: Image.network(
                              details["image_url"],
                              fit: BoxFit.fill
                          ),
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
                      Container(
                          width: _width(90),
                          margin: EdgeInsets.only(top: _height(1), bottom: _height(1)),
                          child: Html(
                            data: details["body"],
                          )
                      ),
                      addComment ? Container(
                          height: _height(10),
                          width: _width(100),
                          margin: EdgeInsets.only(bottom: _height(2)),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              border: Border.all(
                                  width: 0.5,
                                  color: Colors.grey
                              )
                          ),
                          child: Center(
                            child: Container(
                              width: _width(100),
                              height: _height(8),
                              padding: EdgeInsets.all(5),
                              child: TextField(
                                onChanged: (value){
                                  setState(() {
                                    comment = value;
                                  });
                                },
                                maxLines: 5,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 13, color: Color.fromARGB(200, 169, 169, 169)),
                                    hintText: comment
                                ),
                                style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ),
                          )
                      ) : Container(),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Readers comments",
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
                      SizedBox( height: 5),
                      Column(
                        children: displayComments(),
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
      floatingActionButton: FloatingActionButton(
        child: isPosting ? SpinKitThreeBounce(
          size: 15,
          color: Colors.white,
        ) : Icon(addComment ? Icons.send : Icons.add, color: Colors.white),
        backgroundColor: Colors.lightGreen,
        onPressed: () async {
          if(addComment == true){
            if(comment == "Tell us what's on your mind"){
              Fluttertoast.showToast(msg: "Enter your comment before posting");
              return;
            }
            // post comment $ refresh
            setState(() {
              isPosting = true;
            });
            var result = await HomeResources().postBlogComment(
              {
                "blog_id": details["blog_id"],
                "username": username,
                "uploader_id": user_id,
                "body": comment,
                "user_image": image
              }
            );
            if(result){
              Fluttertoast.showToast(msg: "Posting success", backgroundColor: Colors.green, textColor: Colors.white);
              setState(() {
                addComment = false;
                isPosting = false;
                comment = "Tell us what's on your mind";
              });
              getComments();
            }else{
              Fluttertoast.showToast(msg: "Posting error, try again later", backgroundColor: Colors.red, textColor: Colors.white);
              setState(() {
                isPosting = false;
              });
            }
          }else{
            setState(() {
              addComment = true;
              isPosting = false;
            });
          }
        },
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

  displayComments(){
    var children = <Widget>[];
    comments.forEach((element) {
      children.add(
          Container(
            width: _width(100),
            padding: EdgeInsets.all(8.0,),
            child: Column(
              children: [
                SizedBox(height: _height(1),),
                Container(
                  height: _height(4),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            height: _height(5),
                            width: _height(5),
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.cover, image: new NetworkImage(element["profile_image"])
                                )
                            )
                        ),
                      ),
                      SizedBox(width: _width(1),),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: _width(70),
                          child: Text(
                            element["username"],
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: _width(1),),
                Container(
                    padding: EdgeInsets.only(left: 5),
                    width: _width(100),
                    child: Text(
                      element["body"],
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                          fontSize: 13
                      ),
                    )
                ),
                Container(
                    width: _width(100),
                    padding: EdgeInsets.only(right: 5),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          convertDate(element["updatedAt"]),
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.normal,
                              fontSize: 11
                          ),
                        )
                    )
                ),
                SizedBox(height: _height(1),),
                Container(
                  height: 0.5,
                  width: _width(100),
                  color: Colors.grey,
                ),
              ],
            ),
          )
      );
    });
    return children;
  }

  convertDate(date) {
    var dateItem = DateTime.parse(date);
    return DateFormat('EEE d MMM, yyyy').format(dateItem);
  }
}
