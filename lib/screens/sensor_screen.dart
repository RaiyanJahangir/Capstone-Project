import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/notifications_screen.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:email_password_login/screens/graph_screen.dart';
import 'graph_screen.dart';

class SensorScreen extends StatefulWidget {
  final String text;
  const SensorScreen(@required this.text, {Key? key}) : super(key: key);

  @override
  SensorScreenState createState() => SensorScreenState();
}

class SensorScreenState extends State<SensorScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List pulse_list = [];
  List temp_list = [];
  List time_list = [];

  final databaseRef =
      FirebaseDatabase.instance.reference().child("baby0").child("Sensor Data");

  final prevDatabaseRef = FirebaseDatabase.instance
      .reference()
      .child("baby0")
      .child("Previous Sensor Data");
  // final prevPulseRef = FirebaseDatabase.instance
  //     .reference()
  //     .child("baby0")
  //     .child("Previous Sensor Data")
  //     .child("Pulse Rate");
  // final prevTempRef = FirebaseDatabase.instance
  //     .reference()
  //     .child("baby0")
  //     .child("Previous Sensor Data")
  //     .child("Temperature");
  // final prevTimeRef = FirebaseDatabase.instance
  //     .reference()
  //     .child("baby0")
  //     .child("Previous Sensor Data")
  //     .child("Timestamp");

  var pulse;
  var temperature;
  var prevPulse;
  var prevTemp;

  @override
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

    databaseRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (key == 'Pulse Rate') {
          prevPulse = pulse;
          pulse = values;

          print('Pulse Rate ' + pulse.toString());
        }
        if (key == 'Temperature') {
          prevTemp = temperature;
          temperature = values;

          print('Temperature ' + temperature.toString());
        }
        if (key == 'Latitude') {
          print('Latitude ');
        }
        if (key == 'Longitude') {
          print('Longitude ');
        }
        setState(() {});
      });
    });

    // prevPulseRef.onValue.listen((event) {
    //   var snapshot = event.snapshot;
    //   Map<dynamic, dynamic> values = snapshot.value;
    //   values.forEach((key, values) {
    //     setState(() {});
    //   });
    // });

    // prevTempRef.onValue.listen((event) {
    //   var snapshot = event.snapshot;
    //   Map<dynamic, dynamic> values = snapshot.value;
    //   values.forEach((key, values) {
    //     setState(() {});
    //   });
    // });

    // prevTimeRef.onValue.listen((event) {
    //   var snapshot = event.snapshot;
    //   Map<dynamic, dynamic> values = snapshot.value;
    //   values.forEach((key, values) {
    //     setState(() {});
    //   });
    // });

    prevDatabaseRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Text('Health Data')),
                IconButton(
                  icon: Icon(
                    Icons.circle_notifications,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => NotificationScreen()));
                  },
                ),
              ]),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
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
          //backgroundColor: Color.fromRGBO(232, 232, 242, 1),
        ),
        body: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              SizedBox(height: 15),
              Text(
                "Pulse Rate: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueAccent,
                    //color: Color.fromARGB(255, 192, 109, 13),
                    fontSize: 30),
              ),
              Text(
                pulse.toString() + " BPM",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    //color: Color.fromARGB(255, 20, 142, 243),
                    color: Color.fromARGB(238, 165, 33, 150),
                    fontSize: 50),
              ),
              Divider(
                color: Colors.blue,
                thickness: 2,
              ),
              Text(
                "Body Temperature: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueAccent,
                    //color: Color.fromARGB(255, 192, 109, 13),
                    fontSize: 30),
              ),
              Text(
                temperature.toString() + " °C",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    //color: Color.fromARGB(255, 20, 142, 243),
                    color: Color.fromARGB(238, 165, 33, 150),
                    fontSize: 50),
              ),
              Divider(
                color: Colors.blue,
                thickness: 2,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) =>
                          GraphScreen(pulse_list, temp_list, time_list)));
                },
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Check Graph',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.blue,
                thickness: 2,
              ),
              Text(
                "Previous Data",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                    fontSize: 25),
              ),
              SizedBox(height: 5),
              Divider(
                color: Colors.blue,
                thickness: 2,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Timestamp",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          color: Colors.blueAccent,
                        )),
                    VerticalDivider(
                      color: Colors.blue,
                      thickness: 5,
                    ),
                    Text("Pulse Rate",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.blueAccent,
                          fontSize: 20,
                        )),
                    VerticalDivider(
                      color: Colors.blue,
                      thickness: 5,
                    ),
                    Text("Temperature",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.blueAccent,
                          fontSize: 20,
                        )),
                  ]),
              Expanded(
                child: Container(
                  height: 500,
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.blue,
                        thickness: 2,
                      ),
                      Expanded(
                        child: FirebaseAnimatedList(
                            scrollDirection: Axis.vertical,
                            query: prevDatabaseRef,
                            reverse: true,
                            itemBuilder: (BuildContext context,
                                DataSnapshot snapshot,
                                Animation<double> animation,
                                int index) {
                              var timestamp = snapshot.value['Timestamp'];
                              time_list.add(timestamp);
                              var pulse = snapshot.value['Pulse Rate'];
                              pulse_list.add(pulse);
                              var temperature = snapshot.value['Temperature'];
                              temp_list.add(temperature);
                              var pulseColor =
                                  getPulseColor(snapshot.value['Pulse Rate']);
                              var tempColor =
                                  getTempColor(snapshot.value['Temperature']);
                              return Column(
                                children: [
                                  // Divider(
                                  //   color: Colors.blue,
                                  //   thickness: 2,
                                  // ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            timestamp,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.blueAccent,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ),
                                      VerticalDivider(
                                        color: Colors.white,
                                        thickness: 2,
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            pulse.toString() + " BPM",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              //color: Colors.blueAccent,
                                              color: pulseColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      VerticalDivider(
                                        color: Colors.white,
                                        thickness: 2,
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                              temperature.toString() + " °C",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                // color: Colors.blueAccent,
                                                color: tempColor,
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.blue,
                                    thickness: 2,
                                  ),
                                ],
                              );
                            }),
                      ),
                      Divider(
                        color: Colors.blue,
                        thickness: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ])));
  }

  Color getPulseColor(int value) {
    Color color = Theme.of(context).accentColor;
    if (value > 100 || value < 70) {
      color = Colors.red;
      return color;
    }
    color = Colors.blueAccent;
    return color;
  }

  Color getTempColor(double value) {
    Color color = Theme.of(context).accentColor;
    if (value > 36.8 || value < 28.0) {
      color = Colors.red;
      return color;
    }
    color = Colors.blueAccent;
    return color;
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
