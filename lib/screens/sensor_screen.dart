import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({Key? key}) : super(key: key);

  @override
  SensorScreenState createState() => SensorScreenState();
}

class SensorScreenState extends State<SensorScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final databaseRef =
      FirebaseDatabase.instance.reference().child("Sensor Data");
  final prevPulseRef = FirebaseDatabase.instance
      .reference()
      .child("Previous Sensor Data")
      .child("Pulse Rate");
  final prevTempRef = FirebaseDatabase.instance
      .reference()
      .child("Previous Sensor Data")
      .child("Temperature");
  final prevTimeRef = FirebaseDatabase.instance
      .reference()
      .child("Previous Sensor Data")
      .child("Timestamp");

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

    // databaseRef.once().then((DataSnapshot snapshot) {
    //   Map<dynamic, dynamic> values = snapshot.value;
    //   values.forEach((key, values) {
    //     if (key == 'Pulse Rate') {
    //       print(key + values.toString());
    //       pulse = values;
    //       print(pulse);
    //     }
    //     if (key == 'Temperature') {
    //       temperature = values;
    //       print(temperature);
    //     }
    //   });
    // });
    databaseRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (key == 'Pulse Rate') {
          prevPulse = pulse;
          pulse = values;
          if (prevPulse != pulse) {
            _updatevalue();
          }
        }
        if (key == 'Temperature') {
          prevTemp = temperature;
          temperature = values;
          if (prevTemp != temperature) {
            _updatevalue();
          }
        }
        setState(() {});
      });
    });

    prevPulseRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {});
      });
    });

    prevTempRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {});
      });
    });

    prevTimeRef.onValue.listen((event) {
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              //passing this to a loop
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          title: Text("Baby Health Parameters"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  showDialog(
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
                      });
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              SizedBox(height: 15),
              Text(
                "Pulse Rate: " + pulse.toString() + " BPM",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueAccent,
                    fontSize: 25),
              ),
              Divider(
                color: Colors.blue,
                thickness: 2,
              ),
              Text(
                "Temperature: " + temperature.toString() + " °C",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueAccent,
                    fontSize: 25),
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
              SizedBox(height: 15),
              Expanded(
                child: Container(
                  height: 500,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Pulse Rate"),
                            Divider(
                              color: Colors.blue,
                              thickness: 2,
                            ),
                            Expanded(
                              child: FirebaseAnimatedList(
                                  query: prevPulseRef,
                                  itemBuilder: (BuildContext context,
                                      DataSnapshot snapshot,
                                      Animation<double> animation,
                                      int index) {
                                    return ListTile(
                                      title: Text('${snapshot.value}' + " BPM"),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Temperature"),
                            Divider(
                              color: Colors.blue,
                              thickness: 2,
                            ),
                            Expanded(
                              child: FirebaseAnimatedList(
                                  query: prevTempRef,
                                  itemBuilder: (BuildContext context,
                                      DataSnapshot snapshot,
                                      Animation<double> animation,
                                      int index) {
                                    return ListTile(
                                      title: Text('${snapshot.value}' + " °C"),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Timstamp"),
                            Divider(
                              color: Colors.blue,
                              thickness: 2,
                            ),
                            Expanded(
                              child: FirebaseAnimatedList(
                                  query: prevTimeRef,
                                  itemBuilder: (BuildContext context,
                                      DataSnapshot snapshot,
                                      Animation<double> animation,
                                      int index) {
                                    var timestamp =
                                        snapshot.value.substring(0, 20);
                                    return ListTile(
                                      title: Text(timestamp),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ])));
  }

  _updatevalue() {
    var now = DateTime.now();
    databaseRef.update({"Timestamp": now.toString()});
  }

  //Logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}

//for adding data to realtime database
// void addData(String data) {
//   //databaseRef.push().set({'name': data, 'comment': 'a good season'});
//   //databaseRef.push().set({'Pulse Rate': 140});
// }
// body: FutureBuilder(
//     future: _future,
//     builder: (context, snapshot) {
//       if (snapshot.hasError) {
//         return Text(snapshot.error.toString());
//       } else {
//         return Container(
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: 250.0),
//               Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: TextField(),
//               ),
//               SizedBox(height: 30.0),
//               Center(
//                 child: ElevatedButton(
//                   //color: Colors.pinkAccent,
//                   child: Text("Save to Database"),
//                   onPressed: () {
//                     addData(textcontroller.text);
//                     printFirebase();
//                   },
//                 ),
//               )
//             ],
//           ),
//         );
//       }
//     }),
