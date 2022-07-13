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

class Notification2Screen extends StatefulWidget {
  const Notification2Screen({Key? key}) : super(key: key);

  @override
  Notification2ScreenState createState() => Notification2ScreenState();
}

class Notification2ScreenState extends State<Notification2Screen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List<Map> listOfMaps = [];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
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
  // _getToken() {
  //   _firebaseMessaging.getToken().then((token) {
  //     print("Device Token: $token");
  //   });
  // }

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

    //_getToken();
    //_configureFirebaseListeners();
  }

  // late List<Message> messagesList;

  // _configureFirebaseListeners() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     try {
  //       final data = message.data;
  //       print(message.notification);
  //     } catch (e) {
  //       print(e);
  //     }
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
  //     try {
  //       print('onResume: $message');
  //       final data = message.data;
  //       print(message.notification);
  //     } catch (e) {
  //       print(e);
  //     }
  //   });
  //   // _firebaseMessaging.requestNotificationPermissions(
  //   //   const IosNotificationSettings(sound: true, badge: true, alert: true),
  //   // );
  // }

  // _setMessage(Map<String, dynamic> message) {
  //   final notification = message['notification'];
  //   final data = message['data'];
  //   final String title = notification['title'];
  //   final String body = notification['body'];
  //   String mMessage = data['message'];
  //   print("Title: $title, body: $body, message: $mMessage");
  //   setState(() {
  //     Message msg = Message(title, body, mMessage);
  //     messagesList.add(msg);
  //   });
  // }

  @override
  //_getToken();
  //_configureFirebaseListeners();

// _configureFirebaseListeners() {
//   _firebaseMessaging.configure(
//     //this line shows error
//     onMessage: (Map<String, dynamic> message) async {
//       print('onMessage: $message');
//       _setMessage(message);
//     },
//     onLaunch: (Map<String, dynamic> message) async {
//       print('onLaunch: $message');
//       _setMessage(message);
//     },
//     onResume: (Map<String, dynamic> message) async {
//       print('onResume: $message');
//       _setMessage(message);
//     },
//   );
//   // _firebaseMessaging.requestNotificationPermissions(
//   //   const IosNotificationSettings(sound: true, badge: true, alert: true),
//   // );
// }

// _setMessage(Map<String, dynamic> message) {
//   final notification = message['notification'];
//   final data = message['data'];
//   final String title = notification['title'];
//   final String body = notification['body'];
//   String mMessage = data['message'];
//   print("Title: $title, body: $body, message: $mMessage");
//   setState(() {
//     Message msg = Message(title, body, mMessage);
//     messagesList.add(msg);
//   });
// }

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
                  //var a;
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.blue,
                    size: 24.0,
                  ),
                  //title: const Text(size ?? ''),
                  title: Text(
                    "User Profile",
                  ),
                  subtitle: Text(
                    "${loggedInUser.name}",
                  ),
                  //onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (c) => SensorScreen())),
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
      body: listView(),
      //   body: ListView.builder(
      //     itemCount: null == messagesList ? 0 : messagesList.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return Card(
      //         child: Padding(
      //           padding: EdgeInsets.all(10.0),
      //           child: Text(
      //             messagesList[index].message,
      //             style: TextStyle(
      //               fontSize: 16.0,
      //               color: Colors.black,
      //             ),
      //           ),
      //         ),
      //       );
      //     },
      //   ),
    );
  }

  Widget listView() {
    return ListView.separated(
      itemCount: 15,
      separatorBuilder: (context, index) {
        return Divider(height: 0);
      },
      itemBuilder: (context, index) {
        return listViewItem(index);
      },
    );
  }

  Widget listViewItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefixIcon(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    message(index),
                    timeAnddata(index),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget prefixIcon() {
    return Container(
      height: 50,
      width: 50,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: Icon(
        Icons.notifications,
        size: 25,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget message(int index) {
    double textSize = 14;
    return Container(
      child: RichText(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: 'message',
          style: TextStyle(
              fontSize: textSize,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          children: [
            TextSpan(
                text: 'Notification description',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ))
          ],
        ),
      ),
    );
  }

  Widget timeAnddata(int index) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '23-01-2022',
            style: TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }

// body: ListView.builder(
//   itemCount: null == messagesList ? 0 : messagesList.length,
//   itemBuilder: (BuildContext context, int index) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(10.0),
//         child: Text(
//           messagesList[index].message,
//           style: TextStyle(
//             fontSize: 16.0,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   },
// ),
//   );
// }

// Future<void> logout(BuildContext context) async {
//   await FirebaseAuth.instance.signOut();
//   Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => LoginScreen()));
// }

// class Message {
//   late String title;
//   late String body;
//   late String message;
//   Message(title, body, message) {
//     this.title = title;
//     this.body = body;
//     this.message = message;
//   }
// }

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
