import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:email_password_login/screens/sensor_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _getToken() {
    _firebaseMessaging.getToken().then((token) {
      print("Device Token: $token");
    });
  }

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

    _getToken();
    _configureFirebaseListeners();
  }

  late List<Message> messagesList;

  _configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        final data = message.data;
        print(message.notification);
      } catch (e) {
        print(e);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      try {
        print('onResume: $message');
        final data = message.data;
        print(message.notification);
      } catch (e) {
        print(e);
      }
    });
    // _firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(sound: true, badge: true, alert: true),
    // );
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];
    print("Title: $title, body: $body, message: $mMessage");
    setState(() {
      Message msg = Message(title, body, mMessage);
      messagesList.add(msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
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
      body: ListView.builder(
        itemCount: null == messagesList ? 0 : messagesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                messagesList[index].message,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}

class Message {
  late String title;
  late String body;
  late String message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}
