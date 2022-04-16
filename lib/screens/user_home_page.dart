// ignore_for_file: prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers
//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/babies_model.dart';
import 'package:email_password_login/screens/baby_info_as_guardian.dart';
import 'package:email_password_login/screens/baby_info_as_nurturer.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/screens/register_child.dart';
import 'package:email_password_login/screens/registration_screen.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:email_password_login/screens/notification_screen.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  // ignore: prefer_typing_uninitialized_variables
  var selectType, selectGurd;
  var selectedType, selectedCat;
  // ignore: prefer_final_fields
  List<String> _gurdType = <String>[
    'Baby1',
    'Baby2',
    'Baby3',
    'Baby4',
    'Baby5',
    'Baby6',
  ];
  final selectedTypeEditingController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get()
        .then((value) {
      // ignore: unnecessary_this
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    // FirebaseFirestore.instance
    //     .collection("Babies")
    //     .doc(user!.uid)
    //     .get()
    //     .then((value) {
    //   // ignore: unnecessary_this
    //   this.loggedInUser = ChildModel.fromMap(value.data());
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: (){},),
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Text('Home Page')),
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
              flex: 5,
              child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                primary: false,
                children: [
                  Card(
                    elevation: 1,
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterChild(),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Expanded(
                            flex: 4,
                            child: Lottie.asset(
                              "assets/child_animation.json",
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Register Child',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue[400],
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => guardian_homepage()));
              },
              child: Text('Guardian'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => nurturer_homepage()));
              },
              child: Text('Nurturer'),
            ),
            Expanded(
              child: DropdownButton(
                borderRadius: BorderRadius.circular(10),
                items: _gurdType
                    .map((value) => DropdownMenuItem(
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors.blue[400],
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          value: value,
                        ))
                    .toList(),
                onChanged: (selectedGurdType) {
                  setState(() {
                    selectType = selectedGurdType;
                  });
                },
                value: selectType,
                isExpanded: false,
                hint: Text(
                  "Select Type Of Viewer",
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // child: StreamBuilder<QuerySnapshot>(
              //   stream:
              //       FirebaseFirestore.instance.collection("Babies").snapshots(),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return Text("Loading");
              //     }
              //     return Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       // ignore: prefer_const_literals_to_create_immutables
              //       children: <Widget>[
              //         Icon(
              //           Icons.payments_outlined,
              //           size: 30,
              //           color: Colors.black,
              //         ),
              //         SizedBox(
              //           width: 20,
              //         ),
              //         DropdownButton(
              //             // ignore: prefer_const_literals_to_create_immutables
              //             items: snapshot.data!.docs
              //                 .map((DocumentSnapshot document) {
              //               return DropdownMenuItem(
              //                 value: document.get("Name"),
              //                 // ignore: unnecessary_string_interpolations
              //                 child: Text('${document.get("Name")}'),
              //                 onTap: () {
              //                   selectedTypeEditingController.text =
              //                       document.get("Name");
              //                 },
              //               );
              //             }).toList(),
              //             onChanged: (catValue) {
              //               setState(() {
              //                 selectedCat = catValue;
              //               });
              //             },
              //             value: selectedCat,
              //             isExpanded: false,
              //             // ignore: unnecessary_new
              //             hint: new Text(
              //               "List of babies",
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             )),
              //       ],
              //     );
              //   },
              // ),
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
  // Future<void> logout(BuildContext context) async {
  //   await FirebaseAuth.instance.signOut();
  //   Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (context) => LoginScreen()));
  // }
}
