import 'package:email_password_login/screens/profile.dart';
import 'package:flutter/material.dart';
import 'Vaccine_Feeding.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/model/babies_model.dart';
import 'package:email_password_login/model/feeding_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedingList extends StatefulWidget {
  @override
  final String text;

  const FeedingList(@required this.text, {Key? key}) : super(key: key);
  _newTaskState createState() => _newTaskState();
}

class _newTaskState extends State<FeedingList> {
  // CollectionReference users = FirebaseFirestore.instance.collection("users");
  TextEditingController name = new TextEditingController();
  TextEditingController date = new TextEditingController();
  TextEditingController reason = new TextEditingController();
  String colorgrp = '';

  TimeOfDay timeofday = TimeOfDay.now();

  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final feedingtype = TextEditingController();
  final feedingtime = DateTime.now();
  final feedingitem = TextEditingController();
  final feeding2nd = TextEditingController();
  final feeding3rd = TextEditingController();
  final medicinename = TextEditingController();
  //final vaccineuidEditingController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  ChildModel loggedInbaby = ChildModel();

  List<int> selectedList = [];
  List<int> medselectedList = [];

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
    return new Scaffold(
      backgroundColor: Colors.white,
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
              Expanded(child: Text('Feeding List')),
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
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: 30,
              color: Color(0xfff90CAF9),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Meal Type(Breakfast etc)",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                    // Text(
                    //   "Meal Type(Breakfast,lunch etc)",
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.blue.withOpacity(0.2),
                      child: TextField(
                        controller: feedingtype,
                        decoration: InputDecoration(
                            fillColor: Colors.blue.withOpacity(0.2),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              //borderSide: BorderSide(color: Color.blue ,width: 5.0),
                            ),
                            hintText: " Meal Type(Breakfast,lunch etc)"),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Feeding Time",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.blue.withOpacity(0.2),
                      child: TextField(
                        //controller: feedingtime,
                        decoration: InputDecoration(
                            fillColor: Colors.blue.withOpacity(0.2),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              //borderSide: BorderSide(color: Color.blue ,width: 5.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.punch_clock,
                              ),
                              onPressed: () {
                                showTimePicker(
                                        context: context,
                                        initialTime: timeofday)
                                    .then((value) {
                                  setState(() {
                                    timeofday = value!;
                                  });
                                });
                              },
                            ),
                            hintText: "Feeding Time"),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Feeding Item",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.blue.withOpacity(0.2),
                      child: TextField(
                        controller: feedingitem,
                        decoration: InputDecoration(
                            fillColor: Colors.blue.withOpacity(0.2),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              //borderSide: BorderSide(color: Color.blue ,width: 5.0),
                            ),
                            hintText: "Feeding Item"),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Any Medication ?",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: '1',
                              groupValue: colorgrp,
                              onChanged: (val) {
                                setState(() {
                                  colorgrp = val as String;
                                  if (val != '1') {
                                    Text('hii');
                                    // ignore: prefer_const_constructors
                                    TextField(
                                      decoration: InputDecoration(
                                          labelText: 'Medicine Name',
                                          labelStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.red,
                                          )),
                                      enabled: false,
                                    );
                                  } else {
                                    Text('oo');
                                    TextField(
                                      enabled: true,
                                    );
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("Yes"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: '2',
                              groupValue: colorgrp,
                              onChanged: (val) {
                                setState(() {
                                  colorgrp = val as String;
                                  if (val != '2') {
                                    Text('hello');
                                    TextField(
                                      enabled: false,
                                    );
                                  } else {
                                    TextField(
                                      enabled: true,
                                    );
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("NO"),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Medicine Name(If any?)",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                      ],
                    ),

                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.blue.withOpacity(0.2),
                      child: TextField(
                        controller: medicinename,
                        decoration: InputDecoration(
                            fillColor: Colors.blue.withOpacity(0.2),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              //borderSide: BorderSide(color: Color.blue ,width: 5.0),
                            ),
                            hintText: "Medicine Name"),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Color(0xffff90CAF9)),
                            child: Center(
                              child: FlatButton(
                                child: const Text(
                                  'Submit!!',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                onPressed: () {
                                  final DateTime now = DateTime.now();
                                  final DateFormat formatter =
                                      DateFormat('HH:mm:ss');
                                  final String formatted =
                                      formatter.format(now);

                                  //print(formatted);
                                  final oneeightyDaysFromNow =
                                      now.add(const Duration(hours: 5));
                                  final DateFormat formatter2nd =
                                      DateFormat('HH:mm:ss');
                                  final String formatted2nd =
                                      formatter.format(oneeightyDaysFromNow);

                                  final oneyearDaysFromNow =
                                      now.add(const Duration(hours: 9));
                                  final DateFormat formatter3rd =
                                      DateFormat('HH:mm:ss');
                                  final String formatted3rd =
                                      formatter.format(oneyearDaysFromNow);

                                  sendData(
                                      feedingtype.text,
                                      feedingitem.text,
                                      formatted,
                                      formatted2nd,
                                      formatted3rd,
                                      feeding2nd.text,
                                      medicinename.text);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage(
                                            loggedInbaby.baby_uid ?? '')),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendData(
    String feedingitem,
    String feedingtype,
    String feedingtime,
    String feeding2ndtime,
    String feeding3rdtime,
    String vaccineuid,
    String medicinename,
  ) async {
    User? user = auth.currentUser;

    //ChildModel? babies = auth.currentUser;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('feeding').doc();
    String? docId = documentReference.id;

    final QuerySnapshot qSnap =
        await FirebaseFirestore.instance.collection('feeding').get();
    final int a = qSnap.docs.length;
    String d = a.toString();
    String feeding_uid = "feeding" + d;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    UserModel userModel = UserModel();
    FeedingModel feedingModel = FeedingModel();

    feedingModel.uid = loggedInbaby.baby_uid;

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('HH:mm:ss');
    final String formatted = formatter.format(now);

    //print(formatted);
    final oneeightyDaysFromNow = now.add(const Duration(hours: 5));
    final DateFormat formatter2nd = DateFormat('HH:mm:ss');
    final String formatted2nd = formatter.format(oneeightyDaysFromNow);

    final oneyearDaysFromNow = now.add(const Duration(hours: 9));
    final DateFormat formatter3rd = DateFormat('HH:mm:ss');
    final String formatted3rd = formatter.format(oneyearDaysFromNow);

    feedingModel.foodtype = feedingtype;
    feedingModel.foodtime = formatted;
    feedingModel.fooditem = feedingitem;
    feedingModel.food2 = formatted2nd;
    feedingModel.food3 = formatted3rd;
    feedingModel.medication = medicinename;

    //userModel.gaccess?.add(vaccine_uid);

    await firebaseFirestore
        .collection("feeding")
        .doc(feeding_uid)
        .set(feedingModel.toMap());
    ////await uid = users model<-doc users->collec access array add "baby" + d
    //Fluttertoast.showToast(msg: "Baby Registered");

    await firebaseFirestore
        .collection("Babies")
        .doc(loggedInbaby.baby_uid)
        .update(loggedInbaby.addnewfeedinguid(feeding_uid));

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(loggedInbaby.baby_uid ?? '')));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
