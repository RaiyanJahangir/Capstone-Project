import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/screens/baby_info_as_nurturer.dart';
import 'package:email_password_login/screens/register_child.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/req_auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:email_password_login/screens/notification_screen.dart';


import '../model/babies_model.dart';
import 'baby_info_as_guardian.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> with TickerProviderStateMixin {
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
  ChildModel n = ChildModel();
  ChildModel logch = ChildModel();
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
    String a='hello';
    FirebaseFirestore.instance.collection('Babies').doc('baby2').get().then((DocumentSnapshot ds) {
      a=ds['name'];
    });
    print(a);
  }

  @override
  Widget build(BuildContext context) {
    TabController tt=TabController(length: 4, vsync: this);
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
          margin: const EdgeInsets.only(bottom: 50.0),
          child: Column(children: [
            Container(
              color: Colors.blue,
            child: TabBar(
            controller: tt,
            tabs: [
              Tab(text: 'Reg Child' ),
              Tab(text: 'Req Auth'),
              Tab(text: 'Guardian',),
              Tab(text: 'Nurturer',)
            ],
            ),
          ),
          Container(
          width: double.maxFinite,
          height: 500,
          child: TabBarView(
            controller: tt,
            children: [
              RegisterChild(),
              reqauth(),
              itemCount > 0
                  ? ListView.builder(
                      itemCount: Access!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(0),
                          color: Colors.blue[100],
                          child: ListTile(
                            title: Text(Access![index]),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          guardian_homepage(Access![index])));
                            },
                          ),
                        );
                      })
                  : Center(child: const Text('Don\'t have any child')),
              nitemCount > 0
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
                            child: Text(
                              nstrone,
                            ),
                          ),
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(15),
                          color: Colors.green[100],
                        );
                      }).toList(),
                    )
                  : Center(child: const Text('Don\'t have any child'))
          ],
          ),
          )
          ]),
        ));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
