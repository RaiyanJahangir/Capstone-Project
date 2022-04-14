import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/HomePage.dart';
import 'package:email_password_login/screens/map.dart';
import 'package:email_password_login/screens/user_home_page.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:email_password_login/screens/sensor_screen.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:email_password_login/screens/notification_screen.dart';
import 'package:email_password_login/screens/child_info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_password_login/screens/baby_info_as_guardian.dart';
import 'package:email_password_login/screens/baby_info_as_nurturer.dart';
import 'package:email_password_login/screens/give_auth_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
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
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    child: Image.asset(
                      "assets/baby_picture.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${loggedInUser.name}",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${loggedInUser.email}",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 15),
                  ActionChip(
                    label: Text("Logout"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Confirmed Logging Out ?",
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
                  ),
                  SizedBox(height: 15),
                  ActionChip(
                      label: Text("Check Health Parameters"),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (c) => SensorScreen()));
                      }),
                  SizedBox(height: 15),
                  ActionChip(
                      label: Text("vaccines"),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (c) => HomePage()));
                      }),
                  SizedBox(height: 15),
                  ActionChip(
                      label: Text("Profile"),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (c) => Home()));
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  ActionChip(
                      label: Text("User Home Page"),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (c) => UserHome()));
                      }),
                  SizedBox(height: 15),
                  ActionChip(
                      label: Text("Guardian"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) => guardian_homepage()));
                      }),
                  SizedBox(height: 15),
                  ActionChip(
                      label: Text("Nurturer"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) => nurturer_homepage()));
                      }),
                  SizedBox(height: 5),
                  ActionChip(
                      label: Text("Authorize people"),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (c) => auth()));
                      }),
                  SizedBox(height: 5),
                  ActionChip(
                      label: Text("Check baby Info"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) => ChildInfoScreen()));
                      }),
                  SizedBox(height: 15),
                  ActionChip(
                      label: Text("Map"),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (c) => MapSample()));
                      }),
                ],
              ),
            )),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil(
        (route) => route.isFirst
    );
  }
}