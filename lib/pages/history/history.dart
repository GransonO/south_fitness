import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../common.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  var username = "";
  var email = "";
  SharedPreferences prefs;

  bool week = true;
  bool month = false;
  var image = "https://res.cloudinary.com/dolwj4vkq/image/upload/v1619738022/South_Fitness/user.png";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<_Activity> h_data = [];

  List<_Activity> c_data = [];

  dataToDisplay(){
    if(week){
        setState(() {
          c_data = [
            _Activity(0, Random().nextInt(100).toDouble()),
            _Activity(1, Random().nextInt(100).toDouble()),
            _Activity(2, Random().nextInt(100).toDouble()),
            _Activity(3, Random().nextInt(100).toDouble()),
            _Activity(4, Random().nextInt(100).toDouble()),
            _Activity(5, Random().nextInt(100).toDouble()),
            _Activity(6, Random().nextInt(100).toDouble()),
            _Activity(7, Random().nextInt(100).toDouble()),
            _Activity(8, Random().nextInt(100).toDouble()),
            _Activity(9, Random().nextInt(100).toDouble()),
            _Activity(10, Random().nextInt(100).toDouble()),
          ];
          h_data = [
            _Activity(0, Random().nextInt(100).toDouble()),
            _Activity(1, Random().nextInt(100).toDouble()),
            _Activity(2, Random().nextInt(100).toDouble()),
            _Activity(3, Random().nextInt(100).toDouble()),
            _Activity(4, Random().nextInt(100).toDouble()),
            _Activity(5, Random().nextInt(100).toDouble()),
            _Activity(6, Random().nextInt(100).toDouble()),
            _Activity(7, Random().nextInt(100).toDouble()),
            _Activity(8, Random().nextInt(100).toDouble()),
            _Activity(9, Random().nextInt(100).toDouble()),
            _Activity(10, Random().nextInt(100).toDouble()),
          ];
        });
    }else{
        setState(() {
          c_data = [
            _Activity(0, Random().nextInt(100).toDouble()),
            _Activity(1, Random().nextInt(100).toDouble()),
            _Activity(2, Random().nextInt(100).toDouble()),
            _Activity(3, Random().nextInt(100).toDouble()),
            _Activity(4, Random().nextInt(100).toDouble()),
          ];
          h_data = [
            _Activity(0, Random().nextInt(100).toDouble()),
            _Activity(1, Random().nextInt(100).toDouble()),
            _Activity(2, Random().nextInt(100).toDouble()),
            _Activity(3, Random().nextInt(100).toDouble()),
            _Activity(4, Random().nextInt(100).toDouble()),
          ];
        });
    }

  }

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
    dataToDisplay();
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
                margin: EdgeInsets.only(top: _height(9)),
                child: Column(
                  children: [
                    SizedBox(height: _height(3),),
                    Container(
                      margin: EdgeInsets.only(left: _width(4), right: _width(4)),
                      child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  month = false;
                                  week = true;
                                });
                                dataToDisplay();
                              },
                              child: Text(
                                "Weekly",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: week ? Colors.lightGreen : Colors.black
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text("|",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(width: 10,),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  month = true;
                                  week = false;
                                });
                                dataToDisplay();
                              },
                              child: Text("Monthly",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: month ? Colors.lightGreen : Colors.black
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),

                          ]
                      ),
                    ),
                    SizedBox( height: _height(2)),
                    Container(
                      height: _height(80),
                      padding: EdgeInsets.only(left: _width(4), right: _width(4)),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: _height(3),),
                            Container(
                              height: _height(47),
                              width: _width(100),
                              padding: EdgeInsets.all(_width(3)),
                              margin: EdgeInsets.only(bottom: _height(3)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Body Vitals",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.lightGreen
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: _height(4),
                                        width: _width(30),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            border: Border.all(color: Colors.lightGreen, width: 1)
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Heart rate  +",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.lightGreen
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SfCartesianChart(
                                      primaryXAxis: CategoryAxis(),
                                      // Chart title
                                      title: ChartTitle(text: ''),
                                      // Enable legend
                                      legend: Legend(isVisible: false),
                                      // Enable tooltip
                                      tooltipBehavior: TooltipBehavior(enable: true),
                                      series: <ChartSeries<_Activity, String>>[
                                        LineSeries<_Activity, String>(
                                            dataSource: h_data,
                                            xValueMapper: (_Activity sales, _) => sales.date.toString(),
                                            yValueMapper: (_Activity sales, _) => sales.value,
                                            name: "Heart Rate",
                                            color: Colors.lightGreen
                                        )
                                      ]),
                                ],
                              ),
                            ),
                            Container(
                              height: _height(47),
                              width: _width(100),
                              padding: EdgeInsets.all(_width(3)),
                              margin: EdgeInsets.only(bottom: _height(3)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Calories Burnt",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.lightGreen
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: _height(4),
                                        width: _width(30),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            border: Border.all(color: Colors.lightGreen, width: 1)
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Burn rate  +",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.lightGreen
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SfCartesianChart(
                                      primaryXAxis: CategoryAxis(),
                                      // Chart title
                                      title: ChartTitle(text: ''),
                                      // Enable legend
                                      legend: Legend(isVisible: false),
                                      // Enable tooltip
                                      tooltipBehavior: TooltipBehavior(enable: true),
                                      series: <ChartSeries<_Activity, String>>[
                                        LineSeries<_Activity, String>(
                                            dataSource: c_data,
                                            xValueMapper: (_Activity sales, _) => sales.date.toString(),
                                            yValueMapper: (_Activity sales, _) => sales.value,
                                            name: "Burn rate",
                                            color: Colors.lightGreen
                                        )
                                      ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
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
        ),
      ),
      drawer: Common().navDrawer(context, username, email, "chat", image),
    );
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }
}

class _Activity {
  _Activity(this.date, this.value);

  final int date;
  final double value;
}
