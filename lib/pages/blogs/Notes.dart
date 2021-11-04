import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/blogs/reader.dart';
import 'package:south_fitness/services/net.dart';
import '../common.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool notesClicked = false;

  var username = "";
  var email = "";
  late SharedPreferences prefs;
  var blogList = [];
  bool loading = true;
  bool loadingState = true;
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";
  var img = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg";

  Color mainColor = Colors.white;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
    getBlogs();
  }

  setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      email = prefs.getString("email")!;
      image = prefs.getString("image")!;
      img = prefs.getString("institute_logo")!;
      var institutePrimaryColor = prefs.getString("institute_primary_color");
      List colors = institutePrimaryColor!.split(",");
      mainColor = Color.fromARGB(255,int.parse(colors[0]),int.parse(colors[1]),int.parse(colors[2]));
      loadingState = false;
    });
  }

  getBlogs() async {
    var result = await HomeResources().getAllBlogs();
    setState(() {
      blogList = result;
      loading = false;
    });
  }


  _addBlogsToUi(){
    var children = <Widget>[];
    if(blogList.isNotEmpty){
      blogList.forEach((element) {
        children.add(
          InkWell(
            onTap: (){
              Common().newActivity(context, Reader(element));
            },
            child: Container(
                height: _width(60),
                width: _width(90),
                margin: EdgeInsets.only(top: _height(1), bottom: _height(4)),
                child: Stack(
                  children: [
                    Center(
                      child: SpinKitThreeBounce(
                        color: Colors.lightGreen,
                        size: 30,
                      ),
                    ),
                    Container(
                      height: _width(60),
                      width: _width(90),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Image.network(
                          "${element["image_url"]}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Container(
                        height: _width(60),
                        width: _width(90),
                        color: Colors.black54,
                        child: Center(
                            child: Column(
                              children: [
                                Spacer(),
                                Text(
                                  element["title"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Text(
                                  "by ${element["uploaded_by"]}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  convertDate(element["updatedAt"]),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                                Spacer(),
                              ],
                            )
                        ),
                      ),
                    )
                  ],
                )
            ),
          ),
        );
      });
    } else {
      children.add(
        Container(
          height: _height(15),
          margin: EdgeInsets.only(right: _width(2), left: _width(2),top: _height(2),bottom: _height(2),),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(15)
              ),
              border: Border.all(
                  color: Colors.lightGreen,
                  width: 2
              )
          ),
          child: Center(
              child: Text(
                "No Health Tips",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                ),
              )
          ),
        ),
      );
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        ) : Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: _height(9), left: _width(4), right: _width(4)),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Tips for health",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox( height: _height(3)),

                    loading ? Center(
                      child: SpinKitThreeBounce(
                        color: Colors.lightGreen,
                        size: 30,
                      ),
                    ) : Column(
                      children: _addBlogsToUi(),
                    ),

                    SizedBox( height: _height(5)),

                    SizedBox( height: _height(8))
                  ],
                ),
              ),
            ),
            Container(
              height: _height(7),
              color: Colors.white,
              child: Row(
                children: [
                  Common().logoOnBar(context, img),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      _scaffoldKey.currentState!.openDrawer();
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

  convertDate(date) {
    var dateItem = DateTime.parse(date);
    return DateFormat('EEE d MMM, yyyy').format(dateItem);
  }

}

