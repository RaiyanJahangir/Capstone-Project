import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/babies_model.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:email_password_login/screens/notification_screen.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:email_password_login/screens/sensor_screen.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/screens/baby_info_as_guardian.dart';
import 'package:email_password_login/screens/baby_info_as_nurturer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ChildInfoScreen extends StatefulWidget {
  final String text;
  const ChildInfoScreen(@required this.text, {Key? key}) : super(key: key);

  @override
  ChildInfoScreenState createState() => ChildInfoScreenState();
}

class ChildInfoScreenState extends State<ChildInfoScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String? child = FirebaseFirestore.instance.collection("Babies").id;
  UserModel loggedInUser = UserModel();
  ChildModel loggedInbaby = ChildModel();
  List? guardian;
  int itemCount=0;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Babies")
        .doc(widget.text)
        .get()
        .then((value) {
      this.loggedInbaby = ChildModel.fromMap(value.data());
      setState(() {
        guardian=loggedInbaby.guardian;
        if (guardian!.isNotEmpty) {
          itemCount = guardian!.length;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    var wo = MediaQuery.of(context).size.width;
    var wh = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          centerTitle: true,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Text('Baby Details')),
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
            margin: EdgeInsets.all(24),
            child: SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 0.1 * wo)),
                    Text('Name: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: wh * 0.02,
                            height: 2)),
                    Text("${loggedInbaby.name}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: wh * 0.02, height: 2))
                  ]),
                  Row(children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 0.1 * wo)),
                    Text('Date Of Birth: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: wh * 0.02,
                            height: 2)),
                    Text("${loggedInbaby.dob}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: wh * 0.02, height: 2))
                  ]),

                  //taking for a row
                  Row(children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 0.1 * wo)),
                    Text('Gender: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: wh * 0.02,
                            height: 2)),
                    Text("${loggedInbaby.gender}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: wh * 0.02, height: 2))
                  ]),

                  //taking for a row
                  Row(children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 0.1 * wo)),
                    Text('Height: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: wh * 0.02,
                            height: 2)),
                    Text("${loggedInbaby.h8}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: wh * 0.02, height: 2))
                  ]),

                  //taking for a row
                  Row(children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 0.1 * wo)),
                    Text('Weight: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: wh * 0.02,
                            height: 2)),
                    Text("${loggedInbaby.w8}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: wh * 0.02, height: 2))
                  ]),

                  //taking for a row
                  Row(children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 0.1 * wo)),
                    Text('Blood Group: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: wh * 0.02,
                            height: 2)),
                    Text("${loggedInbaby.bloodGrp}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: wh * 0.02, height: 2))
                  ]),

                  //taking for a row
                  Row(children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 0.1 * wo)),
                    Text('Age: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: wh * 0.02,
                            height: 2)),
                    Text("${loggedInbaby.age}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: wh * 0.02, height: 2))
                  ]),
                  //taking for a row
                  Row(children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 0.1 * wo)),
                    Text('Birth Certificate: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: wh * 0.02,
                            height: 1.5)),
                    Text("${loggedInbaby.birthCertNo}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: wh * 0.02, height: 2))
                  ]),
                  Row(children: <Widget>[
                    Padding(padding: EdgeInsets.only(right: 0.1 * wo)),
                    Text('List Of Guardians: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: wh * 0.02,
                            height: 1.5)),
                    // itemCount > 0 ? ListView(
                    //   children: guardian!.map((strone){
                    //     return Container(
                    //       child: InkWell(
                    //         onTap: () {
                    //         },
                    //         child: new Text(
                    //           strone,
                    //         ),
                    //       ),
                    //       margin: EdgeInsets.all(5),
                    //       padding: EdgeInsets.all(15),
                    //       color: Colors.blue[100],
                    //     );
                    //   }
                    //   ).toList(),
                    // ) : Text(' Error Loading Guardian... '),
                  ]),
                ],
              ),
          )
        ),
      );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
