import 'package:email_password_login/model/babies_model.dart';
import 'package:email_password_login/screens/FeedingList.dart';
import 'package:email_password_login/screens/Vaccine_Feeding.dart';
import 'package:email_password_login/screens/notification_screen.dart';
import 'package:email_password_login/screens/request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_password_login/screens/sensor_screen.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:email_password_login/screens/req_auth_page.dart';
import 'package:email_password_login/model/babies_model.dart';

enum _MenuValues {
  logout,
}
String? myEmail;
String? myName;
String dropdownValue = 'One';

class nurturer_homepage extends StatefulWidget {
  final String text;

  const nurturer_homepage(@required this.text, {Key? key}) : super(key: key);

  @override
  State<nurturer_homepage> createState() => _nurturer_homepageState();
}

class _nurturer_homepageState extends State<nurturer_homepage> {
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
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: Text('Name : ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.blue,
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
                    child: Text("${loggedInbaby.name}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          //fontStyle: FontStyle.italic,
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: GridView.count(
                padding: EdgeInsets.all(8),
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                primary: false,
                children: [
                  Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) =>
                              HomePage(loggedInbaby.baby_uid ?? ''))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Lottie.asset(
                              "assets/food.json",
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text('Feeding Info',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    //fontStyle: FontStyle.italic,
                                  )))
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) => SensorScreen())),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Lottie.asset(
                              "assets/health.json",
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text('Health Record',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    //fontStyle: FontStyle.italic,
                                  )))
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) => reqauth(widget.text))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Lottie.asset(
                              "assets/user.json",
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Text('Req for New Child',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    //fontStyle: FontStyle.italic,
                                  )))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
