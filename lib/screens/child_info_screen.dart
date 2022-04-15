import 'package:cloud_firestore/cloud_firestore.dart';
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
  const ChildInfoScreen({Key? key}) : super(key: key);

  @override
  ChildInfoScreenState createState() => ChildInfoScreenState();
}

class ChildInfoScreenState extends State<ChildInfoScreen> {
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
    //var nm="Nasif Shahriar";
    var baby_name = "John Cameron";
    var dob = "25/03/1999";
    var gender = "Male";
    var baby_height = "75.2cm";
    var baby_weight = "5kg";
    var blood_group = "A+";
    var baby_age = "5mo";
    var bbc = "234678909";
    var guardians = ["Jack Cameron", "Nasif Shahriar", "Mahapara Naim"];

    var wo = MediaQuery.of(context).size.width;
    var wh = MediaQuery.of(context).size.height;

    //entire list
    List<Widget> bd = [
      Container(child: Padding(padding: EdgeInsets.only(right: 0.2 * wo))),
      // Container(
      //   child: Text('Baby Information',
      //       style: TextStyle(
      //           fontWeight: FontWeight.w200,
      //           fontSize: wh * 0.035,
      //           height: 3,
      //           fontStyle: FontStyle.italic)),
      // ),

      Container(
          child: Divider(
              color: Colors.white, endIndent: 0.1 * wo, indent: 0.1 * wo)),
      //taking for a row
      Row(children: <Widget>[
        Padding(padding: EdgeInsets.only(right: 0.1 * wo)),
        Text('Name: ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: wh * 0.02,
                height: 2)),
        Text(baby_name,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: wh * 0.02, height: 2))
      ]),

      //taking for a row
      Row(children: <Widget>[
        Padding(padding: EdgeInsets.only(right: 0.1 * wo)),
        Text('Date Of Birth: ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: wh * 0.02,
                height: 2)),
        Text(dob,
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
        Text(gender,
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
        Text(baby_height,
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
        Text(baby_weight,
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
        Text(blood_group,
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
        Text(baby_age,
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
        Text(bbc,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: wh * 0.02, height: 2))
      ]),

      //taking for a row
      Row(children: <Widget>[
        Padding(padding: EdgeInsets.only(right: 0.1 * wo)),
        Text('List Of Guardians: ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: wh * 0.02,
                height: 1.5)),
        Text('',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: wh * 0.02, height: 2))
      ]),

      //taking for a row
    ];
    //entire list

    var checkedValue = true;
    for (var i = 0; i < guardians.length; i++) {
      bd.add(Padding(
          padding: EdgeInsets.only(left: 0.05 * wo),
          child: CheckboxListTile(
            title: Text(guardians[i]),
            value: checkedValue,
            onChanged: (newValue) {
              setState(() {
                checkedValue = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          )));
    }

    bd.add(Padding(padding: EdgeInsets.only(top: 0.02 * wh)));
    bd.add(Padding(
        padding: EdgeInsets.all(0.02 * wo),
        child: ElevatedButton(
          onPressed: () {
            bd.removeAt(bd.length - 3);
            print("removed\n");
          },
          child: Text('Revoke Auth Button',
              style: TextStyle(fontWeight: FontWeight.bold)),
        )));

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Text('Child Details')),
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
        body: Container(child: Column(children: bd)),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
