import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:email_password_login/screens/sensor_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List<Map> listOfMaps = [];

  final notifRef = FirebaseDatabase.instance.reference().child("notifications");

  final databaseRef =
      FirebaseDatabase.instance.reference().child("baby0").child("Sensor Data");

  final pulseRef = FirebaseDatabase.instance
      .reference()
      .child("baby0")
      .child("Sensor Data")
      .child("Pulse Rate");

  final tempRef = FirebaseDatabase.instance
      .reference()
      .child("baby0")
      .child("Sensor Data")
      .child("Temperature");

  final cryRef = FirebaseDatabase.instance
      .reference()
      .child("baby0")
      .child("Sensor Data")
      .child("Cry");

  var pulse;
  var temperature;
  var prevPulse;
  var prevTemp;
  var timestamp;
  var title;
  var details;

  var cry;

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

    notifRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (key == 'Title') {
          title = values;
        }
        if (key == 'Details') {
          details = values;
        }
        setState(() {});
      });
    });

    pulseRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      int values = snapshot.value;
      pulse = values;
      if (pulse > 100) {
        highPulseAlert();
      } else if (pulse < 70) {
        lowPulseAlert();
      }
      print('Pulse Rate ' + pulse.toString());
      setState(() {});
    });

    tempRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      double values = snapshot.value;
      temperature = values;
      if (temperature > 36.8) {
        highTempAlert();
      } else if (temperature < 28.0) {
        lowTempAlert();
      }
      print('Temperature ' + temperature.toString());
      setState(() {});
    });

    cryRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      String values = snapshot.value;
      cry = values;
      if (cry == "YES") {
        cryAlert();
      }
      setState(() {});
    });
  }

  Widget _buildNotificationItem({Map? contact}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
      alignment: Alignment.center,
      //height: 130,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Row(
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact!['Title'].toString(),
                style: TextStyle(
                    fontSize: 16,
                    //color: Theme.of(context).primaryColor,
                    color: Color.fromARGB(255, 19, 19, 19),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Icon(
                Icons.health_and_safety_rounded,
                color: Theme.of(context).accentColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['Details'].toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 19, 19, 19),
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              SizedBox(width: 15),
              Icon(
                Icons.timelapse,
                color: Colors.lightBlueAccent,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['Timestamp'].toString(),
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(255, 19, 19, 19),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          // Divider(
          //   color: Colors.black,
          //   thickness: 2,
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          centerTitle: false,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Text('Notifications')),
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
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 760,
            child: Column(
              children: [
                Expanded(
                  child: FirebaseAnimatedList(
                      scrollDirection: Axis.vertical,
                      query: notifRef,
                      reverse: true,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        Map contact = snapshot.value;
                        return _buildNotificationItem(contact: contact);
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  highPulseAlert() {
    notifRef.push().set({
      "Title": "Health Alert",
      "Details": "Baby's Pulse Rate is high",
      "Timestamp": DateTime.now().toString().substring(0, 19)
    });
  }

  lowPulseAlert() {
    notifRef.push().set({
      "Title": "Health Alert",
      "Details": "Baby's Pulse Rate is low",
      "Timestamp": DateTime.now().toString().substring(0, 19)
    });
  }

  lowTempAlert() {
    notifRef.push().set({
      "Title": "Health Alert",
      "Details": "Baby's Body Temperature is low",
      "Timestamp": DateTime.now().toString().substring(0, 19)
    });
  }

  highTempAlert() {
    notifRef.push().set({
      "Title": "Health Alert",
      "Details": "Baby's Body Temperature is high",
      "Timestamp": DateTime.now().toString().substring(0, 19)
    });
  }

  cryAlert() {
    notifRef.push().set({
      "Title": "Cry Alert",
      "Details": "Your baby is crying. Give a check.",
      "Timestamp": DateTime.now().toString().substring(0, 19)
    });
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
