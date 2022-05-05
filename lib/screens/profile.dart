import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:email_password_login/screens/info_card.dart';

String myEmail = '';
int age = 0;
String gender = '';
String name = '';
String occupation = '';
const occu = "Banker";
const email = "nasifshahriar4@gmail.com";
const gen = "Male"; // not real number :)
String ag = "25";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  String myEmail = '';
  int age = 0;
  String gender = '';
  String name = '';
  String occupation = '';
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

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
              Expanded(child: Text('User Profile')),
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
                                  log(context);
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
      body: Center(
        child: FutureBuilder(
          future: _fetch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Text("Loading data...Please wait");
            return displayUserInformation(context, snapshot);
          },
        ),
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    final user = snapshot.data;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          minimum: const EdgeInsets.only(top: 100),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 200,
                backgroundImage: AssetImage('assets/avatar.jpg'),
              ),
              Text(
                "Nasif Shahriar",
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.blueGrey[800],
                  fontWeight: FontWeight.bold,
                  fontFamily: "Pacifico",
                ),
              ),

              SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.blueGrey[1000],
                ),
              ),

              // we will be creating a new widget name info carrd

              InfoCard(text: email, icon: Icons.email, onPressed: () async {}),
              InfoCard(text: occu, icon: Icons.work, onPressed: () async {}),
              InfoCard(text: gen, icon: Icons.man, onPressed: () async {}),
              InfoCard(
                  text: ag,
                  icon: Icons.confirmation_number_sharp,
                  onPressed: () async {}),
            ],
          ),
        ));
  }
}

_fetch() async {
  final firebaseUser = await FirebaseAuth.instance.currentUser;
  if (firebaseUser != null)
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(firebaseUser.uid)
        .get()
        .then((ds) {
      name = ds.data()!['Name'] ?? '';
      myEmail = ds.data()!['Email'] ?? '';
      gender = ds.data()!['Gender'] ?? '';
      age = ds.data()!['Age'] ?? '';
      occupation = ds.data()!['Occupation'] ?? '';
    }).catchError((e) {
      print(e);
    });
}

Future<void> log(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).popUntil((route) => route.isFirst);
}
