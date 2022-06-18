import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphScreen extends StatefulWidget {
  final List pulse_list;
  final List temp_list;
  final List time_list;

  GraphScreen(
    @required this.pulse_list,
    this.temp_list,
    this.time_list, {
    Key? key,
  }) : super(key: key);

  @override
  GraphScreenState createState() => GraphScreenState();
}

class GraphScreenState extends State<GraphScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    final List<ChartData> Pulse_list = [];
    for (int i = 0; i < widget.pulse_list.length; i++) {
      Pulse_list.add(ChartData(i, widget.pulse_list[i].toDouble()));
    }
    final List<ChartData> Temp_list = [];
    for (int i = 0; i < widget.temp_list.length; i++) {
      Temp_list.add(ChartData(i, widget.temp_list[i]));
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Text('Health Data Curves')),
              ]),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                    //var a;
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                      size: 24.0,
                    ),
                    title: Text(
                      "User Profile",
                    ),
                    subtitle: Text(
                      "${loggedInUser.name}",
                    ),
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (c) => Home())),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.blue,
                    ),
                    title: Text('Logout'),
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Confirm Logging Out ?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blue,
                                    fontSize: 25)),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    logout(context);
                                  },
                                  child: Text("YES",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blueAccent,
                                          fontSize: 20))),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("NO",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blueAccent,
                                          fontSize: 20)))
                            ],
                          );
                        }),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              SizedBox(height: 15),
              Text(
                "Baby Pulse Rate Curve",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueAccent,
                    fontSize: 25),
              ),
              Container(
                  child: SfCartesianChart(series: <ChartSeries>[
                // Renders line chart
                LineSeries<ChartData, int>(
                    dataSource: Pulse_list,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y)
              ])),
              Text(
                "Baby Temperature Curve",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueAccent,
                    fontSize: 25),
              ),
              Container(
                  child: SfCartesianChart(series: <ChartSeries>[
                // Renders line chart
                LineSeries<ChartData, int>(
                    dataSource: Temp_list,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y)
              ])),
            ],
          )),
        ));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}
