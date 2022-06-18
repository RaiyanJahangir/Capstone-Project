import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/vaccine_model.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_password_login/model/babies_model.dart';

import 'package:email_password_login/screens/Vaccine_Feeding.dart';
import 'package:intl/intl.dart';

class NewTask extends StatefulWidget {
  @override
  final String text;

  const NewTask(@required this.text, {Key? key}) : super(key: key);
  _newTaskState createState() => _newTaskState();
}

class _newTaskState extends State<NewTask> {
  CollectionReference users = FirebaseFirestore.instance.collection("vaccines");
  TextEditingController vaccinename = new TextEditingController();
  TextEditingController vaccinedate = new TextEditingController();
  TextEditingController vaccinereason = new TextEditingController();

  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final vaccinenameEditingController = TextEditingController();
  final vaccinedateEditingController = DateTime.now();
  final vaccinereasonEditingController = TextEditingController();
  final vaccine2nddateEditingController = TextEditingController();
  final vaccine3rddateEditingController = TextEditingController();
  final vaccineuidEditingController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  ChildModel loggedInbaby = ChildModel();

  bool first = false;
  bool second = false;
  bool third = false;

  List<int> selectedList = [];

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
              Expanded(child: Text('Vaccination List')),
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
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Name of the Vaccine",
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
                        controller: vaccinenameEditingController,
                        decoration: InputDecoration(
                            fillColor: Colors.blue.withOpacity(0.2),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              //borderSide: BorderSide(color: Color.blue ,width: 5.0),
                            ),
                            hintText: "Vaccine Name"),
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
                          "Vaccination Date :",
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
                              Icons.calendar_today,
                            ),
                            onPressed: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1999, 1),
                                lastDate: DateTime(2030, 12),
                              );
                            },
                          ),
                          hintText: "Due Date",
                        ),

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
                          "Number of Doses :",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                    CheckboxListTile(
                      title: Text(
                        "First Dose",
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            selectedList.add(1);
                          } else {
                            selectedList.remove(1);
                          }
                        });
                      },
                      value: selectedList.contains(1),
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Second Dose",
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            selectedList.add(2);
                          } else {
                            selectedList.remove(2);
                          }
                        });
                      },
                      value: selectedList.contains(2),
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Third Dose",
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            selectedList.add(3);
                          } else {
                            selectedList.remove(3);
                          }
                        });
                      },
                      value: selectedList.contains(3),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About the Vaccine :",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15)),
                                border: Border.all(
                                    color: Colors.blue.withOpacity(0.5))),
                            child: TextField(
                              controller: vaccinereasonEditingController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: " Add description about vaccine",
                              ),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)),
                                border: Border.all(
                                    color: Colors.blue.withOpacity(0.5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [Container()],
                            ),
                          ),
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
                              child: TextButton(
                                child: const Text(
                                  'Submit!!',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                onPressed: () {
                                  final DateTime now = DateTime.now();
                                  final DateFormat formatter =
                                      DateFormat('dd-MM-yyyy');
                                  final String formatted =
                                      formatter.format(now);
                                  //print(formatted);
                                  final oneeightyDaysFromNow =
                                      now.add(const Duration(days: 180));
                                  final DateFormat formatter2nd =
                                      DateFormat('dd-MM-yyyy');
                                  final String formatted2nd =
                                      formatter.format(oneeightyDaysFromNow);
                                  final oneyearDaysFromNow =
                                      now.add(const Duration(days: 365));
                                  final DateFormat formatter3rd =
                                      DateFormat('dd-MM-yyyy');
                                  final String formatted3rd =
                                      formatter.format(oneyearDaysFromNow);

                                  sendData(
                                      vaccinenameEditingController.text,
                                      vaccinereasonEditingController.text,
                                      formatted,
                                      vaccine2nddateEditingController.text,
                                      formatted2nd,
                                      formatted3rd);
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
    String vaccinename,
    String vaccinedate,
    String vaccinereason,
    String vaccine2nddate,
    String vaccine3rddate,
    String vaccineuid,
  ) async {
    User? user = auth.currentUser;

    //ChildModel? babies = auth.currentUser;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('vaccines').doc();
    String? docId = documentReference.id;

    final QuerySnapshot qSnap =
        await FirebaseFirestore.instance.collection('vaccines').get();
    final int a = qSnap.docs.length;
    String d = a.toString();
    String vaccine_uid = "vaccine" + d;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    UserModel userModel = UserModel();
    VaccineModel vaccineModel = VaccineModel();

    vaccineModel.uid = loggedInbaby.baby_uid;

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    //print(formatted);
    final oneeightyDaysFromNow = now.add(const Duration(days: 180));
    final DateFormat formatter2nd = DateFormat('dd-MM-yyyy');
    final String formatted2nd = formatter.format(oneeightyDaysFromNow);
    final oneyearDaysFromNow = now.add(const Duration(days: 365));
    final DateFormat formatter3rd = DateFormat('dd-MM-yyyy');
    final String formatted3rd = formatter.format(oneyearDaysFromNow);

    vaccineModel.vaccinename = vaccinenameEditingController.text;
    vaccineModel.vaccinedate = formatted;
    vaccineModel.vaccinereason = vaccinereasonEditingController.text;
    vaccineModel.vaccine2nddate = formatted2nd;
    vaccineModel.vaccine3rddate = formatted3rd;

    //userModel.gaccess?.add(vaccine_uid);

    await firebaseFirestore
        .collection("vaccines")
        .doc(vaccine_uid)
        .set(vaccineModel.toMap());
    ////await uid = users model<-doc users->collec access array add "baby" + d
    //Fluttertoast.showToast(msg: "Baby Registered");

    await firebaseFirestore
        .collection("Babies")
        .doc(loggedInbaby.baby_uid)
        .update(loggedInbaby.addnewvaccineuid(vaccine_uid));

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(loggedInbaby.baby_uid ?? '')));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
