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
  List<int> prevPulse = [];
  List<double> prevTemp = [];
  var pulse;
  var temperature;

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
      // final now = DateTime.now();
      // print(now);
      // databaseRef.set({'Timestamp': now.toString()});
      var snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (key == 'Pulse Rate') {
          //print(key + values.toString());
          pulse = values;
          //print(pulse);
        }
        if (key == 'Temperature') {
          temperature = values;
          //print(temperature);
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
          title: Text("Sensor Page"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  logout(context);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              SizedBox(height: 15),
              Text("Pulse Rate: " + pulse.toString() + " BPM"),
              SizedBox(height: 15),
              Text("Temperature: " + temperature.toString() + " °C"),
              SizedBox(height: 15),
              Text("Previous Data:"),
              SizedBox(height: 15),
              Expanded(
                child: Container(
                  height: 500,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Pulse Rate:"),
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
                      SizedBox(height: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Temperature:"),
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
                    ],
                  ),
                ),
              ),
            ]))
        // body: Container(
        //   child: TextButton(
        //     style: TextButton.styleFrom(
        //       textStyle: const TextStyle(fontSize: 20),
        //     ),
        //     onPressed: () {
        //       showData();
        //     },
        //     child: const Text('Show Data'),
        //   ),
        // ),
        // body: SafeArea(
        //   child: FirebaseAnimatedList(
        //     query: databaseRef1,
        //     itemBuilder: (BuildContext context, DataSnapshot snapshot,
        //         Animation<double> animation, int index) {
        //       return ListTile(
        //         title: Text('${snapshot.value}'),
        //         //subtitle: Text(snapshot.value['Temperature']['Data']),
        //       );
        //     },
        //   ),
        // ),
        // body: Column(
        //   children: [
        //     FirebaseAnimatedList(
        //       shrinkWrap: true,
        //       query: databaseRef,
        //       itemBuilder: (BuildContext context, DataSnapshot snapshot,
        //           Animation<double> animation, int index) {
        //         return ListTile(
        //           title: Text('${snapshot.value}'),
        //           //subtitle: Text(snapshot.value['Temperature']['Data']),
        //         );
        //       },
        //     ),
        //   ],
        // ),
        );
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
