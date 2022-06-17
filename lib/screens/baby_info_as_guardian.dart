// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/screens/FeedingList.dart';
import 'package:email_password_login/screens/Vaccine_Feeding.dart';
import 'package:email_password_login/screens/map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:email_password_login/screens/sensor_screen.dart';
import 'package:email_password_login/screens/give_auth_page.dart';
import 'package:email_password_login/screens/child_info_screen.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:email_password_login/screens/notification_screen.dart';
import '../model/user_model.dart';
import '../model/babies_model.dart';

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
  static List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
  static List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
  static List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
}

enum _MenuValues {
  logout,
}
String? myEmail;
String? myName;

class guardian_homepage extends StatefulWidget {
  final String text;
  const guardian_homepage(@required this.text, {Key? key}) : super(key: key);
  @override
  guardian_homepageState createState() => guardian_homepageState();
}

class guardian_homepageState extends State<guardian_homepage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  ChildModel loggedInbaby = ChildModel();

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
    FirebaseFirestore.instance
        .collection("Babies")
        .doc(widget.text)
        .get()
        .then((value) {
      this.loggedInbaby = ChildModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //var size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Text('Baby Info Page')),
              IconButton(
                icon: Icon(
                  Icons.circle_notifications,
                  color: Colors.white,
                  size: 24.0,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) => NotificationScreen()));
                },
              ),
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
      body: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Name : ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            //fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                  color: Colors.blueAccent,
                                  offset: Offset(2, 1),
                                  blurRadius: 10)
                            ])),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text("${loggedInbaby.name}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          //fontStyle: FontStyle.italic,
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) =>
                                ChildInfoScreen(loggedInbaby.baby_uid ?? '')));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: GradientColors.sky,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          'Check Info',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) => HomePage(loggedInbaby.baby_uid ?? ''))),
              child: Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: GradientColors.sea,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: GradientColors.sea.last.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(4, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Lottie.asset(
                        "assets/food.json",
                        width: 150,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('Feeding Information',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            //fontStyle: FontStyle.italic,
                          )),
                    )
                  ],
                ),
              ),
            )),
            Expanded(
                child: GestureDetector(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => SensorScreen())),
              child: Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: GradientColors.sky,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: GradientColors.sky.last.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(4, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Lottie.asset(
                        "assets/health.json",
                        width: 150,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('Health Record',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            //fontStyle: FontStyle.italic,
                          )),
                    )
                  ],
                ),
              ),
            )),
            Expanded(
                child: GestureDetector(
              onTap: () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => MapSample()))
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: GradientColors.sea,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: GradientColors.sea.last.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(4, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Lottie.asset(
                        "assets/map.json",
                        width: 150,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('Check Baby Location',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            //fontStyle: FontStyle.italic,
                          )),
                    )
                  ],
                ),
              ),
            )),
            Expanded(
                child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) => auth(loggedInbaby.baby_uid ?? ''))),
              child: Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: GradientColors.sky,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: GradientColors.sky.last.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(4, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Lottie.asset(
                        "assets/user.json",
                        width: 150,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('Authorize New Users',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            //fontStyle: FontStyle.italic,
                          )),
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
