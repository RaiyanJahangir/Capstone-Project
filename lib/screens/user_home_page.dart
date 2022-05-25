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
import 'package:email_password_login/screens/req_auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  ChildModel logch=ChildModel();
  List? Access;
  List? nAccess;
  List? bname;
  int itemCount = 0;
  int nitemCount = 0;
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
      setState(() {
        Access = loggedInUser.gaccess;
        nAccess = loggedInUser.naccess;
        if (Access!.isNotEmpty) {
          itemCount = Access!.length;
        }
        if (nAccess!.isNotEmpty) {
          nitemCount = nAccess!.length;
        }
        print(loggedInUser.name);
      });
    });
    // for (int i = 0; i < Access!.length; i++) {
    //   FirebaseFirestore.instance
    //       .collection("Babies")
    //       .doc(Access![i])
    //       .get()
    //       .then((value) {
    //     // ignore: unnecessary_this
    //     this.logch = ChildModel.fromMap(value.data());
    //     setState(() {
    //       print(logch.name);
    //       bname = [logch.name];
    //     });
    //   });
    //   print(bname);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
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
          child: Column(children: [
            Expanded(
              flex: 3,
              child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                padding: EdgeInsets.all(8),
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
                            flex: 3,
                            child: Lottie.asset(
                              "assets/child_animation.json",
                              width: 150,
                              height: 150,
                              fit: BoxFit.fill,
                            ),
                          ),
                          // Container(
                          //   height: 30,
                          //   width: 80,
                          //   child: Text(
                          //     'Register Baby',
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       color: Colors.blue[400],
                          //       fontWeight: FontWeight.bold,
                          //       fontStyle: FontStyle.normal,
                          //     ),
                          //   ),
                          // ),
                          // Text(
                          //   'Register Baby',
                          //   style: TextStyle(
                          //     fontSize: 20,
                          //     color: Colors.blue[400],
                          //     fontWeight: FontWeight.bold,
                          //     fontStyle: FontStyle.normal,
                          //   ),
                          // ),
                          // Text(
                          //   'Register Baby',
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     color: Colors.blue[400],
                          //     fontWeight: FontWeight.bold,
                          //     fontStyle: FontStyle.normal,
                          //   ),
                          // ),
                          // Text(
                          //   'List Of Babies',
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     color: Colors.blueGrey[400],
                          //     fontWeight: FontWeight.bold,
                          //     fontStyle: FontStyle.normal,
                          //     decoration: TextDecoration.underline,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Expanded(flex: 1, child: Text('Register Baby')),
            Text(
              'Register Baby',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue[400],
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            ),
            SizedBox(height: 5),

            Text(
              'List Of Babies',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey[400],
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Guardians of:",
              style: TextStyle(
                  color: Colors.blue[400],
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              flex: 2,
              child: itemCount > 0
                  ? ListView(
                      children: Access!.map((strone) {
                        return Container(
                          child: InkWell(
                            onTap: () {
                              //print('hei');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          guardian_homepage(strone)));
                            },
                            child: new Text(
                              strone + " " + " " + " " + "(G)",
                            ),
                          ),
                        )
                    )
                ),
                Expanded(
                  flex: 2,
                  child: itemCount > 0
                      ? ListView.builder(
                      itemCount: Access!.length,
                      itemBuilder: (BuildContext context,int index){
                        return Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(0),
                          color: Colors.blue[100],
                          child: ListTile(
                            title: Text(Access![index]),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          guardian_homepage(Access![index])));
                            },
                          ),
                        );
                      }
                  )
                  // ListView(
                  //   children: Access!.map((strone) {
                  //     return Container(
                  //       child: InkWell(
                  //         onTap: () {
                  //           //print('hei');
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       guardian_homepage(strone)));
                  //         },
                  //         child: new Text(
                  //           strone,
                  //         ),
                  //       ),
                  //       margin: EdgeInsets.all(5),
                  //       padding: EdgeInsets.all(15),
                  //       color: Colors.blue[100],
                  //     );
                  //   }).toList(),
                  // )
                      : Center(child: const Text('Don\'t have any child')),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text('Nurturers of ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                              fontSize: 20
                          ),
                        )
                    )
                ),
                Expanded(
                  flex: 2,
                  child: nitemCount > 0
                      ? ListView(
                    children: nAccess!.map((nstrone) {
                      return Container(
                        child: InkWell(
                          onTap: () {
                            //print('hei');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        nurturer_homepage(nstrone)));
                          },
                          child: new Text(
                            nstrone,
                          ),
                        ),
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(15),
                        color: Colors.green[100],
                      );
                    }).toList(),
                  )
                      : Center(child: const Text('Don\'t have any child')),
                ),
                Expanded(
                  flex: 1,
                    child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.blue,
                    onSurface: Colors.blue[900],
                  ),
                  onPressed: () {Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) => reqauth()));},
                  child: Text('Req For Auth'),
                ))
              ]
          ),
        )
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

